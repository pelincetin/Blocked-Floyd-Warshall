{-# LANGUAGE DeriveAnyClass, DeriveGeneric #-}

module Graph where

import Control.Parallel
import Control.Parallel.Strategies
import GHC.Generics (Generic)

data Weight = Weight Int | None deriving (Eq, Ord, Show, Generic, NFData)

addWeights :: Weight -> Weight -> Weight
addWeights (Weight x) (Weight y) = Weight (x + y)
addWeights _ _ = None

dataAt :: Int -> [Weight] -> Weight
dataAt _ [] = error "Empty List!"
dataAt y (x:xs)  | y <= 0 = x
                 | otherwise = dataAt (y-1) xs

removeItem :: Int -> [Int] -> [Int]
removeItem _ []                 = []
removeItem x (y:ys) | x == y    = removeItem x ys
                    | otherwise = y : removeItem x ys

replace_nth :: [Weight] -> (Int, Weight) -> [Weight]
replace_nth [] _ = []
replace_nth (_:xs) (0,a) = a:xs
replace_nth (x:xs) (n,a) = if n < 0 then (x:xs) else x: replace_nth xs (n-1,a)

replace_n_list :: [(Int, Weight)] -> [Weight] -> [Weight]
replace_n_list _ [] = []
replace_n_list [] input = input
replace_n_list (x:xs) input = replace_n_list xs (replace_nth input x)
