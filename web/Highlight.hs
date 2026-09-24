{-# LANGUAGE OverloadedStrings #-}
-- | Syntax highlighting for the query editor and for turtle text. The STQL
--   lexer here splits text exactly where Tokens.x does, so a character the
--   interpreter would reject shows up in red before the query is run.
module Highlight
  ( highlightStql
  , highlightTurtle
  , keywords
  , isNameStart
  , isNameChar
  ) where

import Miso
import Miso.String (MisoString)
import Data.Char (isAlpha, isAsciiLower, isAsciiUpper, isDigit)

import Format (str)

-- | Coloured spans for an STQL program.
highlightStql :: String -> [View action]
highlightStql = map render . stqlTokens

-- | Coloured spans for turtle text.
highlightTurtle :: String -> [View action]
highlightTurtle = map render . turtleTokens

-- | A token with the CSS class that colours it; whitespace has no class.
type Token = (MisoString, String)

render :: Token -> View action
render ("", s)  = text (str s)
render (cls, s) = span_ [ class_ cls ] [ text (str s) ]

-- ---------------------------------------------------------------------------
-- STQL, following Tokens.x
-- ---------------------------------------------------------------------------

-- | The words Tokens.x reads as keywords rather than as variables.
keywords :: [String]
keywords = statements ++ control ++ positions ++ ["true", "false"]

statements, control, positions :: [String]
statements = [ "IMPORT", "AS", "INTO", "GET", "WHERE", "FROM"
             , "WRITE", "WRITETRUE", "WRITEFALSE", "EXPORT" ]
control    = [ "IF", "THEN", "ELSE", "NOTHING", "AND", "OR", "NOT", "IN" ]
positions  = [ "subj", "pred", "obj" ]

-- | A variable is a letter followed by letters, digits and these symbols.
isNameStart, isNameChar :: Char -> Bool
isNameStart c = isAsciiUpper c || isAsciiLower c
isNameChar c  = isNameStart c || isDigit c || c `elem` (":_'.$|*?#~^/" :: String)

-- | Alex's $white.
isWhite :: Char -> Bool
isWhite c = c `elem` (" \t\n\r\f\v" :: String)

stqlTokens :: String -> [Token]
stqlTokens [] = []
stqlTokens s@(c : rest)
  | isWhite c              = let (w, r) = span isWhite s in ("", w) : stqlTokens r
  | c == '-', take 1 rest == "-"
                           = let (w, r) = break (== '\n') s in ("t-com", w) : stqlTokens r
  | isDigit c              = let (w, r) = span isDigit s in ("t-num", w) : stqlTokens r
  | isNameStart c          = let (w, r) = span isNameChar s in (classify w, w) : stqlTokens r
stqlTokens ('<' : '=' : r) = ("t-op", "<=") : stqlTokens r
stqlTokens ('>' : '=' : r) = ("t-op", ">=") : stqlTokens r
stqlTokens ('!' : '=' : r) = ("t-op", "!=") : stqlTokens r
stqlTokens (c : r)
  | c `elem` ("<>=+-" :: String)    = ("t-op", [c]) : stqlTokens r
  | c `elem` ("()[]{},;" :: String) = ("t-punct", [c]) : stqlTokens r
  | otherwise                       = ("t-err", [c]) : stqlTokens r

classify :: String -> MisoString
classify w
  | w `elem` statements      = "t-kw"
  | w `elem` control         = "t-ctl"
  | w `elem` positions       = "t-pos"
  | w `elem` ["true", "false"] = "t-bool"
  | any (`elem` (":/" :: String)) w = "t-iri"
  | otherwise                = "t-var"

-- ---------------------------------------------------------------------------
-- Turtle
-- ---------------------------------------------------------------------------

turtleTokens :: String -> [Token]
turtleTokens [] = []
turtleTokens s@(c : rest)
  | isWhite c = let (w, r) = span isWhite s in ("", w) : turtleTokens r
  | c == '@'  = let (w, r) = span isAlpha rest in ("t-dir", c : w) : turtleTokens r
  | c == '<'  = case break (`elem` (">\n" :: String)) rest of
                  (w, '>' : r) -> ("t-iri", c : w ++ ">") : turtleTokens r
                  (w, r)       -> ("t-err", c : w) : turtleTokens r
  | c == '"'  = let (w, r) = stringBody rest in ("t-str", c : w) : turtleTokens r
  | c `elem` (".;," :: String) = ("t-punct", [c]) : turtleTokens rest
  | otherwise = let (w, r) = break (\x -> isWhite x || x `elem` ("<\";," :: String)) s
                in  (turtleWord w, w) : turtleTokens r

-- | The rest of a string literal, up to and including its closing quote.
stringBody :: String -> (String, String)
stringBody ('\\' : x : r) = let (w, r') = stringBody r in ('\\' : x : w, r')
stringBody ('"' : r)      = ("\"", r)
stringBody s@('\n' : _)   = ("", s)
stringBody (x : r)        = let (w, r') = stringBody r in (x : w, r')
stringBody []             = ("", "")

turtleWord :: String -> MisoString
turtleWord w
  | w `elem` ["true", "false"] = "t-bool"
  | isNumber w                 = "t-num"
  | ':' `elem` w               = "t-pname"
  | otherwise                  = ""
  where
    isNumber ('-' : ds@(_ : _)) = all isDigit ds
    isNumber ('+' : ds@(_ : _)) = all isDigit ds
    isNumber ds@(_ : _)         = all isDigit ds
    isNumber []                 = False
