module InMemory (runInMemory) where
import Tokens
import Grammar
import Eval
import Control.DeepSeq (deepseq)
import qualified Data.Map.Strict as Map

--A directory held in memory: the turtle files a program can see, by name
--without the .ttl extension, and the names it has exported, newest first
data Disk = Disk (Map.Map String String) [String]

--Evaluation against a Disk. Every step runs before the next one, so a missing
--file or a failing EXPORT stops the program where it happens, as on disk.
newtype InMemory a = InMemory { runDisk :: Disk -> (a, Disk) }

instance Functor InMemory where
  fmap f m = m >>= return . f

instance Applicative InMemory where
  pure a = InMemory $ \d -> (a, d)
  mf <*> ma = mf >>= \f -> fmap f ma

instance Monad InMemory where
  m >>= f = InMemory $ \d -> case runDisk m d of
                               (a, d') -> runDisk (f a) d'

instance FileSystem InMemory where
  readTurtle name = InMemory $ \d@(Disk files _) ->
    case Map.lookup name files of
      Just content -> (content, d)
      Nothing      -> error $ name ++ ".ttl: no such file"
  --Like writeFile, the whole content is produced when it is written
  writeTurtle name content = InMemory $ \(Disk files names) ->
    content `deepseq` ((), Disk (Map.insert name content files) (record names))
    where record names | name `elem` names = names
                       | otherwise = name : names

--Run a program against the given turtle files, returning each file it
--exported with that file's content, in the order they were first exported
runInMemory :: String -> [(String, String)] -> [(String, String)]
runInMemory source inputs = [(name, files Map.! name) | name <- reverse names]
  where program = reverse $ parseCalc (alexScanTokens source)
        (_, Disk files names) = runDisk (eval (program, [], []))
                                        (Disk (Map.fromList inputs) [])
