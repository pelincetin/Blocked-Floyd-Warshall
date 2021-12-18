{- Paralel Floyd-Warshall algorithm in Haskell, taken from Prof Edwards -}

import Data.Functor.Identity

type Weight = Int
type Graph r = Array r DIM2 Weight

shortestPaths :: Graph U -> Graph U
shortestPaths g0 = runIdentity $ go g0 0
    where
        Z :. _ :. n = extent g0
        go !g !k | k == n = return g -- Return in the monad
                 | otherwise = do -- We’re in a monad
                   g' <- computeP (fromFunction (Z:.n:.n) sp)
                   go g' (k+1)
        where sp (Z:.i:.j) =
            min (g ! (Z:.i:.j))
                (g ! (Z:.i:.k) + g ! (Z:.k:.j))