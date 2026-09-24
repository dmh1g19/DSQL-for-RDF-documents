{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module View (viewModel) where

import Miso
import Miso.String (MisoString)
import qualified Data.JSString as JS
import Data.Char (isDigit)

import Types
import Styles (appCSS)
import Examples (Example (..), examples)
import Format (int, str)
import Highlight (highlightStql, highlightTurtle)
import Results (Export (..), graphLimit)
import Graph (Term (..), Layout (..))
import GraphView (viewGraph)
import Viewport (viewport)

-- ---------------------------------------------------------------------------
-- Top-level view
-- ---------------------------------------------------------------------------

viewModel :: Model -> View Action
viewModel m@Model {..} = div_ [ onMouseUp StopDrag ]
  [ -- Injected CSS
    node HTML "style" Nothing [] [ text appCSS ]
  , div_ [ class_ "stql-container" ]
      [ editorPanel
      , outputPanel
      ]
  , if showPaper then paperOverlay else text ""
  ]
  where
    -- =======================================================================
    -- Left panel: about, examples, query editor, turtle files
    -- =======================================================================
    editorPanel :: View Action
    editorPanel = div_ [ class_ "stql-editor" ]
      [ aboutSection
      , hr_ []
      , examplesSection
      , editorSection
      , filesSection
      , addFileSection
      ]

    aboutSection :: View Action
    aboutSection = div_ [ class_ "about" ]
      [ h1_ [] [ text "STQL" ]
      , p_ [ class_ "tagline" ] [ text "Querying RDF documents written in Turtle" ]
      , p_ []
          [ text "STQL is a "
          , em_ [] [ text "domain-specific language" ]
          , text " (DSL): a small language built for a single job, which here is \
                 \querying RDF graphs stored as Turtle files. A program IMPORTs \
                 \files, picks triples out of them with SQL-style GET \x2026 WHERE \
                 \patterns and IF \x2026 THEN conditions, rewrites them, and \
                 \EXPORTs the result as a new Turtle file."
          ]
      , p_ []
          [ text "Queries are tokenised with "
          , a_ [ href_ "https://haskell-alex.readthedocs.io/" ] [ text "Alex" ]
          , text ", parsed with "
          , a_ [ href_ "https://haskell-happy.readthedocs.io/" ] [ text "Happy" ]
          , text ", and evaluated by a small CEK-style machine that steps through \
                 \the program with an environment and a stack of continuation \
                 \frames. It all runs in your browser: this is the interpreter from \
                 \the command-line version, compiled to JavaScript with GHCJS, with \
                 \IMPORT and EXPORT reading and writing the files below instead of \
                 \the disk. The front-end is built with "
          , a_ [ href_ "https://haskell-miso.org/" ] [ text "Miso" ]
          , text ", which brings an Elm-like architecture to Haskell. Huge thanks \
                 \to the Miso team for making this possible!"
          ]
      , p_ []
          [ text "For the full story behind the language, "
          , a_ [ onClick TogglePaper, class_ "paper-link" ] [ text "read the report" ]
          , text "."
          ]
      ]

    examplesSection :: View Action
    examplesSection = div_ []
      [ h2_ [] [ text "Examples" ]
      , select_ [ onChange SelectExample, class_ "dropdown" ]
          ( option_ [ value_ "", selected_ (selectedExample == "") ] [ text "Select an example" ]
          : map optionView examples )
      , if selectedDesc == ""
          then text ""
          else p_ [ class_ "desc" ] [ text selectedDesc ]
      ]

    optionView :: Example -> View Action
    optionView ex = option_ [ value_ name, selected_ (name == selectedExample) ] [ text name ]
      where name = str (exampleName ex)

    editorSection :: View Action
    editorSection = div_ []
      [ h2_ [] [ text "Query Editor" ]
      , codeEditor "code-box query-box" ("query-" <> int queryEpoch)
          (highlightStql (JS.unpack query)) query QueryChanged
          [ onKeyDownWithInfo runShortcut ]
      , div_ [ class_ "run-row" ]
          [ button_ [ onClick RunQuery, class_ "btn" ] [ text "Run Query" ]
          , span_ [ class_ "hint" ] [ text "or press Ctrl+Enter in the editor" ]
          ]
      ]

    runShortcut :: KeyInfo -> Action
    runShortcut k
      | (ctrlKey k || metaKey k) && keyCode k == KeyCode 13 = RunQuery
      | otherwise                                           = NoOp

    filesSection :: View Action
    filesSection = div_ []
      [ h2_ [] [ text "Turtle Files:" ]
      , if null turtleFiles
          then p_ [ class_ "note" ] [ text "No files yet. Add one below, then IMPORT it by name." ]
          else div_ [] (zipWith fileCard [0 ..] turtleFiles)
      ]

    fileCard :: Int -> (MisoString, MisoString) -> View Action
    fileCard i (name, content) = div_ [ class_ "file-card" ]
      [ div_ [ class_ "file-head" ]
          [ span_ [ class_ "file-name" ]
              [ text (name <> ".ttl")
              , span_ [ class_ "file-meta" ] [ text (plural (lineCount content) "line") ]
              ]
          , button_ [ onClick (RemoveFile i), class_ "btn-remove" ] [ text "Remove" ]
          ]
      , codeEditor "code-box file-box" ("file-" <> int filesEpoch <> "-" <> name)
          (highlightTurtle (JS.unpack content)) content (FileChanged i) []
      ]

    addFileSection :: View Action
    addFileSection = div_ [ class_ "add-file" ]
      [ h2_ [] [ text "Add New File:" ]
      , div_ [ class_ "add-row" ]
          [ input_ [ placeholder_ "File name, e.g. people"
                   , value_ newFileName
                   , onInput NewFileNameChanged
                   , class_ "text-input" ]
          , button_ [ onClick AddFile, class_ "btn" ] [ text "Add File" ]
          ]
      , node HTML "textarea" (Just (Key ("new-" <> int filesEpoch)))
          [ placeholder_ "Paste Turtle here\x2026"
          , onInput NewFileBodyChanged
          , class_ "new-file-body"
          , boolProp "spellcheck" False ]
          [ text newFileBody ]
      , if newFileError == ""
          then text ""
          else p_ [ class_ "form-error" ] [ text newFileError ]
      ]

    -- =======================================================================
    -- Right panel: toolbar + output
    -- =======================================================================
    outputPanel :: View Action
    outputPanel = div_ [ class_ "stql-output" ]
      [ div_ [ class_ "output-toolbar" ]
          [ h1_ [] [ text "Query Output:" ]
          , div_ [ class_ "modes" ]
              [ modeButton GraphMode "Graph", modeButton TableMode "Table"
              , modeButton TurtleMode "Turtle" ]
          ]
      , outputBody
      ]

    modeButton :: OutputMode -> MisoString -> View Action
    modeButton mode label =
      button_ [ onClick (SetOutputMode mode), classList_ [ ("active", outputMode == mode) ] ]
        [ text label ]

    outputBody :: View Action
    outputBody
      | isLoading = box "" [ div_ [ class_ "message" ]
                               [ div_ [ class_ "spinner" ] [], text "Running query\x2026" ] ]
      | otherwise = case outcome of
          NotRun -> box "" [ message "Nothing to show yet"
                               "Pick an example, or write a query and press Run Query." ]
          Failed err -> box "scroll" [ div_ [ class_ "error-box" ]
                                         [ h3_ [] [ text "Error" ], pre_ [] [ text err ] ] ]
          Exported [] -> box "" [ message "Nothing was exported"
                                    "The query ran, but only files it EXPORTs are shown \
                                    \here. End it with EXPORT and the name you gave INTO." ]
          Exported exports -> exportView exports

    exportView :: [Export] -> View Action
    exportView exports = div_ [ class_ "output-main" ]
      [ div_ [ class_ "output-bar" ]
          [ div_ [ class_ "tabs" ] (zipWith tab [0 ..] exports)
          , div_ [ class_ "actions" ] (zoomControls ++ [ download ])
          ]
      , body
      ]
      where
        current = exports !! max 0 (min activeExport (length exports - 1))
        triples = exportTriples current
        drawable = maybe False (not . null . layoutNodes) (exportLayout current)

        body
          | null triples = box "" [ message (str (exportName current) <> ".ttl is empty")
                                      "The query ran and exported this file, but no triple matched." ]
          | otherwise = case outputMode of
              GraphMode  -> case exportLayout current of
                Just layout -> box "" [ viewport m (viewGraph layout) ]
                Nothing     -> box "" [ message "Too many triples to draw"
                                          ("The graph view draws up to " <> int graphLimit
                                           <> " triples. The Table and Turtle views show all "
                                           <> int (length triples) <> ".") ]
              TableMode  -> box "scroll" [ tableView triples ]
              TurtleMode -> box "scroll dark"
                              [ node HTML "pre" Nothing [ class_ "turtle-view" ]
                                  (highlightTurtle (exportText current)) ]

        zoomControls
          | outputMode == GraphMode && drawable && not (null triples) =
              [ span_ [ class_ "zoom-level" ]
                  [ text (int (round (vpZoom * 100)) <> "%") ]
              , button_ [ onClick (ZoomBy 1.25), class_ "btn-small", title_ "Zoom in" ] [ text "+" ]
              , button_ [ onClick (ZoomBy 0.8), class_ "btn-small", title_ "Zoom out" ] [ text "\x2212" ]
              , button_ [ onClick ResetViewport, class_ "btn-small" ] [ text "Reset" ]
              ]
          | otherwise = []

        download =
          a_ [ href_ (str (exportHref current))
             , download_ (str (exportName current) <> ".ttl")
             , class_ "download" ]
            [ text "Download" ]

    tab :: Int -> Export -> View Action
    tab i e =
      button_ [ onClick (SelectExport i), classList_ [ ("tab", True), ("active", i == activeExport) ] ]
        [ text (str (exportName e) <> ".ttl")
        , span_ [ class_ "count" ] [ text (plural (length (exportTriples e)) "triple") ]
        ]

    -- =======================================================================
    -- The report
    -- =======================================================================
    paperOverlay :: View Action
    paperOverlay = div_ [ class_ "paper-overlay" ]
      [ div_ [ class_ "paper-bar" ]
          [ span_ [] [ text "Report \x2014 a DSL for querying RDF Turtle documents" ]
          , div_ [ style_ ("display" =: "flex" <> "gap" =: "8px") ]
              [ a_ [ href_ "rdf.pdf", target_ "_blank" ] [ text "Open in new tab" ]
              , button_ [ onClick TogglePaper ] [ text "Close" ]
              ]
          ]
      , iframe_ [ src_ "rdf.pdf", class_ "paper-frame" ] []
      ]

-- ---------------------------------------------------------------------------
-- Pieces
-- ---------------------------------------------------------------------------

-- | A highlighted editor: a coloured <pre> under a transparent <textarea>.
--   The textarea gets its text as a child, which only sets it when the
--   element is created, so typing never has the cursor moved from under it;
--   a new key makes a new textarea when the text is replaced from outside.
codeEditor :: MisoString -> MisoString -> [View Action] -> MisoString
           -> (MisoString -> Action) -> [Attribute Action] -> View Action
codeEditor cls key highlighted content changed extra =
  div_ [ class_ cls ]
    [ div_ [ class_ "code-grid" ]
        [ node HTML "pre" Nothing [] (highlighted ++ [ text "\n" ])
        , node HTML "textarea" (Just (Key key))
            ([ onInput changed
             , boolProp "spellcheck" False
             , textProp "autocapitalize" "off"
             , textProp "autocomplete" "off" ] ++ extra)
            [ text content ]
        ]
    ]

-- | The output area below the toolbar.
box :: MisoString -> [View Action] -> View Action
box extra = div_ [ class_ ("output-box " <> extra) ]

message :: MisoString -> MisoString -> View Action
message title body = div_ [ class_ "message" ] [ h3_ [] [ text title ], text body ]

tableView :: [(Term, Term, Term)] -> View Action
tableView triples = table_ [ class_ "triples" ]
  [ thead_ [] [ tr_ [] [ th_ [] [ text "#" ], th_ [] [ text "Subject" ]
                       , th_ [] [ text "Predicate" ], th_ [] [ text "Object" ] ] ]
  , tbody_ [] [ tr_ [] [ td_ [ class_ "row-num" ] [ text (int i) ], cell s, cell p, cell o ]
              | (i, (s, p, o)) <- zip [1 :: Int ..] triples ]
  ]
  where
    cell (Iri iri)   = td_ [ class_ "v-iri" ] [ text (str iri) ]
    cell (Literal l) = td_ [ class_ (literalClass l) ] [ text (str l) ]
    literalClass l
      | l `elem` ["true", "false"]      = "v-bool"
      | take 1 l == "\""                = "v-str"
      | all (\c -> isDigit c || c == '-' || c == '+') l = "v-num"
      | otherwise                       = ""

lineCount :: MisoString -> Int
lineCount = length . lines . JS.unpack

plural :: Int -> MisoString -> MisoString
plural 1 noun = "1 " <> noun
plural n noun = int n <> " " <> noun <> "s"
