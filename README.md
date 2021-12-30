# PFP


## Introduction

In a directed weighted graph with positive or negative edge weights, the Floyd–Warshall method is used to identify the shortest pathways, or rather summed weights, between all pairs of vertices in a single iteration of the algorithm. 
With a runtime of V3 where V is a vertex, the normal Floyd–Warshall algorithm examines all potential pathways across the graph between each pair of vertices. Every edge combination is put to the test. It accomplishes its goal of finding the shortest path for all pairs by gradually refining a prediction of the shortest path between two vertices until the prediction is ideal.
The blocked Floyd-Warshall algorithm has been created to reduce the runtime of the algorithm. The algorithm splits the adjacency matrix into blocks and processes them in three different phases: dependent, partially dependent, and independent. 

## Blocked Floyd-Warshall Algorithm

The Floyd-Warshall algorithm is a dynamic programming algorithm, which means that the problem is broken down into smaller problems and is solved in a recursive manner. The blocked version of the algorithm is also dynamic. 
The blocked Floyd-Warshall algorithm splits the adjacency matrix that is given to the program as input into blocks and processes them in three different phases: dependent, partially dependent, and independent. 
First, in the dependent phase,  the kth diagonal block is processed. This means that when k=0, the block on the top left corner is processed. When k=1, the block that is on the first row and first column is processed. The program keeps processing the kth blocks until all blocks on the diagonal of the block adjacency matrix are processed. However, before we increment k, we go into the partially dependent phase. In this phase, we process the kth row and the kth column of blocks. This means that when k=0, this phase processes the zeroth column and zeroth row. Lastly, in the independent phase, the remaining blocks are processed.


## Reference

https://moorejs.github.io/APSP-in-parallel/
