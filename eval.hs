module Eval where
import Grammar
import Tokens
import System.IO
import Control.Monad ()
import Control.Exception
import Data.List
import System.Environment ()
import Data.Maybe


readTTL :: FilePath -> IO [String]
readTTL file = readFile file >>= \content -> return (lines content)

data Frame = AsFrame String | IntoFrame
      deriving (Show, Eq)

type Environment = [(String, Expr)]

type Kontinuation = [Frame]

type State = (Expr, Environment, Kontinuation)

--Continuous evaluation until terminatable
eval :: ([Expr], Environment, Kontinuation) -> IO ([Expr], Environment)
eval ([], env, _) = return ([], env)
eval (x:xs, env, k) = do (x', env', k') <- eval1 (x, env, k)
                         if (x' == x) && (isValue x') && (null k) then do
                         eval (xs, env', k')
                         else do eval (x':xs, env', k')

evalLoop' :: (Expr, Environment, Kontinuation) -> (Expr, Environment, Kontinuation)
evalLoop' (x, env, k) | (x' == x) && (isValue x') && (null k) = (x', env', k')
                      | otherwise = eval1' (x', env', k')
                      where (x', env', k') = eval1' (x, env, k)

--Check if a string is numeric
isInteger s = case reads s :: [(Integer, String)] of
  [(_, "")] -> True
  _         -> False
 
isDouble s = case reads s :: [(Double, String)] of
  [(_, "")] -> True
  _         -> False
 
isNumeric :: String -> Bool
isNumeric s = isInteger s || isDouble s

--Look up the value of given string in environment
getValue :: String -> Environment -> Expr
getValue x [] = error $ "Not Found : Value binding for given variable" ++ x
getValue x ((y,e):env) | x == y = e
                       | otherwise = getValue x env
 
--Update environment
update :: Environment -> String -> Expr -> Environment
update env x e = (x,e) : env

--Check for terminating expressions
isValue :: Expr -> Bool
isValue (AssignInt _) = True
isValue (FileLines _) = True

isValue _ = False

--Predicate Lists
sepPredObjs :: String -> [String]
sepPredObjs [] = []
sepPredObjs xs = [x] ++ (sepPredObjs xs')
               where (x, xs') = sepPOs xs

sepPOs :: String -> (String, String)
sepPOs [] = ("","")
sepPOs (x:' ':';':' ':xs) = ([x], xs)
sepPOs (x:' ':'.':xs) = ([x], xs)
sepPOs (x:xs) = ([x] ++ x', xs')
              where (x', xs') = sepPOs xs

predListToTriple :: String -> [String]
predListToTriple x = [sub ++ " " ++ predObj ++ " ." | predObj <- predObjs]
                   where sub = addTBrac $ getSubj x
                         predObjs = sepPredObjs $ (x \\ sub)

isPredicateList :: String -> Bool
isPredicateList x = ';' `elem` x

--ObjectLists
sepObjs :: String -> [String]
sepObjs [] = []
sepObjs xs = [x] ++ (sepObjs xs')
           where (x, xs') = sepOs xs

sepOs :: String -> (String, String)
sepOs [] = ("","")
sepOs (x:' ':',':' ':xs) = ([x],xs)
sepOs (x:' ':'.':xs) = ([x],xs)
sepOs (x:xs) = ([x] ++ x', xs')
             where (x', xs') = sepOs xs

objListToTriple :: String -> [String]
objListToTriple x = [sub ++ " " ++ obj ++ " ." | obj <- objs]
                   where sub = (addTBrac $ getSubj x) ++ " " ++ (addTBrac $ getPred x) ++ " "
                         objs = sepObjs $ (x \\ sub)

isObjectList :: String -> Bool
isObjectList x = ',' `elem` x

--Prefix 
removeDot :: String -> String
removeDot (' ':xs) = removeDot (dropWhile (\a -> a == ' ') xs)
removeDot ('.':' ':xs) = reverse xs
removeDot x = reverse x

getPrefix :: String -> (String, String)
getPrefix ('@':'b':'a':'s':'e':' ':xs) = ("BASE", xs') where xs' = removeDot $ reverse xs
getPrefix ('@':'p':'r':'e':'f':'i':'x':' ':x:':':' ':xs) = ([x], xs') where xs' = removeDot $ reverse xs

--Absolute triple
absTriples :: [(String, String)] -> String -> String
absTriples pMap x = intercalate " " applied
                  where applied = map (applyAbs pMap) $ words x

getVals :: String -> [(String, String)] -> String
getVals val ((x,y):vals) | val == x = y
                         | otherwise = getVals val vals

splitPrefix :: String -> (String, String)
splitPrefix [] = ("","")
splitPrefix (x:':':xs) = ([x],xs)
splitPrefix (x:xs) = ([x] ++ x', xs') where (x', xs') = splitPrefix xs

applyAbs :: [(String, String)] -> String -> String
applyAbs _ [] = []
applyAbs _ ('.':[]) = "."
applyAbs _ x@('<':'h':'t':'t':'p':':':xs) = x
applyAbs vals x | (head x == '<') && (last x == '>') = (init $ getVals "BASE" vals) ++ (tail x)
applyAbs vals x | ':' `elem` x = exten ++ ys ++ ">"
                 where (y,ys) = splitPrefix x
                       prefixVal = init $ getVals y vals
                       exten | isSubsequenceOf "http://" prefixVal = prefixVal
                             | otherwise = (init $ getVals "BASE" vals) ++ (tail prefixVal)
applyAbs vals x = x
--Get Absolute Triples
--Step By Step:
-- Get all prefixes in one list (A)
-- Get all other lines in another list (B)
-- clean all lines in B of Predicate lists and Object Lists
-- clean list A into a hashmap 
-- resolve list B into getting all absoulte triples
getTriples :: [String] -> [String]
getTriples [] = []
getTriples content = [x | x <- triples, x /= ""]
                   where prefixes = filter (\a -> '@' `elem` a) content
                         normal = (content \\ prefixes)
                         clean1 = concat $ map clean $ map replaceT normal
                         prefixMap = map getPrefix prefixes
                         triples = map (absTriples prefixMap) clean1


clean :: String -> [String]
clean x | isPredicateList x = predListToTriple x
        | isObjectList x = objListToTriple x
        | otherwise = [x]

replaceT :: String -> String
replaceT [] = []
replaceT (x:'>':'<':xs) = [x] ++ "> <" ++ (replaceT xs)
replaceT (x:xs) = [x] ++ (replaceT xs)

--Writing to File
writeContent :: String -> String -> [(Expr, [Expr])] -> Environment -> Environment
writeContent _ _ [] env = env
writeContent "True" empVar ((Var var, list1):xs) env = writeContent "True" empVar xs env'
                                              where (StoreLines ifVar) = getValue ("IF-"++var) env
                                                    env' = do (b, s) <- ifVar
                                                              case b of
                                                                True -> writeUp empVar s list1 env
                                                                other -> env
writeContent "False" empVar ((Var var, list1):xs) env = writeContent "False" empVar xs env'
                                              where (StoreLines ifVar) = getValue ("IF-"++var) env
                                                    env' = do (b, s) <- ifVar
                                                              case b of
                                                                False -> writeUp empVar s list1 env
                                                                other -> env
writeContent "BASE" empVar ((Var var, list1):xs) env = writeContent "BASE" empVar xs env'
                                              where (StoreLines ifVar) = getValue ("IF-"++var) env
                                                    env' = do (b, s) <- ifVar
                                                              case b of
                                                                other -> writeUp empVar s list1 env

writeUp :: String -> String -> [Expr] -> Environment -> Environment
writeUp empVar s [] env = update env empVar (FileLines [s])
writeUp empVar s expr env = update env empVar (FileLines $ lastContent ++ [newContent])
                          where (FileLines lastContent) = getValue empVar env
                                newContent = formWords s expr

formWords :: String -> [Expr] -> String
formWords _ [] = "."
formWords s (x:xs) = (getWord s x) ++ " " ++ formWords s xs

getWord :: String -> Expr -> String
getWord s (Subject) = addTBrac $ getSubj s 
getWord s (Predicate) = addTBrac $ getPred s
getWord s (Object) | isSubsequenceOf "http://" val = addTBrac val
                   | otherwise = val
                   where val = getObj s
getWord _ (Var var) | isSubsequenceOf "http://" var = addTBrac var
                    | otherwise = var
getWord _ (TrueElem) = "true"
getWord _ (FalseElem) = "false"
getWord s _ = s
--Evaluating IF Statemtnets

evalCond :: Expr -> Environment -> Environment
evalCond conds env = env'
                   where evaluatedConds = evalCond' conds env
                         env' = updateEC evaluatedConds env  

updateEC :: [(String, [(Bool, String)])] -> Environment -> Environment
updateEC [] env = env
updateEC ((var, list1):xs) env = updateEC xs $ env'
                               where env' = update env ("IF-"++var) $ StoreLines list1

evalCond' :: Expr -> Environment -> [(String, [(Bool, String)])]
evalCond' (Base (Var var) innerCond) env = [(var, allVals)]
                                         where (FileLines varVals) = getValue var env
                                               allVals = map (\a -> (applyCond innerCond a, a)) varVals

applyCond :: Expr -> String -> Bool
--InnerBase
applyCond (InnerBase (TrueElem)) _ = True
applyCond (InnerBase (FalseElem)) _ = False
applyCond (InnerBase y) x = applyTriple y x

--InnerOr
applyCond (InnerOr c1 c2) x = (applyCond c1 x) || (applyCond c2 x)

--InnerAnd
applyCond (InnerAnd c1 c2) x = (applyCond c1 x) && (applyCond c2 x)

--Triple Application
applyTriple (LTCond trip intVal) x = (<) (getTripleVal trip x) (show intVal)
applyTriple (GTCond trip intVal) x = (>) (getTripleVal trip x) (show intVal)
applyTriple (LTECond trip intVal) x = (<=) (getTripleVal trip x) (show intVal)
applyTriple (GTECond trip intVal) x = (>=) (getTripleVal trip x) (show intVal)
applyTriple (ECond trip intVal) x = (==) (getTripleVal trip x) (show intVal)

applyTriple (LessThan x1 x2) _ = (<) x1 x2
applyTriple (MoreThan x1 x2) _ = (>) x1 x2
applyTriple (LessThanEqual x1 x2) _ = (<=) x1 x2
applyTriple (MoreThanEqual x1 x2) _ = (>=) x1 x2

getTripleVal :: Expr -> String -> String
getTripleVal (Subject) x = getSubj x
getTripleVal (Predicate) x = getPred x
getTripleVal (Object) x = getObj x
getTripleVal (SubjectPlus i1) x | isNumeric $ cleanNumeric $ getSubj x = show $ (read $ cleanNumeric $ getSubj x) + i1
                                | otherwise = "a"
getTripleVal (PredicatePlus i1) x | isNumeric $ cleanNumeric $ getPred x = show $ (read $ cleanNumeric $ getPred x) + i1
                                  | otherwise = "a"
getTripleVal (ObjectPlus i1) x | isNumeric $ cleanNumeric $ getObj x = show $ (read $ cleanNumeric $ getObj x) + i1
                                  | otherwise = "a"
getTripleVal (SubjectMinus i1) x | isNumeric $ cleanNumeric $ getSubj x = show $ (read $ cleanNumeric $ getSubj x) - i1
                                | otherwise = "a"
getTripleVal (PredicateMinus i1) x | isNumeric $ cleanNumeric $ getPred x = show $ (read $ cleanNumeric $ getPred x) - i1
                                  | otherwise = "a"
getTripleVal (ObjectMinus i1) x | isNumeric $ cleanNumeric $ getObj x = show $ (read $ cleanNumeric $ getObj x) - i1
                                  | otherwise = "a"

cleanNumeric :: String -> String
cleanNumeric ('+':xs) = xs
cleanNumeric x = x
--Evaluation function
eval1 :: State -> IO State


--Variable
eval1 (Var x, env, k) = return (x', env, k)
                      where x' = getValue x env


--Terminated expressions
eval1 (x, env, []) | isValue x = return (x, env, [])

eval1 (As x, env, AsFrame var:k) = return (AssignInt 0, update env var x, k)

--Import As
eval1 (Import (Var var1) (Var var2), env, k) = readTTL (var1++".ttl") >>= \content -> return (As $ FileLines (getTriples content), env, AsFrame var2:k)


--Into
eval1 x@(Into (Var var) e2, env, k) = return $ eval1' x
 
eval1 (Get list1 list2, env, IntoFrame:k) = return (AssignInt 0, env', k)
                                where empVar = getEmptyVar env
                                      env' = getPosTurtles (Var empVar) list1 list2 env

--IFTHENELSE

eval1 (IfThenElse list1 trueBlock falseBlock, env, k) = return (AssignInt 0, falseEnv, falseK)
                                                      where env' = evalCond list1 env
                                                            (_,trueEnv,trueK) = evalLoop' (trueBlock, env', k)
                                                            (_,falseEnv,falseK) = evalLoop' (falseBlock, trueEnv, trueK)
--Write

eval1 x@(WriteTrue list2, env, IntoFrame:k) = return $ eval1' x

eval1 x@(WriteFalse list2, env, IntoFrame:k) = return $ eval1' x

eval1 x@(Write list2, env, IntoFrame:k) = return $ eval1' x

--Export
eval1 (Export (Var var) , env, k) = return (AssignInt 0, update env var (FileLines $ [exportContent var env]), k)


eval1 x@(NothingG, env, k) = return $ eval1' x 

eval1' :: State -> State

eval1' (Into (Var var) e2, env, k) = (e2, update env var $ FileLines [], IntoFrame:k)

eval1' (WriteTrue list2, env, IntoFrame:k) = (AssignInt 0, env', k)
                                      where empVar = getEmptyVar env
                                            env' = writeContent "True" empVar list2 env

eval1' (WriteFalse list2, env, IntoFrame:k) = (AssignInt 0, env', k)
                                      where empVar = getEmptyVar env
                                            env' = writeContent "False" empVar list2 env

eval1' (Write list2, env, IntoFrame:k) = (AssignInt 0, env', k)
                                      where empVar = getEmptyVar env
                                            env' = writeContent "BASE" empVar list2 env

eval1' (NothingG, env, k) = (AssignInt 0, env, k)
eval1' x = x

getPosTurtles :: Expr -> [Expr] -> [(Expr, [Expr])] -> Environment -> Environment
getPosTurtles empVar format [] env = env
getPosTurtles (Var empVar) format (((Var var), list1):vars) env = getPosTurtles (Var empVar) format vars env'
                                              where (FileLines content) = getValue var env
                                                    zipped = zip format list1
                                                    (FileLines writeLines) = getLines zipped env (FileLines content)
                                                    (FileLines lastContent) = getValue empVar env
                                                    env' = update env empVar $ (FileLines $ lastContent ++ writeLines)


--Apply the filters to the content of a ttl file to get what we want

getLines :: [(Expr, Expr)] -> Environment -> Expr -> Expr
getLines [] _ (FileLines content) = FileLines content
getLines (x:xs) env (FileLines content) = getLines xs env $ getLines' x env (FileLines content)

getLines' :: (Expr, Expr) -> Environment -> Expr -> Expr
--Base Cases
getLines' (Subject, Subject) _ (FileLines content) = FileLines content
getLines' (Predicate, Predicate) _ (FileLines content) = FileLines content
getLines' (Object, Object) _ (FileLines content) = FileLines content

--Subjects
getLines' (Subject, Predicate) _ (FileLines content) = FileLines content'
                                       where preds = [getPred a | a <- content]
                                             content' = [a | a <- content, (getSubj a) `elem` preds]

getLines' (Subject, Object) _ (FileLines content) = FileLines content'
                                       where preds = [getObj a | a <- content]
                                             content' = [a | a <- content, (getSubj a) `elem` preds]

getLines' (Subject, SubjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getSubj a | a <- vals]
                                             content' = [a | a <- content, (getSubj a) `elem` preds]

getLines' (Subject, PredicateIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getPred a | a <- vals]
                                             content' = [a | a <- content, (getSubj a) `elem` preds]

getLines' (Subject, ObjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getObj a | a <- vals]
                                             content' = [a | a <- content, (getSubj a) `elem` preds]

--Predicates
getLines' (Predicate, Subject) _ (FileLines content) = FileLines content'
                                       where preds = [getSubj a | a <- content]
                                             content' = [a | a <- content, (getPred a) `elem` preds]

getLines' (Predicate, Object) _ (FileLines content) = FileLines content'
                                       where preds = [getObj a | a <- content]
                                             content' = [a | a <- content, (getPred a) `elem` preds]

getLines' (Predicate, SubjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getSubj a | a <- vals]
                                             content' = [a | a <- content, (getPred a) `elem` preds]

getLines' (Predicate, PredicateIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getPred a | a <- vals]
                                             content' = [a | a <- content, (getPred a) `elem` preds]

getLines' (Predicate, ObjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getObj a | a <- vals]
                                             content' = [a | a <- content, (getPred a) `elem` preds]

--Objects
getLines' (Object, Predicate) _ (FileLines content) = FileLines content'
                                       where preds = [getPred a | a <- content]
                                             content' = [a | a <- content, (getObj a) `elem` preds]

getLines' (Object, Subject) _ (FileLines content) = FileLines content'
                                       where preds = [getSubj a | a <- content]
                                             content' = [a | a <- content, (getObj a) `elem` preds]

getLines' (Object, SubjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getSubj a | a <- vals]
                                             content' = [a | a <- content, (getObj a) `elem` preds]

getLines' (Object, PredicateIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getPred a | a <- vals]
                                             content' = [a | a <- content, (getObj a) `elem` preds]

getLines' (Object, ObjectIn (Var var)) env (FileLines content) = FileLines content'
                                       where (FileLines vals) = getValue var env
                                             preds = [getObj a | a <- vals]
                                             content' = [a | a <- content, (getObj a) `elem` preds]

--Variables
getLines' (Subject, (Var var)) _ (FileLines content) = FileLines [a | a <- content, (getSubj a) == var]
getLines' (Predicate, (Var var)) _ (FileLines content) = FileLines [a | a <- content, (getPred a) == var]
getLines' (Object, (Var var)) _ (FileLines content) = FileLines [a | a <- content, (getObj a) == var]


--True
getLines' (Subject, TrueElem) _ (FileLines content) = FileLines [a | a <- content, (getSubj a) == "true"]
getLines' (Predicate, TrueElem) _ (FileLines content) = FileLines [a | a <- content, (getPred a) == "true"]
getLines' (Object, TrueElem) _ (FileLines content) = FileLines [a | a <- content, (getObj a) == "true"]

--False
getLines' (Subject, FalseElem) _ (FileLines content) = FileLines [a | a <- content, (getSubj a) == "false"]
getLines' (Predicate, FalseElem) _ (FileLines content) = FileLines [a | a <- content, (getPred a) == "false"]
getLines' (Object, FalseElem) _ (FileLines content) = FileLines [a | a <- content, (getObj a) == "false"]

getLines' _ _ x = x

--Get subject from a line of triple
removeTBrac :: String -> String
removeTBrac ('<':line) = init line
removeTBrac line = line

addTBrac :: String -> String
addTBrac x = "<" ++ x ++ ">"
 
getSubj :: String -> String
getSubj line = removeTBrac $ head $ words line

getPred :: String -> String
getPred line = removeTBrac $ head $ tail $ words line

getObj :: String -> String
getObj line = removeTBrac $ head $ tail $ reverse $ words line  

addObjBrac :: String -> String
addObjBrac x | isSubsequenceOf "http://" x = addTBrac x
             | otherwise = x

cleanUp :: String -> String
cleanUp x = (addTBrac $ getSubj x) ++ " " ++ (addTBrac $ getPred x) ++ " " ++ (addObjBrac $ cleanNumeric $ getObj x) ++ " ."

removeInEnv :: Environment -> String -> Environment
removeInEnv env var = [a | a <- env, fst a /= var]

getEmptyVar :: Environment -> String
getEmptyVar ((x,y):env) | y == FileLines [] = x
                        | otherwise = getEmptyVar env

cleanSort :: [String] -> [String]
cleanSort x = nub $ map cleanUp $ sortBySP x

sortBySP :: [String] -> [String]
sortBySP x = sortBy (\a b -> compare a b) x

getSP :: String -> String
getSP x = (getSubj x) ++ " " ++ (getPred x)

sortByPredicate :: [String] -> [String]
sortByPredicate x = sortBy (\a b -> compare (getPred a) (getPred b)) x

exportContent :: String -> Environment -> String
exportContent var env = intercalate "\n" $ cleanSort x
                      where (FileLines x) = getValue var env








