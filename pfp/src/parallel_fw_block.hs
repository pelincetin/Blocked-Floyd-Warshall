{- Paralel Floyd-Warshall algorithm with 2-D block mapping in Haskell -}

module Parallel_fw_block where 

--import Control.Monad.Par(runPar, spawnP, get)
import Data.List
import Debug.Trace

data Weight = Weight Int | None deriving (Eq, Ord, Show)

addWeights :: Weight -> Weight -> Weight
addWeights (Weight x) (Weight y) = Weight (x + y)
addWeights _ _ = None

dataAt :: Int -> [Weight] -> Weight
dataAt _ [] = error "Empty List!"
dataAt y (x:xs)  | y <= 0 = x
                 | otherwise = dataAt (y-1) xs

replace_nth :: [Weight] -> (Int, Weight) -> [Weight]
replace_nth [] _ = []
replace_nth (_:xs) (0,a) = a:xs
replace_nth (x:xs) (n,a) = if n < 0 then (x:xs) else x: replace_nth xs (n-1,a)

loops :: Int -> Int -> Int -> Int -> Int -> Int -> [Weight] -> [Weight] -> [Weight] -> [Weight]
loops k n kth i j b l_a l_b l_c = 
    if i == b then l_c
    else 
        if j == b then loops k n kth (i + 1) 0 b l_a l_b l_c
        else 
            if element > sum1 then loops k n kth i (j+1) b l_a l_b new_C
            else 
                --trace (show element)
                --trace (show sum1)
                --trace (show l_c)
                loops k n kth i (j+1) b l_a l_b l_c
                    where element = dataAt (i*n + j) l_c
                          sum1 = addWeights (dataAt (i*n + k) l_a) (dataAt (kth + j) l_b)
                          new_C = replace_nth l_c ((i*n + j), sum1)
                    

floyd_warshall_in_place :: [Weight] -> [Weight] -> [Weight] -> Int -> Int -> Int -> [Weight]
floyd_warshall_in_place l_a l_b l_c b n k = 
    if k == b then l_c
    else 
        floyd_warshall_in_place l_a l_b (loops k n kth 0 0 b l_a l_b l_c) b n (k+1)
            where kth = k*n

inner_independent_phase :: Int -> Int -> Int -> Int -> Int -> [Weight] -> [Weight] 
inner_independent_phase i j k b n input = 
    if j == (n `div` b) then input
    else 
        if j == k then inner_independent_phase i (j+1) k b n input
        else 
            inner_independent_phase i (j+1) k b n res
            where 
                l_a = drop (i*b*n + k*b) input
                l_b = drop (k*b*n + j*b) input
                (first_half, l_c) = splitAt (i*b*n + j*b) input
                res = first_half++(floyd_warshall_in_place l_a l_b l_c b n 0)


independent_phase :: Int -> Int -> Int -> Int -> [Weight] -> [Weight]
independent_phase i k b n input = 
    if i == (n `div` b) then input
    else 
        if i == k then independent_phase (i+1) k b n input
        else 
            --trace (show input)
            independent_phase (i+1) k b n output
                where 
                    l_a = drop (i*b*n + k*b) input
                    l_b = drop (k*b*n + k*b) input
                    (first_half, l_c) = splitAt (i*b*n + k*b) input
                    input_for_inner = first_half++(floyd_warshall_in_place l_a l_b l_c b n 0)
                    output = inner_independent_phase i 0 k b n input_for_inner
                              

partially_dependent_phase :: [Weight] -> Int -> Int -> Int -> Int -> [Weight] 
partially_dependent_phase input j k n b = 
    if j == (n `div` b) then input
    else 
        if j == k then partially_dependent_phase input (j+1) k n b
        else 
            --trace (show j)
            partially_dependent_phase (first_half++res) (j+1) k n b
                where 
                    l_a = drop (k*b*n + k*b) input
                    l_b = drop (k*b*n + j*b) input
                    (first_half, l_c) = splitAt (k*b*n + j*b) input
                    res = floyd_warshall_in_place l_a l_b l_c b n 0 

dependent_phase :: Int -> Int -> Int -> [Weight] -> [Weight]
dependent_phase k b n input = 
    if k == (n `div` b) then input
    else
        dependent_phase (k + 1) b n new_in_output
            where 
                l_a = drop (k*b*n + k*b) input
                l_b = drop (k*b*n + k*b) input
                (first_half, l_c) = splitAt (k*b*n + k*b) input
                new_dep_output = floyd_warshall_in_place l_a l_b l_c b n 0 
                new_part_output = partially_dependent_phase (first_half++new_dep_output) 0 k n b
                new_in_output = independent_phase 0 k b n new_part_output

floyd_warshall_blocked :: [Weight] -> Int -> Int -> [Weight]
floyd_warshall_blocked input n b = 
    dependent_phase 0 b n input 

test :: [Weight]
test = [Weight 0, None, Weight (-2), None, Weight 4, Weight 0, Weight 3, None, None, None, Weight 0, Weight 2, None, Weight (-1), None, Weight 0]

main :: IO ()
main = putStrLn (show (floyd_warshall_blocked test 4 1))