{-# LANGUAGE OverloadedStrings #-}
module Types where

import Miso.String (MisoString)

import Results (Export)

-- ---------------------------------------------------------------------------
-- Model
-- ---------------------------------------------------------------------------

-- | How the output panel shows the selected export.
data OutputMode = GraphMode | TableMode | TurtleMode
  deriving (Show, Eq)

-- | What the last run of the query produced.
data Outcome
  = NotRun
  | Failed MisoString
  | Exported [Export]
  deriving (Show, Eq)

data Model = Model
  { query           :: MisoString
  , turtleFiles     :: [(MisoString, MisoString)]   -- ^ (name without .ttl, content)
  , newFileName     :: MisoString
  , newFileBody     :: MisoString
  , newFileError    :: MisoString
  , queryEpoch      :: Int
  , filesEpoch      :: Int
    -- ^ bumped whenever the text of the query editor, or of the file editors,
    --   is replaced rather than typed, so they are drawn afresh with it
  , runCount        :: Int      -- ^ which run the next result belongs to
  , outcome         :: Outcome
  , activeExport    :: Int
  , outputMode      :: OutputMode
  , isLoading       :: Bool
  , selectedExample :: MisoString
  , selectedDesc    :: MisoString
  , showPaper       :: Bool
  , vpZoom          :: Double
  , vpPanX          :: Double
  , vpPanY          :: Double
  , vpWidth         :: Double
  , vpHeight        :: Double
  , isDragging      :: Bool
  , lastMouseX      :: Double
  , lastMouseY      :: Double
  } deriving (Show, Eq)

initialModel :: Model
initialModel = Model
  { query           = ""
  , turtleFiles     = []
  , newFileName     = ""
  , newFileBody     = ""
  , newFileError    = ""
  , queryEpoch      = 0
  , filesEpoch      = 0
  , runCount        = 0
  , outcome         = NotRun
  , activeExport    = 0
  , outputMode      = GraphMode
  , isLoading       = False
  , selectedExample = ""
  , selectedDesc    = ""
  , showPaper       = False
  , vpZoom          = 1
  , vpPanX          = 0
  , vpPanY          = 0
  , vpWidth         = 0
  , vpHeight        = 0
  , isDragging      = False
  , lastMouseX      = 0
  , lastMouseY      = 0
  }

-- ---------------------------------------------------------------------------
-- Action
-- ---------------------------------------------------------------------------

data Action
  = NoOp
  | QueryChanged MisoString
  | RunQuery
  | QueryFinished Int Outcome
  | SelectExample MisoString
  | FileChanged Int MisoString
  | RemoveFile Int
  | NewFileNameChanged MisoString
  | NewFileBodyChanged MisoString
  | AddFile
  | SelectExport Int
  | SetOutputMode OutputMode
  | StartDrag Double Double
  | DragMove Double Double
  | StopDrag
  | MeasureViewport Double Double
  | WheelZoom Double Double Double
  | ZoomBy Double
  | ResetViewport
  | TogglePaper
  deriving (Show, Eq)
