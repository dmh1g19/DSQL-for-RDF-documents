{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
-- | Runs a query against the files held in the browser and prepares each file
--   it exported for display.
module Results (Export (..), runQuery, graphLimit) where

import Control.DeepSeq (NFData)
import Data.Char (intToDigit, isAsciiLower, isAsciiUpper, isDigit, ord)
import GHC.Generics (Generic)

import Graph (Term (..), Layout, layoutTriples)
import InMemory (runInMemory)

-- | A file the query exported.
data Export = Export
  { exportName    :: String                  -- ^ without the .ttl extension
  , exportText    :: String
  , exportHref    :: String                  -- ^ the file as a data: URL
  , exportTriples :: [(Term, Term, Term)]
  , exportLayout  :: Maybe Layout            -- ^ Nothing when too big to draw
  } deriving (Show, Eq, Generic, NFData)

-- | Results with more triples than this are shown as a table and as text only.
graphLimit :: Int
graphLimit = 150

-- | Run a query with the given (name, content) turtle files as its inputs.
runQuery :: String -> [(String, String)] -> [Export]
runQuery source files = map export (runInMemory source files)
  where
    export (name, text) = Export name text (dataUrl text) triples layout
      where triples = [ t | Just t <- map parseTriple (lines text) ]
            layout | length triples <= graphLimit = Just (layoutTriples triples)
                   | otherwise                    = Nothing

-- | A data: URL holding some turtle, percent-encoded as UTF-8.
dataUrl :: String -> String
dataUrl text = "data:text/turtle;charset=utf-8," ++ concatMap escape text
  where
    escape c | isAsciiUpper c || isAsciiLower c || isDigit c || c `elem` "-_.~" = [c]
             | otherwise = concatMap hex (utf8 (ord c))
    hex b = ['%', intToDigit (b `div` 16), intToDigit (b `mod` 16)]
    utf8 n
      | n < 0x80    = [n]
      | n < 0x800   = [0xC0 + n `div` 0x40, 0x80 + n `mod` 0x40]
      | n < 0x10000 = [0xE0 + n `div` 0x1000, 0x80 + n `div` 0x40 `mod` 0x40, 0x80 + n `mod` 0x40]
      | otherwise   = [ 0xF0 + n `div` 0x40000, 0x80 + n `div` 0x1000 `mod` 0x40
                      , 0x80 + n `div` 0x40 `mod` 0x40, 0x80 + n `mod` 0x40 ]

-- | A line of exported turtle, @<s> <p> o .@, as its three terms.
parseTriple :: String -> Maybe (Term, Term, Term)
parseTriple line = case words line of
  ws@(s : p : _ : _ : _) | last ws == "." -> Just (term s, term p, term (last (init ws)))
  _                                       -> Nothing
  where
    term w@('<' : rest) | last w == '>' = Iri (init rest)
    term w                              = Literal w
