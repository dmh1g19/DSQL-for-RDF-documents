{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
-- | Lays out a set of triples as a node-link diagram: subjects and objects
--   become boxes, predicates become labelled arrows between them. IRIs that
--   occur more than once share a box; every literal gets a box of its own.
--
--   Everything here is plain Haskell, so the whole picture is computed once
--   when a query finishes and the view only has to draw it.
module Graph
  ( Term (..)
  , Layout (..)
  , Node (..)
  , Edge (..)
  , layoutTriples
  ) where

import Control.DeepSeq (NFData)
import Data.Array.Unboxed
import Data.Char (isAlpha)
import qualified Data.IntMap.Strict as IntMap
import qualified Data.IntSet as IntSet
import Data.List (foldl', sortOn)
import qualified Data.Map.Strict as Map
import GHC.Generics (Generic)
import Numeric (showFFloat)

-- | One position of a triple: an IRI (without angle brackets) or a literal.
data Term = Iri String | Literal String
  deriving (Show, Eq, Generic, NFData)

data Node = Node
  { nodeLabel   :: String
  , nodeLiteral :: Bool
  , nodeX, nodeY, nodeW, nodeH :: Double   -- ^ top-left corner and size
  } deriving (Show, Eq, Generic, NFData)

data Edge = Edge
  { edgePath   :: String    -- ^ SVG path data, ending at the target's border
  , edgeLabel  :: String
  , edgeLabelX :: Double
  , edgeLabelY :: Double
  , edgeAngle  :: Double    -- ^ rotation of the label, in degrees
  } deriving (Show, Eq, Generic, NFData)

data Layout = Layout
  { layoutNodes   :: [Node]
  , layoutEdges   :: [Edge]
  , layoutViewBox :: String
  } deriving (Show, Eq, Generic, NFData)

-- ---------------------------------------------------------------------------
-- Building the graph
-- ---------------------------------------------------------------------------

-- | The distinct nodes of the triples, and each triple as an edge between two
--   of them labelled with its predicate.
graphOf :: [(Term, Term, Term)] -> ([Term], [(Int, String, Int)])
graphOf = go Map.empty [] 0 []
  where
    go _ nodes _ edges [] = (reverse nodes, reverse edges)
    go seen nodes n edges ((s, p, o) : rest) =
      let (si, seen1, nodes1, n1) = intern s seen nodes n
          (oi, seen2, nodes2, n2) = intern o seen1 nodes1 n1
      in  go seen2 nodes2 n2 ((si, termLabel p, oi) : edges) rest

    intern t@(Iri i) seen nodes n = case Map.lookup i seen of
      Just k  -> (k, seen, nodes, n)
      Nothing -> (n, Map.insert i n seen, t : nodes, n + 1)
    intern t seen nodes n = (n, seen, t : nodes, n + 1)

termLabel :: Term -> String
termLabel (Iri i)     = clip (shortName i)
termLabel (Literal l) = clip l

-- | Long labels are cut short; the table view shows them in full.
clip :: String -> String
clip s | length s > maxLabel = take (maxLabel - 1) s ++ "\x2026"
       | otherwise           = s
  where maxLabel = 26

-- | A compact name for an IRI: its last segment, qualified by the segment
--   before it when there is one, so http://xmlns.com/foaf/0.1/knows becomes
--   foaf:knows and http://www.cw.org/#problem2 becomes problem2.
shortName :: String -> String
shortName iri
  | null local     = if null path then iri else path
  | null namespace = local
  | otherwise      = namespace ++ ":" ++ local
  where
    path = case breakOn "://" iri of
             Just rest -> dropWhile (`elem` "/") (dropWhile (`notElem` "/#") rest)
             Nothing   -> iri
    (revLocal, revRest) = break (`elem` "/#") (reverse path)
    local     = reverse revLocal
    namespace = lastWord (reverse (drop 1 revRest))
    lastWord s = case filter (any isAlpha) (splitOn "/#" s) of
                   [] -> ""
                   ws -> last ws

breakOn :: String -> String -> Maybe String
breakOn pat s@(_ : rest)
  | take (length pat) s == pat = Just (drop (length pat) s)
  | otherwise                  = breakOn pat rest
breakOn _ [] = Nothing

splitOn :: String -> String -> [String]
splitOn seps s = case break (`elem` seps) s of
  (w, [])       -> [w]
  (w, _ : rest) -> w : splitOn seps rest

-- ---------------------------------------------------------------------------
-- Sizes
-- ---------------------------------------------------------------------------

-- | Width of one character of the 12px monospace font the labels use.
charWidth :: Double
charWidth = 7.3

nodeHeight :: Double
nodeHeight = 26

boxWidth :: String -> Double
boxWidth s = max 36 (charWidth * fromIntegral (length s) + 20)

-- | Edge labels are set in a slightly smaller font.
labelWidth :: String -> Double
labelWidth s = 6.4 * fromIntegral (length s)

-- ---------------------------------------------------------------------------
-- Layout
-- ---------------------------------------------------------------------------

layoutTriples :: [(Term, Term, Term)] -> Layout
layoutTriples triples = Layout nodes edges viewBox
  where
    (terms, links) = graphOf triples
    labels  = map termLabel terms
    n       = length terms
    widths  = listArray (0, n - 1) (map boxWidth labels) :: UArray Int Double
    placed  = pack (map (placeComponent widths links) (components n links))
    xs      = array (0, n - 1) [ (i, x) | (i, x, _) <- placed ] :: UArray Int Double
    ys      = array (0, n - 1) [ (i, y) | (i, _, y) <- placed ] :: UArray Int Double
    nodes   = [ Node l (isLiteral t) (xs ! i - w / 2) (ys ! i - nodeHeight / 2) w nodeHeight
              | (i, t, l) <- zip3 [0 ..] terms labels, let w = widths ! i ]
    edges   = drawEdges xs ys widths links
    viewBox = boundingBox nodes edges

isLiteral :: Term -> Bool
isLiteral (Literal _) = True
isLiteral _           = False

-- | The groups of nodes linked to each other, each in ascending order.
components :: Int -> [(Int, String, Int)] -> [[Int]]
components n links = go 0 IntSet.empty
  where
    adjacent = IntMap.fromListWith (++) (concat [ [(a, [b]), (b, [a])] | (a, _, b) <- links ])
    go i seen
      | i >= n               = []
      | IntSet.member i seen = go (i + 1) seen
      | otherwise            = let c = explore [i] (IntSet.singleton i)
                               in  IntSet.toAscList c : go (i + 1) (IntSet.union seen c)
    explore [] found = found
    explore (v : vs) found =
      let next = [ w | w <- IntMap.findWithDefault [] v adjacent, not (IntSet.member w found) ]
      in  explore (next ++ vs) (foldr IntSet.insert found next)

-- | A component laid out on its own: its width and height, and the centre of
--   each of its nodes relative to its top-left corner.
data Placed = Placed Double Double [(Int, Double, Double)]

placeComponent :: UArray Int Double -> [(Int, String, Int)] -> [Int] -> Placed
placeComponent widths links members =
  Placed (right - left + 2 * pad) (bottom - top + 2 * pad)
         [ (g, xs ! i - left + pad, ys ! i - top + pad) | (i, g) <- zip [0 ..] members ]
  where
    m       = length members
    local   = Map.fromList (zip members [0 ..])
    ws      = listArray (0, m - 1) [ widths ! g | g <- members ] :: UArray Int Double
    springs = [ (la, lb, max 110 (labelWidth l + (ws ! la + ws ! lb) / 2 + 24))
              | (a, l, b) <- links, a /= b
              , Just la <- [Map.lookup a local], Just lb <- [Map.lookup b local] ]
    loops   = IntSet.fromList [ la | (a, _, b) <- links, a == b, Just la <- [Map.lookup a local] ]
    (xs, ys) = untangled m ws [ (a, b) | (a, b, _) <- springs ]
                 [ separate m ws (align m (settle m springs (start m s))) | s <- [0 .. tries - 1] ]
    -- small pieces cannot tangle; bigger ones get a few different starts
    tries | m <= 3    = 1
          | m <= 60   = 8
          | otherwise = 3
    left    = minimum [ xs ! i - ws ! i / 2 | i <- [0 .. m - 1] ]
    right   = maximum [ xs ! i + ws ! i / 2 | i <- [0 .. m - 1] ]
    top     = minimum [ ys ! i - nodeHeight / 2 - (if IntSet.member i loops then 56 else 0)
                      | i <- [0 .. m - 1] ]
    bottom  = maximum [ ys ! i + nodeHeight / 2 | i <- [0 .. m - 1] ]
    pad     = 16

-- | Arrange the components in rows, biggest first, keeping the whole picture
--   roughly as wide as it is tall.
pack :: [Placed] -> [(Int, Double, Double)]
pack parts = go 0 0 0 (sortOn size parts)
  where
    size (Placed _ _ ns) = negate (length ns)
    rowWidth = max (maximum (0 : [ w | Placed w _ _ <- parts ]))
                   (1.6 * sqrt (sum [ w * h | Placed w h _ <- parts ]))
    go _ _ _ [] = []
    go x y rowHeight (Placed w h ns : rest)
      | x > 0 && x + w > rowWidth = go 0 (y + rowHeight) 0 (Placed w h ns : rest)
      | otherwise = [ (g, x + nx, y + ny) | (g, nx, ny) <- ns ]
                    ++ go (x + w) y (max rowHeight h) rest

type Positions = (UArray Int Double, UArray Int Double)

-- | Where the nodes start for attempt s: on an even spiral in their own
--   order first, which keeps a subject near its objects, then scattered at
--   random. The generator stays well inside GHCJS's 32-bit Int.
start :: Int -> Int -> Positions
start n 0 = ( listArray (0, n - 1) [ r i * cos (a i) | i <- [0 .. n - 1] ]
            , listArray (0, n - 1) [ r i * sin (a i) | i <- [0 .. n - 1] ] )
  where
    r i = 60 * sqrt (fromIntegral i + 0.5)
    a i = 2.39996 * fromIntegral i          -- the golden angle
start n s = (listArray (0, n - 1) (take n xs), listArray (0, n - 1) (take n ys))
  where
    randoms = tail (iterate (\v -> (v * 1103 + 12345) `mod` 32749) (s * 4099 `mod` 32749))
    coords  = [ (fromIntegral v / 32749 - 0.5) * side | v <- randoms ]
    side    = 120 * sqrt (fromIntegral n)
    (xs, ys) = unzip (pairs coords)
    pairs (p : q : rest) = (p, q) : pairs rest
    pairs _              = []

-- | Of several layouts of one component, the first without crossing edges or
--   edges running through other nodes, or else the one with fewest of them.
untangled :: Int -> UArray Int Double -> [(Int, Int)] -> [Positions] -> Positions
untangled m widths edges candidates =
  case [ c | (c, 0) <- scored ] of
    c : _ -> c
    []    -> fst (foldr1 (\a b -> if snd b < snd a then b else a) scored)
  where
    scored = [ (c, tangles c) | c <- candidates ]
    tangles :: Positions -> Int
    tangles (xs, ys) = length crossings + length throughNodes
      where
        at i = (xs ! i, ys ! i)
        crossings = [ () | ((a, b), i) <- numbered, ((c, d), j) <- numbered, i < j
                         , a /= c, a /= d, b /= c, b /= d
                         , segmentsCross (at a) (at b) (at c) (at d) ]
        throughNodes = [ () | (a, b) <- edges, k <- [0 .. m - 1], k /= a, k /= b
                            , segmentHitsBox (at a) (at b) (at k) (widths ! k / 2 + 4) (nodeHeight / 2 + 4) ]
    numbered = zip edges [0 :: Int ..]

segmentsCross :: (Double, Double) -> (Double, Double) -> (Double, Double) -> (Double, Double) -> Bool
segmentsCross p1 p2 p3 p4 =
  turn p1 p2 p3 * turn p1 p2 p4 < 0 && turn p3 p4 p1 * turn p3 p4 p2 < 0
  where turn (ax, ay) (bx, by) (cx, cy) = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)

-- | Does the segment pass through the box with the given centre and half-sizes?
segmentHitsBox :: (Double, Double) -> (Double, Double) -> (Double, Double) -> Double -> Double -> Bool
segmentHitsBox p q (cx, cy) hw hh =
  inside p || inside q || any (uncurry (segmentsCross p q)) [ (c1, c2), (c2, c3), (c3, c4), (c4, c1) ]
  where
    inside (x, y) = abs (x - cx) < hw && abs (y - cy) < hh
    c1 = (cx - hw, cy - hh)
    c2 = (cx + hw, cy - hh)
    c3 = (cx + hw, cy + hh)
    c4 = (cx - hw, cy + hh)

-- | Force-directed placement of the node centres: every pair of nodes repels,
--   every edge is a spring with a rest length long enough for its label, and
--   a weak pull towards the origin keeps the component compact.
settle :: Int -> [(Int, Int, Double)] -> Positions -> Positions
settle n springs initial = go 0 initial
  where
    iterations = max 60 (min 300 (2000000 `div` max 1 (n * n)))
    go :: Int -> Positions -> Positions
    go !k ps | k >= iterations = ps
             | otherwise       = go (k + 1) (step (temperature k) ps)
    temperature k = 2 + 60 * (1 - fromIntegral k / fromIntegral iterations)

    repulsion = 50 * 50 :: Double
    gravity   = 0.015 :: Double
    stiffness = 1.0 :: Double

    step :: Double -> Positions -> Positions
    step t (xs, ys) = ( listArray (0, n - 1) (map fst moved)
                      , listArray (0, n - 1) (map snd moved) )
      where
        pulls = [ (a, b, fx, fy)
                | (a, b, len) <- springs
                , let dx = xs ! b - xs ! a
                      dy = ys ! b - ys ! a
                      d  = max 0.01 (sqrt (dx * dx + dy * dy))
                      f  = stiffness * (d - len) / d
                      fx = dx * f
                      fy = dy * f ]
        springX = accumArray (+) 0 (0, n - 1)
                    (concat [ [(a, fx), (b, negate fx)] | (a, b, fx, _) <- pulls ]) :: UArray Int Double
        springY = accumArray (+) 0 (0, n - 1)
                    (concat [ [(a, fy), (b, negate fy)] | (a, b, _, fy) <- pulls ]) :: UArray Int Double
        moved = [ let (rx, ry) = push i
                      fx = rx + springX ! i - gravity * xs ! i
                      fy = ry + springY ! i - gravity * ys ! i
                      len = sqrt (fx * fx + fy * fy)
                      s = if len > t then t / len else 1
                  in  (xs ! i + fx * s, ys ! i + fy * s)
                | i <- [0 .. n - 1] ]
        push i = loop 0 0 0
          where
            xi = xs ! i
            yi = ys ! i
            loop !j !fx !fy
              | j == n    = (fx, fy)
              | j == i    = loop (j + 1) fx fy
              | otherwise = let dx = xi - xs ! j
                                dy = yi - ys ! j
                                d2 = max 1 (dx * dx + dy * dy)
                                f  = repulsion / d2
                            in  loop (j + 1) (fx + dx * f) (fy + dy * f)

-- | Turn a component so its longest extent runs left to right, with its first
--   node, usually a subject, on the left.
align :: Int -> Positions -> Positions
align m (xs, ys) = (listArray (0, m - 1) (map fst turned), listArray (0, m - 1) (map snd turned))
  where
    count  = fromIntegral m
    cx     = sum [ xs ! i | i <- [0 .. m - 1] ] / count
    cy     = sum [ ys ! i | i <- [0 .. m - 1] ] / count
    offs   = [ (xs ! i - cx, ys ! i - cy) | i <- [0 .. m - 1] ]
    sxx    = sum [ x * x | (x, _) <- offs ]
    syy    = sum [ y * y | (_, y) <- offs ]
    sxy    = sum [ x * y | (x, y) <- offs ]
    major  = 0.5 * atan2 (2 * sxy) (sxx - syy)
    angle  = if fst (rotate (negate major) (head offs)) > 0 then pi - major else negate major
    turned = map (rotate angle) offs
    rotate a (x, y) = (x * cos a - y * sin a, x * sin a + y * cos a)

-- | Nudge apart any boxes the forces left overlapping.
separate :: Int -> UArray Int Double -> Positions -> Positions
separate n widths = go (40 :: Int)
  where
    gap = 14
    go :: Int -> Positions -> Positions
    go 0 ps = ps
    go k ps@(xs, ys)
      | null overlaps = ps
      | otherwise     = go (k - 1) (shift xs dxs, shift ys dys)
      where
        overlaps = [ (i, j, ox, oy)
                   | i <- [0 .. n - 1], j <- [i + 1 .. n - 1]
                   , let ox = (widths ! i + widths ! j) / 2 + gap - abs (xs ! i - xs ! j)
                         oy = nodeHeight + gap - abs (ys ! i - ys ! j)
                   , ox > 0, oy > 0 ]
        moves = concat
          [ if ox / (widths ! i + widths ! j) < oy / (2 * nodeHeight)
              then let d = dir (xs ! i) (xs ! j) i j * ox / 2 in [(i, (d, 0)), (j, (negate d, 0))]
              else let d = dir (ys ! i) (ys ! j) i j * oy / 2 in [(i, (0, d)), (j, (0, negate d))]
          | (i, j, ox, oy) <- overlaps ]
        dxs = accumArray (+) 0 (0, n - 1) [ (i, d) | (i, (d, _)) <- moves ] :: UArray Int Double
        dys = accumArray (+) 0 (0, n - 1) [ (i, d) | (i, (_, d)) <- moves ] :: UArray Int Double
        shift vs ds = listArray (0, n - 1) [ vs ! i + ds ! i | i <- [0 .. n - 1] ]
    -- which way i moves away from j; boxes on the same spot split by index
    dir a b i j | a < b     = -1
                | a > b     = 1
                | i < j     = -1
                | otherwise = 1 :: Double

-- ---------------------------------------------------------------------------
-- Edges
-- ---------------------------------------------------------------------------

-- | Paths for the edges. Several edges between the same two nodes bow out
--   side by side so their labels do not sit on top of each other, and an edge
--   from a node to itself becomes a loop above it.
drawEdges :: UArray Int Double -> UArray Int Double -> UArray Int Double
          -> [(Int, String, Int)] -> [Edge]
drawEdges xs ys widths links = zipWith draw links (bends links)
  where
    draw (a, label, b) bend
      | a == b    = loop a label
      | otherwise =
          let (x1, y1) = (xs ! a, ys ! a)
              (x2, y2) = (xs ! b, ys ! b)
              (dx, dy) = (x2 - x1, y2 - y1)
              d        = max 0.01 (sqrt (dx * dx + dy * dy))
              (nx, ny) = (negate dy / d, dx / d)
              (cx, cy) = ((x1 + x2) / 2 + nx * 2 * bend, (y1 + y2) / 2 + ny * 2 * bend)
              (sx, sy) = border a (cx - x1, cy - y1) 1
              (ex, ey) = border b (cx - x2, cy - y2) 5
              (lx, ly) = if bend == 0
                           then ((sx + ex) / 2, (sy + ey) / 2)
                           else (0.25 * sx + 0.5 * cx + 0.25 * ex, 0.25 * sy + 0.5 * cy + 0.25 * ey)
              path | bend == 0 = "M" ++ pt sx sy ++ "L" ++ pt ex ey
                   | otherwise = "M" ++ pt sx sy ++ "Q" ++ pt cx cy ++ " " ++ pt ex ey
          in  Edge path label lx ly (upright (atan2 (ey - sy) (ex - sx) * 180 / pi))

    -- the point where a ray from a node's centre leaves its box, plus a gap
    border i (dx, dy) gap =
      let hw = widths ! i / 2 + gap
          hh = nodeHeight / 2 + gap
          t  = minimum ([ hw / abs dx | dx /= 0 ] ++ [ hh / abs dy | dy /= 0 ] ++ [1])
      in  (xs ! i + dx * t, ys ! i + dy * t)

    loop i label =
      let x   = xs ! i
          top = ys ! i - nodeHeight / 2
          w   = min 24 (widths ! i / 3)
      in  Edge ("M" ++ pt (x + w) top ++ "C" ++ pt (x + w + 26) (top - 52) ++ " "
                    ++ pt (x - w - 26) (top - 52) ++ " " ++ pt (x - w) (top - 5))
               label x (top - 46) 0

-- | Text along an edge reads left to right whichever way the edge points.
upright :: Double -> Double
upright a | a > 90    = a - 180
          | a < -90   = a + 180
          | otherwise = a

-- | How far each edge bows out: 0 when it is the only edge between its two
--   nodes, and evenly spread offsets when there are several.
bends :: [(Int, String, Int)] -> [Double]
bends links = reverse (snd (foldl' place (Map.empty, []) links))
  where
    counts = Map.fromListWith (+) [ (key a b, 1 :: Int) | (a, _, b) <- links, a /= b ]
    key a b = (min a b, max a b)
    place (seen, acc) (a, _, b)
      | a == b    = (seen, 0 : acc)
      | otherwise =
          let k     = key a b
              total = Map.findWithDefault 1 k counts
              idx   = Map.findWithDefault (0 :: Int) k seen
              off   = (fromIntegral idx - fromIntegral (total - 1) / 2) * 34
              -- offsets are measured from the lower-numbered node, so edges
              -- running the other way flip to stay on their own side
              off'  = if a < b then off else negate off
          in  (Map.insert k (idx + 1) seen, off' : acc)

pt :: Double -> Double -> String
pt x y = num x ++ " " ++ num y

num :: Double -> String
num v = showFFloat (Just 1) v ""

-- | The viewBox that fits every box and label, with a margin.
boundingBox :: [Node] -> [Edge] -> String
boundingBox [] _ = "0 0 100 100"
boundingBox nodes edges =
  unwords (map num [minX - margin, minY - margin, maxX - minX + 2 * margin, maxY - minY + 2 * margin])
  where
    margin = 30
    boxes  = [ (nodeX nd, nodeY nd, nodeX nd + nodeW nd, nodeY nd + nodeH nd) | nd <- nodes ]
          ++ [ (x - r, y - r, x + r, y + r)
             | e <- edges, let x = edgeLabelX e
                               y = edgeLabelY e
                               r = labelWidth (edgeLabel e) / 2 + 4 ]
    minX = minimum [ a | (a, _, _, _) <- boxes ]
    minY = minimum [ b | (_, b, _, _) <- boxes ]
    maxX = maximum [ c | (_, _, c, _) <- boxes ]
    maxY = maximum [ d | (_, _, _, d) <- boxes ]
