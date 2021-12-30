{-# LANGUAGE DeriveAnyClass, DeriveGeneric #-}

import Graph
import Parallel_fw_block
import Sequential_fw_block

import Control.Monad
import System.Random(randomIO, randomRIO)

import GHC.Generics (Generic)
import Control.Parallel
import Control.Parallel.Strategies

randomGraphGenerator :: Int -> Int -> Int -> [Weight] -> IO [Weight] 
randomGraphGenerator num_of_vertices k i graph = do
    -- Every num_of_vertices * k + k is Weight 0
    -- otherwise assign a random weight or None
    -- when num_of_vertices == k - 1, return graph
    bool <- randomIO
    if i == (num_of_vertices*num_of_vertices) then do return (reverse graph)
    else do
        if ((num_of_vertices * k) + k) == i then do randomGraphGenerator num_of_vertices (k+1) (i+1) (Weight 0:graph)
        else do
            if bool == False then do randomGraphGenerator num_of_vertices k (i+1) (None:graph) 
            else do 
                let random_weight = randomRIO (0, 200)
                w <- random_weight
                let new_weight = Weight w
                randomGraphGenerator num_of_vertices k (i+1) (new_weight:graph) 

main :: IO ()
main = do
    g <- randomGraphGenerator 49 0 0 [] -- ::[Weight]
    --print g
    writeFile "file.txt" (show g)
    --print (Parallel_fw_block.floyd_warshall_blocked g 40 10)
    --print (Sequential_fw_block.floyd_warshall_blocked g 40 10)
