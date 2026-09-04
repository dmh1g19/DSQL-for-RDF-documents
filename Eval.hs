module Eval where
import Grammar
import Tokens
import System.IO
import Control.Monad ()
import Control.Exception
import Data.List
import qualified Data.Set as Set
import System.Environment ()
import Data.Maybe


readTTL :: FilePath -> IO [String]
readTTL file = readFile file >>= \content -> return (lines content)

data Frame = AsFrame String | IntoFrame String
      deriving (Show, Eq)

--Which lines a WRITE form emits, given the per-line flags its IF recorded
data WriteMode = OnTrue | OnFalse | Always
      deriving (Show, Eq)

--Per-variable entries the IF machinery keeps in the environment: the flags a
--condition produced, and the lines an ELSE branch may still see
condKey, maskKey :: String -> String
condKey var = "IF-" ++ var
maskKey var = "ELSE-" ++ var

type Environment = [(String, Expr)]

type Kontinuation = [Frame]

--Per line of a file: whether an IF condition matched it, and the line itself
type Flags = [(Bool, String)]

--Those flags for each variable an IF condition mentioned
type CondFlags = [(String, Flags)]

type State = (Expr, Environment, Kontinuation)

--Step every statement of the program to a value in turn
eval :: ([Expr], Environment, Kontinuation) -> IO ([Expr], Environment)
eval ([], env, _) = return ([], env)
eval (x:xs, env, k) = do (x', env', k') <- eval1 (x, env, k)
                         if (x' == x) && (isValue x') && (null k)
                           then eval (xs, env', k')
                           else eval (x':xs, env', k')

--Run one block (an IF branch) to a value, handing the environment and
--continuation back to the caller
evalBlock :: State -> IO (Environment, Kontinuation)
evalBlock (x, env, k) = do (x', env', k') <- eval1 (x, env, k)
                           if (x' == x) && (isValue x') && (null k')
                             then return (env', k')
                             else evalBlock (x', env', k')

--Does a string parse as a whole integer and nothing else
isInteger :: String -> Bool
isInteger s = case reads s :: [(Integer, String)] of
  [(_, "")] -> True
  _         -> False
 
--Look up the value of given string in environment
getValue :: String -> Environment -> Expr
getValue x [] = error $ "Not found : no value bound to " ++ x
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
                   where (sub, rest) = splitWord x
                         predObjs = sepPredObjs rest

--Split the leading word off a line, keeping it exactly as written
splitWord :: String -> (String, String)
splitWord x = (w, dropWhile (== ' ') rest)
            where (w, rest) = break (== ' ') (dropWhile (== ' ') x)

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
objListToTriple x = [subPred ++ " " ++ obj ++ " ." | obj <- objs]
                   where (sub, rest) = splitWord x
                         (prd, rest') = splitWord rest
                         subPred = sub ++ " " ++ prd
                         objs = sepObjs rest'

isObjectList :: String -> Bool
isObjectList x = ',' `elem` x

--Prefix 
removeDot :: String -> String
removeDot (' ':xs) = removeDot (dropWhile (\a -> a == ' ') xs)
removeDot ('.':' ':xs) = reverse xs
removeDot x = reverse x

getPrefix :: String -> (String, String)
getPrefix ('@':'b':'a':'s':'e':' ':xs) = ("BASE", removeDot $ reverse xs)
getPrefix ('@':'p':'r':'e':'f':'i':'x':' ':xs) = (name, removeDot $ reverse val)
                                               where (name, rest) = break (== ':') xs
                                                     val = dropWhile (== ' ') $ drop 1 rest
getPrefix x = error $ "Unrecognised directive : " ++ x

--Absolute triple
absTriples :: [(String, String)] -> String -> String
absTriples pMap x = intercalate " " applied
                  where applied = map (applyAbs pMap) $ words x

getVals :: String -> [(String, String)] -> String
getVals val [] = error $ "Not Found : No prefix declared for " ++ val
getVals val ((x,y):vals) | val == x = y
                         | otherwise = getVals val vals

splitPrefix :: String -> (String, String)
splitPrefix [] = ("","")
splitPrefix (x:':':xs) = ([x],xs)
splitPrefix (x:xs) = ([x] ++ x', xs') where (x', xs') = splitPrefix xs

applyAbs :: [(String, String)] -> String -> String
applyAbs _ [] = []
applyAbs _ ('.':[]) = "."
applyAbs _ x@('<':'h':'t':'t':'p':':':_) = x
applyAbs vals x | (head x == '<') && (last x == '>') = (init $ getVals "BASE" vals) ++ (tail x)
applyAbs vals x | ':' `elem` x = exten ++ ys ++ ">"
                 where (y,ys) = splitPrefix x
                       prefixVal = init $ getVals y vals
                       exten | isInfixOf "http://" prefixVal = prefixVal
                             | otherwise = (init $ getVals "BASE" vals) ++ (tail prefixVal)
applyAbs _ x = x
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
                   where (prefixes, normal) = partition (elem '@') content
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
writeContent :: WriteMode -> String -> [(Expr, [Expr])] -> Environment -> Environment
writeContent _ _ [] env = env
writeContent mode out ((Var var, list1):xs) env = writeContent mode out xs env'
                              where (StoreLines flags) = getValue (condKey var) env
                                    (FileLines existing) = getValue out env
                                    env' = update env out (FileLines (existing ++ written))
                                    written = [render l | (b, l) <- flags, keep mode b]
                                    render l | null list1 = l
                                             | otherwise = formWords l list1
                                    keep OnTrue b = b
                                    keep OnFalse b = not b
                                    keep Always _ = True

formWords :: String -> [Expr] -> String
formWords _ [] = "."
formWords s (x:xs) = (getWord s x) ++ " " ++ formWords s xs

--One element of a written triple, taken from the line being written
getWord :: String -> Expr -> String
getWord l Subject   = addTBrac (getSubj l)
getWord l Predicate = addTBrac (getPred l)
getWord l Object    = addObjBrac (getObj l)
getWord _ (Var v)   = addObjBrac v
getWord _ (AssignInt n) = show n
getWord _ TrueElem  = "true"
getWord _ FalseElem = "false"
getWord l e         = fromMaybe l (triplePart e l)

--Shift a numeric triple position by n; a non-numeric value is left as it is
shiftNum :: String -> Int -> String
shiftNum v n | isInteger val = show (read val + n)
             | otherwise = v
             where val = cleanNumeric v
--Evaluating IF statements

--Lines a branch may still see; with no enclosing ELSE every line is eligible
lineMask :: String -> Environment -> [Bool]
lineMask var env = case lookup (maskKey var) env of
                     Just (StoreLines ms) -> map fst ms
                     _                    -> repeat True

--Restrict freshly evaluated flags to the lines this branch may still see
maskConds :: Environment -> CondFlags -> CondFlags
maskConds env conds = [(v, zipWith keep (lineMask v env) fs) | (v, fs) <- conds]
                    where keep m (b, l) = (m && b, l)

--An ELSE branch sees exactly the lines its IF condition did not match
elseMask :: CondFlags -> Environment -> Environment
elseMask conds env = foldl add env conds
                   where add e (v, fs) = update e (maskKey v) $ StoreLines
                                           (zipWith rest (lineMask v e) fs)
                         rest m (b, l) = (m && not b, l)

--Put the enclosing mask back, so later statements are unaffected
dropMask :: CondFlags -> Environment -> Environment -> Environment
dropMask conds outer env = foldl put env conds
                         where put e (v, fs) = update e (maskKey v) $
                                 fromMaybe (StoreLines [(True, l) | (_, l) <- fs])
                                           (lookup (maskKey v) outer)

updateEC :: CondFlags -> Environment -> Environment
updateEC [] env = env
updateEC ((var, list1):xs) env = updateEC xs $ env'
                               where env' = update env (condKey var) $ StoreLines list1

evalCond' :: Expr -> Environment -> CondFlags
evalCond' (Base (Var var) innerCond) env = [(var, allVals)]
                                         where (FileLines varVals) = getValue var env
                                               allVals = map (\a -> (applyCond innerCond a, a)) varVals
evalCond' (OrCond v c rest) env = mergeConds (||) (evalCond' (Base v c) env) (evalCond' rest env)
evalCond' (AndCond v c rest) env = mergeConds (&&) (evalCond' (Base v c) env) (evalCond' rest env)

--Flags for the same variable combine pointwise; different variables are kept apart
mergeConds :: (Bool -> Bool -> Bool) -> CondFlags -> CondFlags -> CondFlags
mergeConds op as bs = [(v, combine v fs) | (v, fs) <- as]
                      ++ [b | b@(v, _) <- bs, isNothing (lookup v as)]
                    where combine v fs = maybe fs (zipWith join fs) (lookup v bs)
                          join (b1, l) (b2, _) = (op b1 b2, l)

applyCond :: Expr -> String -> Bool
--InnerBase
applyCond (InnerBase (TrueElem)) _ = True
applyCond (InnerBase (FalseElem)) _ = False
applyCond (InnerBase (NotCond c)) x = not $ applyCond (InnerBase c) x
applyCond (InnerBase y) x = applyTriple y x

--InnerOr
applyCond (InnerOr c1 c2) x = (applyCond c1 x) || (applyCond c2 x)

--InnerAnd
applyCond (InnerAnd c1 c2) x = (applyCond c1 x) && (applyCond c2 x)

--Does one condition hold of a line
applyTriple :: Expr -> String -> Bool
applyTriple (LTCond trip intVal) x = cmpNum (<) trip intVal x
applyTriple (GTCond trip intVal) x = cmpNum (>) trip intVal x
applyTriple (LTECond trip intVal) x = cmpNum (<=) trip intVal x
applyTriple (GTECond trip intVal) x = cmpNum (>=) trip intVal x
applyTriple (ECond trip intVal) x = cmpNum (==) trip intVal x
applyTriple (NECond trip intVal) x = not $ cmpNum (==) trip intVal x

applyTriple (LessThan x1 x2) _ = (<) x1 x2
applyTriple (MoreThan x1 x2) _ = (>) x1 x2
applyTriple (LessThanEqual x1 x2) _ = (<=) x1 x2
applyTriple (MoreThanEqual x1 x2) _ = (>=) x1 x2

--Compare a triple position against an integer literal numerically.
--A non-integer value satisfies no comparison.
cmpNum :: (Integer -> Integer -> Bool) -> Expr -> Int -> String -> Bool
cmpNum op trip intVal x | isInteger val = op (read val) (toInteger intVal)
                        | otherwise = False
                        where val = cleanNumeric $ getTripleVal trip x

--The value a triple expression names in a line, with any +n or -n applied
triplePart :: Expr -> String -> Maybe String
triplePart e l | Just at <- position e = Just (at l)
triplePart (SubjectPlus i) l    = Just (shiftNum (getSubj l) i)
triplePart (PredicatePlus i) l  = Just (shiftNum (getPred l) i)
triplePart (ObjectPlus i) l     = Just (shiftNum (getObj l) i)
triplePart (SubjectMinus i) l   = Just (shiftNum (getSubj l) (negate i))
triplePart (PredicateMinus i) l = Just (shiftNum (getPred l) (negate i))
triplePart (ObjectMinus i) l    = Just (shiftNum (getObj l) (negate i))
triplePart _ _ = Nothing

--A triple expression that names nothing falls back to the whole line, which
--is never an integer, so it satisfies no comparison
getTripleVal :: Expr -> String -> String
getTripleVal e l = fromMaybe l (triplePart e l)

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
eval1 (Into (Var var) e2, env, k) = return (e2, env', IntoFrame var:k)
                                  where env' | isJust (lookup var env) = env
                                             | otherwise = update env var (FileLines [])
 
eval1 (Get format wheres, env, IntoFrame out:k) =
  return (AssignInt 0, getPosTurtles out format wheres env, k)

--IFTHENELSE

eval1 (IfThenElse list1 trueBlock falseBlock, env, k) =
  do (trueEnv, trueK) <- evalBlock (trueBlock, updateEC conds env, k)
     (falseEnv, falseK) <- evalBlock (falseBlock, elseMask conds trueEnv, trueK)
     return (AssignInt 0, dropMask conds env falseEnv, falseK)
  where conds = maskConds env $ evalCond' list1 env
--Write

eval1 (WriteTrue wheres, env, IntoFrame out:k) =
  return (AssignInt 0, writeContent OnTrue out wheres env, k)

eval1 (WriteFalse wheres, env, IntoFrame out:k) =
  return (AssignInt 0, writeContent OnFalse out wheres env, k)

eval1 (Write wheres, env, IntoFrame out:k) =
  return (AssignInt 0, writeContent Always out wheres env, k)

--Export
eval1 (Export (Var var) , env, k) = do writeFile (var ++ ".ttl") (content ++ "\n")
                                       return (AssignInt 0, update env var (FileLines [content]), k)
                                    where content = exportContent var env


eval1 (NothingG, env, k) = return (AssignInt 0, env, k)

--Forms the grammar allows but that only mean something inside an INTO block
eval1 (Get _ _, _, _)      = error "GET needs an enclosing INTO"
eval1 (Write _, _, _)      = error "WRITE needs an enclosing INTO"
eval1 (WriteTrue _, _, _)  = error "WRITETRUE needs an enclosing INTO"
eval1 (WriteFalse _, _, _) = error "WRITEFALSE needs an enclosing INTO"
eval1 (x, _, IntoFrame out:_)
  | isValue x = error $ "INTO " ++ out ++ " has no GET or WRITE block"
eval1 (e, _, _) = error $ "Cannot evaluate : " ++ show e

--Collect what each WHERE clause selects into the INTO target
getPosTurtles :: String -> [Expr] -> [(Expr, [Expr])] -> Environment -> Environment
getPosTurtles _ _ [] env = env
getPosTurtles out format ((Var var, filters):rest) env = getPosTurtles out format rest env'
                              where (FileLines content) = getValue var env
                                    (FileLines selected) = getLines (zip format filters) env (FileLines content)
                                    (FileLines existing) = getValue out env
                                    env' = update env out (FileLines (existing ++ selected))


--Apply the filters to the content of a ttl file to get what we want

getLines :: [(Expr, Expr)] -> Environment -> Expr -> Expr
getLines [] _ (FileLines content) = FileLines content
getLines (x:xs) env (FileLines content) = getLines xs env $ getLines' x env (FileLines content)

--Which word of a line a triple position names
type Position = String -> String

position :: Expr -> Maybe Position
position Subject   = Just getSubj
position Predicate = Just getPred
position Object    = Just getObj
position _         = Nothing

--The position and variable an IN filter refers to
inPosition :: Expr -> Maybe (Position, String)
inPosition (SubjectIn (Var v))   = Just (getSubj, v)
inPosition (PredicateIn (Var v)) = Just (getPred, v)
inPosition (ObjectIn (Var v))    = Just (getObj, v)
inPosition _                     = Nothing

--Apply one format/filter pair. A filter naming a position keeps the lines
--whose format position also appears in that position - somewhere in the same
--file, or in the file bound to a variable for the IN forms. A literal filter
--matches the format position exactly. Anything else leaves the lines alone.
getLines' :: (Expr, Expr) -> Environment -> Expr -> Expr
getLines' (fmt, filt) env whole@(FileLines content)
  | fmt == filt = whole
  | otherwise   = maybe whole select (position fmt)
  where select at | Just from <- position filt        = occursIn at (map from content)
                  | Just (from, v) <- inPosition filt = occursIn at (map from (linesOf v))
                  | Var v <- filt                     = equals at v
                  | AssignInt n <- filt                = equalsNum at n
                  | TrueElem <- filt                  = equals at "true"
                  | FalseElem <- filt                 = equals at "false"
                  | otherwise                         = whole
        occursIn at vals = FileLines [l | l <- content, at l `Set.member` valSet]
          where valSet = Set.fromList vals
        equals at v      = FileLines [l | l <- content, at l == v]
        equalsNum at n   = FileLines [l | l <- content, cleanNumeric (at l) == show n]
        linesOf v = ls where (FileLines ls) = getValue v env
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
addObjBrac x | isInfixOf "http://" x = addTBrac x
             | otherwise = x

cleanUp :: String -> String
cleanUp x = (addTBrac $ getSubj x) ++ " " ++ (addTBrac $ getPred x) ++ " " ++ (addObjBrac $ cleanNumeric $ getObj x) ++ " ."

removeInEnv :: Environment -> String -> Environment
removeInEnv env var = [a | a <- env, fst a /= var]

--Remove duplicates keeping the first occurrence - nub, without the quadratic
nubOrd :: [String] -> [String]
nubOrd = go Set.empty
       where go _ [] = []
             go seen (x:xs) | Set.member x seen = go seen xs
                            | otherwise = x : go (Set.insert x seen) xs

cleanSort :: [String] -> [String]
cleanSort x = nubOrd $ map cleanUp $ sortBySP x

sortBySP :: [String] -> [String]
sortBySP = sort

getSP :: String -> String
getSP x = (getSubj x) ++ " " ++ (getPred x)

sortByPredicate :: [String] -> [String]
sortByPredicate x = sortBy (\a b -> compare (getPred a) (getPred b)) x

exportContent :: String -> Environment -> String
exportContent var env = intercalate "\n" $ cleanSort x
                      where (FileLines x) = getValue var env








