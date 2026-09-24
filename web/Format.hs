{-# LANGUAGE MagicHash #-}
{-# LANGUAGE JavaScriptFFI #-}
-- | Turning Haskell values into text for the page.
--
--   ghcjs-base's pack forces a String and then reads it from JavaScript. When
--   GHC can see that a String built on the spot is only ever read by pack, it
--   may compile the String's thunks to run just once without being updated,
--   so JavaScript still finds thunks where it expects characters: they come
--   out as NaN, or the string is cut short. Strings are therefore copied into
--   cells that are already evaluated before they are packed, and numbers are
--   formatted by JavaScript.
module Format (str, int, fixed) where

import Data.JSString (JSString)
import qualified Data.JSString as JS
import GHC.Exts (Char (C#))

-- | A String as a MisoString.
str :: String -> JSString
str s = JS.pack (evaluated s)
{-# NOINLINE str #-}

-- | The same characters, in freshly built cells.
evaluated :: String -> String
evaluated []          = []
evaluated (C# c : cs) = let rest = evaluated cs in rest `seq` C# c : rest

-- | An Int in decimal.
int :: Int -> JSString
int = js_int

-- | A Double with the given number of decimal places.
fixed :: Int -> Double -> JSString
fixed = js_fixed

foreign import javascript unsafe "String($1)"
  js_int :: Int -> JSString

foreign import javascript unsafe "$2.toFixed($1)"
  js_fixed :: Int -> Double -> JSString
