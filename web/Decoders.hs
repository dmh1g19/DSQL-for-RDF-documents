{-# LANGUAGE OverloadedStrings #-}
module Decoders
  ( pointerDecoder
  , wheelDecoder
  , touchDecoder
  , sizeDecoder
  ) where

import Miso
import Data.Aeson (withObject, (.:))

-- | Where the mouse is, in window coordinates.
pointerDecoder :: Decoder (Double, Double)
pointerDecoder = Decoder
  { decodeAt = DecodeTarget mempty
  , decoder  = withObject "MouseEvent" $ \o -> (,) <$> o .: "clientX" <*> o .: "clientY"
  }

-- | Which way the wheel turned, and where the pointer is in the element.
wheelDecoder :: Decoder (Double, Double, Double)
wheelDecoder = Decoder
  { decodeAt = DecodeTarget mempty
  , decoder  = withObject "WheelEvent" $ \o ->
      (,,) <$> o .: "deltaY" <*> o .: "offsetX" <*> o .: "offsetY"
  }

-- | Where the first finger is, in window coordinates.
touchDecoder :: Decoder (Double, Double)
touchDecoder = Decoder
  { decodeAt = DecodeTarget ["touches", "0"]
  , decoder  = withObject "Touch" $ \o -> (,) <$> o .: "clientX" <*> o .: "clientY"
  }

-- | The size of the element an event happened on.
sizeDecoder :: Decoder (Double, Double)
sizeDecoder = Decoder
  { decodeAt = DecodeTarget ["target"]
  , decoder  = withObject "Element" $ \o -> (,) <$> o .: "clientWidth" <*> o .: "clientHeight"
  }
