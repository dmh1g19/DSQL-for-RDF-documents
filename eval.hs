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
                         putStrLn ("Kontinuation -> " ++ show k')
                         putStrLn ("Line evaluated as -> " ++ show x')
                         eval (xs, env', k')
                         else do eval (x':xs, env', k')

--Look up the value of given string in environment
getValue :: String -> Environment -> Expr
getValue x [] = error "Not Found : Value binding for given variable"
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
                   where sub = getSubj x
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
                   where sub = (getSubj x) ++ " " ++ (getPred x) ++ " "
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
applyAbs vals x | ':' `elem` x = (init $ getVals y vals) ++ ys ++ ">"
                 where (y,ys) = splitPrefix x
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
getTriples content = triples
                   where prefixes = filter (\a -> '@' `elem` a) content
                         normal = (content \\ prefixes)
                         clean1 = concat $ map clean normal
                         prefixMap = map getPrefix prefixes
                         triples = map (absTriples prefixMap) clean1


clean :: String -> [String]
clean x | isPredicateList x = predListToTriple x
        | isObjectList x = objListToTriple x
        | otherwise = [x]

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
eval1 (Into (Var var) e2, env, k) = return (e2, update env var $ FileLines [], IntoFrame:k)
 
eval1 (Get list1 list2, env, IntoFrame:k) = return (AssignInt 0, env', k)
                                where empVar = getEmptyVar env
                                      env' = getPosTurtles (Var empVar) list1 list2 env
--Export
eval1 (Export (Var var) , env, k) = do 
                                       writeFile (var++".ttl") $ exportContent var env
                                       return (AssignInt 0, env, k)


getPosTurtles :: Expr -> [Expr] -> [(Expr, [Expr])] -> Environment -> Environment
getPosTurtles empVar format [] env = env
getPosTurtles (Var empVar) format (((Var var), list1):vars) env = getPosTurtles (Var empVar) format vars env'
                                              where (FileLines content) = getValue var env
                                                    zipped = zip format list1
                                                    (FileLines writeLines) = getLines zipped env (FileLines content)
                                                    (FileLines lastContent) = getValue empVar env
                                                    env'' = removeInEnv env empVar
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


--Get subject from a line of triple
getSubj :: String -> String
getSubj line = head $ words line

getPred :: String -> String
getPred line = head $ tail $ words line

getObj :: String -> String
getObj line = head $ tail $ reverse $ words line  

removeInEnv :: Environment -> String -> Environment
removeInEnv env var = [a | a <- env, fst a /= var]

getEmptyVar :: Environment -> String
getEmptyVar ((x,y):env) | y == FileLines [] = x
                        | otherwise = getEmptyVar env

exportContent :: String -> Environment -> String
exportContent var env = intercalate "\n" x
                      where (FileLines x) = getValue var env







