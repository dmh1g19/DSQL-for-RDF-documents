--Runs the test programs through the in-memory evaluator the browser uses, with
--the turtle files of this directory as its only files. Each prN.stql named on
--the command line must export outN exactly as expected/outN.ttl records it,
--and every program in bad/ must fail. Run it from the tests directory.
import InMemory
import Control.DeepSeq (force)
import Control.Exception
import Control.Monad
import Data.List (isSuffixOf, sort)
import System.Directory (listDirectory)
import System.Environment (getArgs)
import System.Exit

main :: IO ()
main = do tests <- getArgs
          ttls <- filter (".ttl" `isSuffixOf`) <$> listDirectory "."
          files <- forM ttls $ \f -> (,) (take (length f - 4) f) <$> readFile f
          good <- forM tests (check files)
          bad <- sort . filter (".stql" `isSuffixOf`) <$> listDirectory "bad"
          rejected <- forM bad (reject files)
          unless (and (good ++ rejected)) exitFailure

run :: [(String, String)] -> FilePath -> IO (Either SomeException [(String, String)])
run files program = do source <- readFile program
                       try (evaluate (force (runInMemory source files)))

check :: [(String, String)] -> String -> IO Bool
check files i = do result <- run files ("pr" ++ i ++ ".stql")
                   expected <- readFile ("expected/out" ++ i ++ ".ttl")
                   let ok = either (const False) ((== Just expected) . lookup ("out" ++ i)) result
                   putStrLn $ "in-memory pr" ++ i ++ if ok then " ok" else " FAILED"
                   return ok

reject :: [(String, String)] -> FilePath -> IO Bool
reject files b = do result <- run files ("bad/" ++ b)
                    let ok = either (const True) (const False) result
                    putStrLn $ "in-memory bad/" ++ b ++ if ok then " ok (rejected)" else " FAILED (was accepted)"
                    return ok
