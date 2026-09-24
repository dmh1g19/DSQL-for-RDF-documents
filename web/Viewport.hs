{-# LANGUAGE OverloadedStrings #-}
module Viewport (viewport) where

import Miso
import qualified Data.Map.Strict as Map

import Types (Action (..), Model (..))
import Decoders
import Format (fixed)

-- | A frame that pans when dragged or swiped and zooms when scrolled. The
--   content is drawn once; moving it only changes the wrapper's transform.
--   Its content ignores the pointer (see the stylesheet), so every event
--   lands on the frame itself and wheel offsets are measured within it.
viewport :: Model -> View Action -> View Action
viewport m content =
  div_ [ class_ "stql-viewport"
       , style_ (Map.singleton "cursor" (if isDragging m then "grabbing" else "grab"))
       , on "mouseenter" sizeDecoder (uncurry MeasureViewport)
       , on "mousedown" pointerDecoder (uncurry StartDrag)
       , on "mousemove" pointerDecoder (uncurry DragMove)
       , on "mouseleave" emptyDecoder (const StopDrag)
       , onWithOptions prevent "wheel" wheelDecoder (\(dy, x, y) -> WheelZoom dy x y)
       , onWithOptions prevent "touchstart" touchDecoder (uncurry StartDrag)
       , onWithOptions prevent "touchmove" touchDecoder (uncurry DragMove)
       , on "touchend" emptyDecoder (const StopDrag)
       , on "touchcancel" emptyDecoder (const StopDrag)
       ]
       [ div_ [ class_ "stql-viewport-inner", style_ (Map.singleton "transform" transform) ]
           [ content ]
       ]
  where
    prevent   = defaultOptions { preventDefault = True }
    transform = "translate(" <> fixed 1 (vpPanX m) <> "px," <> fixed 1 (vpPanY m)
                <> "px) scale(" <> fixed 4 (vpZoom m) <> ")"
