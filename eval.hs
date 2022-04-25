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

type Environment = [ (String, Expr)]

type Kontinuation = [Frame]

type State = (Expr, Environment, Kontinuation)

--Continuous evaluation until terminatable
eval :: ([Expr], Environment, Kontinuation) -> IO ([Expr], Environment)
eval ([], env, _) = return ([], env)
evak (x:xs, env, k) = do (x', env', k') <- eval1 (x, env, k)
                         if (x' == x) && (isValue x') && (null k) then do
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



--Evaluation function
eval1 :: State -> IO State


--Variable
eval1 (Var x, env, k) = return (x', env, k)
                      where x' = getValue x env


--Terminated expressions
eval1 (x, env, []) | isValue x = return (x, env, [])

eval1 (As x, env, AsFrame var:k) = return (AssignInt 0, update env var x, k)

--Import As
eval1 (Import (Var var1) (Var var2), env, k) = readTTL (var1++".ttl") >>= \content -> return (As $ FileLines content, env, AsFrame var2:k)


--Into
eval1 (Into (Var var) e2, env, k) = return (e2, update env var $ FileLines [], IntoFrame:k)
 
--eval1 (Get list1 list2, env, IntoFrame:k) 
--Export
eval1 (Export (Var var) , env, k) = do writeFile (var++".ttl") $ exportContent var env
                                       return (AssignInt 0, env, k)


getPosTurtles :: Expr -> (Expr, [Expr]) -> Environment -> Kontinuation -> (Environment, Kontinuation)
getPosTurtles empVar ((Var var), list1) env k = (env', k')
                                              where (FileLines content) = getValue var env
                                                    writeLines = getLines content env list1


--Apply the filters to the content of a ttl file to get what we want

getLines :: FileLines -> Environment -> FileLines
getLines content env [] = content
{-
getLines content env ((Subject):xs) = getLines content xs
getLines content env ((Predicate):xs) = getLines content xs
getLines content env ((Object):xs) = getLines content xs
getLines content env ((SubjectIn (Var var)):xs) = getLines content' xs
                                            where (FileLines varContent) = getValue var env
                                                  varSubjs = map getSubj varContent
                                                  (FileLines content') = [a | a <- content, ]
-}
--Get subject from a line of triple
getSubj :: String -> String
getSubj line = head $ words line

getPred :: String -> String
getPred line = head $ tail $ words line

getObj :: String -> String
getObj line = head $ tail $ reverse $ words line  

exportContent :: String -> Environment -> String
exportContent var env = intercalate "," x
                      where FileLines x = snd $ head [a | a <- env, fst a == var]







