{-# LANGUAGE OverloadedStrings #-}
module GraphView (viewGraph) where

import Miso
import Miso.String (MisoString)
import qualified Miso.Svg as S
import qualified Miso.Svg.Attribute as A
import Format (fixed, str)
import Graph

-- | Draw a laid-out graph. The viewBox fits the whole picture, so at 100%
--   zoom it fills the viewport.
viewGraph :: Layout -> View action
viewGraph layout =
  S.svg_ [ A.width_ "100%", A.height_ "100%", A.viewBox_ (str (layoutViewBox layout))
         , A.class_' "stql-graph" ]
    [ S.defs_ []
        [ S.marker_ [ A.id_ "arrow", A.viewBox_ "0 0 10 10", A.refX_ "9", A.refY_ "5"
                    , A.markerWidth_ "7", A.markerHeight_ "7", A.orient_ "auto" ]
            [ S.path_ [ A.d_ "M0,0 L10,5 L0,10 z", A.class_' "g-head" ] [] ]
        ]
    , S.g_ [] (map edgeView (layoutEdges layout))
    , S.g_ [] (map nodeView (layoutNodes layout))
    , S.g_ [] (map labelView (layoutEdges layout))
    ]

edgeView :: Edge -> View action
edgeView e = S.path_ [ A.d_ (str (edgePath e)), A.class_' "g-edge", A.markerEnd_ "url(#arrow)" ] []

nodeView :: Node -> View action
nodeView n =
  S.g_ [ A.class_' (if nodeLiteral n then "g-lit" else "g-iri") ]
    [ S.rect_ [ A.x_ (num (nodeX n)), A.y_ (num (nodeY n))
              , A.width_ (num (nodeW n)), A.height_ (num (nodeH n))
              , A.rx_ (if nodeLiteral n then "3" else "13") ] []
    , S.text_ [ A.x_ (num (nodeX n + nodeW n / 2)), A.y_ (num (nodeY n + nodeH n / 2)) ]
        [ text (str (nodeLabel n)) ]
    ]

-- | Predicate names run along their edge, just above it.
labelView :: Edge -> View action
labelView e =
  S.text_ [ A.x_ (num x), A.y_ (num y), A.dy_ "-4", A.class_' "g-label"
          , A.transform_ ("rotate(" <> num (edgeAngle e) <> " " <> num x <> " " <> num y <> ")") ]
    [ text (str (edgeLabel e)) ]
  where
    x = edgeLabelX e
    y = edgeLabelY e

num :: Double -> MisoString
num = fixed 1
