import Tokens
import Grammar
import Eval
import System.Environment
import Control.Exception
import System.IO

-- alexScanTokens generates a list of tokens
-- where: alexScanTokens :: [Tokens] -> String

--main = do
--  fileName <- getArgs
--  output <- readFile $ head fileName
--  let toks = alexScanTokens output
--  print $ toks!!0
--  print $ parseCalc ([toks!!0])

{-
main = do
  (fileName : _ ) <- getArgs 
  sourceText <- readFile fileName
  putStrLn ("Parsing : " ++ sourceText)
  let parsedProg = reverse $ parseCalc (alexScanTokens sourceText)
  putStrLn ("Parsed as " ++ (show parsedProg) ++ "\n")
  (_, env') <- eval(parsedProg, [], [])
  putStrLn ("Program finished with env -> " ++ show env')
-}

main = do (fileName : _) <- getArgs
          sText <- readTTL fileName
          putStrLn (show sText)

