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

main :: IO ()
main = catch main' noParse

main' = do
  (fileName : _ ) <- getArgs 
  sourceText <- readFile fileName
  let parsedProg = reverse $ parseCalc (alexScanTokens sourceText)
  (_, ((valName, FileLines (x:xs)):xss)) <- eval(parsedProg, [], [])
  putStrLn x

noParse :: ErrorCall -> IO ()
noParse e = do let err =  show e
               hPutStr stderr err
               return ()