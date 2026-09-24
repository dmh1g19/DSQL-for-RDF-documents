{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE JavaScriptFFI #-}
module Main where

import Miso
import qualified Data.Map.Strict as Map

import Types (Action (..), initialModel)
import Update (updateModel)
import View (viewModel)
import Examples (Example (..), examples)
import Format (str)

-- | GHCJS writes a bare page: give it a title, a viewport so phones get the
--   stacked layout rather than a shrunken desktop one, and an element to
--   mount on. Listeners on <body> itself are treated as passive, which would
--   stop the graph from keeping wheel and touch gestures to itself.
foreign import javascript unsafe
  "(function () { document.title = 'STQL - querying RDF documents';\
  \ var v = document.createElement('meta'); v.name = 'viewport';\
  \ v.content = 'width=device-width, initial-scale=1'; document.head.appendChild(v);\
  \ var m = document.createElement('div'); m.id = 'stql';\
  \ document.body.appendChild(m); })()"
  preparePage :: IO ()

main :: IO ()
main = do
  preparePage
  startApp App
    { initialAction = SelectExample (str (exampleName (head examples)))
    , model         = initialModel
    , update        = updateModel
    , view          = viewModel
      -- the viewport pans and zooms with these, which miso does not listen
      -- for by default; mouseleave does not bubble, so it is caught on the way down
    , events        = Map.union (Map.fromList [ ("mousemove",   False)
                                              , ("mouseleave",  True)
                                              , ("wheel",       False)
                                              , ("touchstart",  False)
                                              , ("touchmove",   False)
                                              , ("touchend",    False)
                                              , ("touchcancel", False)
                                              ])
                                defaultEvents
    , subs          = []
    , mountPoint    = Just "stql"
    , logLevel      = Off
    }
