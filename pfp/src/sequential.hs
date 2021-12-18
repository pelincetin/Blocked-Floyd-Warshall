{- Sequential Haskell program for Floyd-Warshall -}
import Data.Array.Repa as Repa

type Weight = Int
type Graph r = Repa.Array r DIM2 Weight

shortestPaths :: Graph U -> Graph U
shortestPaths g0 = go g0 0
    where
        Z :. _ :. n = extent g0 -- Get # of vertices
        go !g !k | k == n = g -- Reached the end
            | otherwise = let -- Compute new minimums
                g' = computeS (fromFunction (Z:.n:.n) sp)
            in go g' (k+1) -- Increase k and repeat
        where sp (Z:.i:.j) =
            min (g ! (Z:.i:.j)) −− i → j
                (g ! (Z:.i:.k) + g ! (Z:.k:.j)) 