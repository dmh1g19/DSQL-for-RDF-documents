{-# LANGUAGE OverloadedStrings #-}
module Update (updateModel) where

import Miso
import qualified Data.JSString as JS
import Control.DeepSeq (force)
import Control.Exception (ErrorCall (..), SomeException, displayException, evaluate, fromException, try)
import Data.Char (isSpace)
import Data.List (find, findIndex, isSuffixOf)
import Data.Maybe (fromMaybe)

import Types
import Examples
import Format (str)
import Highlight (isNameChar, isNameStart, keywords)
import Results (Export (..), runQuery)

-- ---------------------------------------------------------------------------
-- Zoom constants
-- ---------------------------------------------------------------------------

zoomMin, zoomMax, zoomStep :: Double
zoomMin  = 0.2
zoomMax  = 10
zoomStep = 1.15

-- ---------------------------------------------------------------------------
-- Update
-- ---------------------------------------------------------------------------

updateModel :: Action -> Model -> Effect Action Model

updateModel NoOp m = noEff m

updateModel (QueryChanged q) m = noEff m { query = q }

-- The query runs in the effect, so the spinner is up while it evaluates.
updateModel RunQuery m = m { isLoading = True, runCount = run } <# do
  let source = JS.unpack (query m)
      files  = [ (JS.unpack n, JS.unpack c) | (n, c) <- turtleFiles m ]
  result <- try (evaluate (force (runQuery source files)))
  pure $ QueryFinished run $ case result of
    Left err      -> Failed (str (describe err))
    Right exports -> Exported exports
  where run = runCount m + 1

-- A result for anything but the latest run is stale and dropped.
updateModel (QueryFinished run o) m
  | run /= runCount m = noEff m
  | otherwise =
      noEff (resetViewport m { outcome = o, isLoading = False, activeExport = sameFile })
  where
    -- stay on the same exported file when it is still there
    sameFile = case (outcome m, o) of
      (Exported old, Exported new)
        | activeExport m < length old ->
            let name = exportName (old !! activeExport m)
            in  fromMaybe 0 (findIndex ((== name) . exportName) new)
      _ -> 0

updateModel (SelectExample name) m =
  case find ((== name) . str . exampleName) examples of
    Nothing -> noEff m { selectedExample = "", selectedDesc = "" }
    Just ex ->
      m { query           = str (exampleQuery ex)
        , turtleFiles     = [ (str n, str c) | (n, c) <- exampleFiles ex ]
        , selectedExample = name
        , selectedDesc    = str (exampleDesc ex)
        , newFileError    = ""
        , queryEpoch      = queryEpoch m + 1
        , filesEpoch      = filesEpoch m + 1
        } <# pure RunQuery

updateModel (FileChanged i content) m =
  noEff m { turtleFiles = [ if j == i then (n, content) else f
                          | (j, f@(n, _)) <- zip [0 ..] (turtleFiles m) ] }

updateModel (RemoveFile i) m =
  noEff m { turtleFiles = [ f | (j, f) <- zip [0 ..] (turtleFiles m), j /= i ] }

updateModel (NewFileNameChanged v) m = noEff m { newFileName = v, newFileError = "" }
updateModel (NewFileBodyChanged v) m = noEff m { newFileBody = v }

-- Adding a file under a name that is already taken replaces that file.
updateModel AddFile m =
  case checkName (JS.unpack (newFileName m)) of
    Left err   -> noEff m { newFileError = str err }
    Right name ->
      noEff m { turtleFiles  = replace (str name) (newFileBody m) (turtleFiles m)
              , newFileName  = ""
              , newFileBody  = ""
              , newFileError = ""
              , filesEpoch   = filesEpoch m + 1
              }
  where
    replace name body files
      | any ((== name) . fst) files = [ if n == name then (n, body) else f | f@(n, _) <- files ]
      | otherwise                   = files ++ [(name, body)]

updateModel (SelectExport i) m = noEff (resetViewport m { activeExport = i })

updateModel (SetOutputMode mode) m = noEff m { outputMode = mode }

-- Viewport: drag to pan
updateModel (StartDrag x y) m =
  noEff m { isDragging = True, lastMouseX = x, lastMouseY = y }

updateModel (DragMove x y) m
  | not (isDragging m) = noEff m
  | otherwise =
      noEff m { vpPanX     = vpPanX m + x - lastMouseX m
              , vpPanY     = vpPanY m + y - lastMouseY m
              , lastMouseX = x
              , lastMouseY = y
              }

updateModel StopDrag m
  | isDragging m = noEff m { isDragging = False }
  | otherwise    = noEff m

updateModel (MeasureViewport w h) m = noEff m { vpWidth = w, vpHeight = h }

-- Viewport: the wheel zooms towards the pointer, the buttons towards the
-- centre. Offsets are measured from the centre, the transform's origin.
updateModel (WheelZoom deltaY x y) m = noEff (zoomAt factor anchor m)
  where
    factor = if deltaY < 0 then zoomStep else 1 / zoomStep
    anchor | vpWidth m > 0 = (x - vpWidth m / 2, y - vpHeight m / 2)
           | otherwise     = (0, 0)

updateModel (ZoomBy factor) m = noEff (zoomAt factor (0, 0) m)

updateModel ResetViewport m = noEff (resetViewport m)

updateModel TogglePaper m = noEff m { showPaper = not (showPaper m) }

-- | Scale by a factor, keeping the point at the given offset from the centre
--   of the viewport where it is.
zoomAt :: Double -> (Double, Double) -> Model -> Model
zoomAt factor (ax, ay) m =
  m { vpZoom = z, vpPanX = ax - f * (ax - vpPanX m), vpPanY = ay - f * (ay - vpPanY m) }
  where
    z = max zoomMin (min zoomMax (vpZoom m * factor))
    f = z / vpZoom m

resetViewport :: Model -> Model
resetViewport m = m { vpZoom = 1, vpPanX = 0, vpPanY = 0 }

-- | The message of an interpreter error, without the call stack GHC adds.
describe :: SomeException -> String
describe err = case fromException err of
  Just (ErrorCall msg) -> msg
  Nothing              -> displayException err

-- | The name IMPORT will know a new file by, or why it could not name it.
checkName :: String -> Either String String
checkName raw
  | null name = Left "Give the file a name."
  | not (isNameStart (head name) && all isNameChar name) =
      Left "IMPORT can only name a file that starts with a letter and uses \
           \letters, digits and _ ' . : / # $ | * ? ~ ^"
  | name `elem` keywords = Left (name ++ " is a keyword, so IMPORT could not name it.")
  | otherwise = Right name
  where
    trimmed = reverse (dropWhile isSpace (reverse (dropWhile isSpace raw)))
    name | ".ttl" `isSuffixOf` trimmed = take (length trimmed - 4) trimmed
         | otherwise                   = trimmed
