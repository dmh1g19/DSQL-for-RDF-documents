import Tokens
import Grammar
import Eval
import System.Environment
import Control.Exception
import System.Exit
import System.IO

-- alexScanTokens generates a list of tokens
-- where: alexScanTokens :: [Tokens] -> String

main :: IO ()
main = do args <- getArgs
          case args of
            (fileName : _) -> catch (run fileName) failWith
            []             -> die "usage: stql <program.stql>"

--Parse and evaluate a program. EXPORT writes each output file; the most
--recently exported content is also echoed on stdout.
run :: FilePath -> IO ()
run fileName = do sourceText <- readFile fileName
                  let parsedProg = reverse $ parseCalc (alexScanTokens sourceText)
                  (_, env) <- eval (parsedProg, [], [])
                  case env of
                    ((_, FileLines (x:_)) : _) -> putStrLn x
                    _                          -> return ()

--Every failure - bad arguments, a missing file, a parse error, an evaluation
--error - is reported on stderr and exits non-zero.
failWith :: SomeException -> IO ()
failWith e = die (show e)
