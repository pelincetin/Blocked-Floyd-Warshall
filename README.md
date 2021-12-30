# PFP


## Introduction

In a directed weighted graph with positive or negative edge weights, the Floyd–Warshall method is used to identify the shortest pathways, or rather summed weights, between all pairs of vertices in a single iteration of the algorithm. 
With a runtime of V3 where V is a vertex, the normal Floyd–Warshall algorithm examines all potential pathways across the graph between each pair of vertices. Every edge combination is put to the test. It accomplishes its goal of finding the shortest path for all pairs by gradually refining a prediction of the shortest path between two vertices until the prediction is ideal.
The blocked Floyd-Warshall algorithm has been created as an alternative to the normal Floyd-Warshall algorithm. This version is meant to be run in parallel and hence reduce the runtime. The algorithm splits the adjacency matrix into blocks and processes them in three different phases: dependent, partially dependent, and independent. 

## Blocked Floyd-Warshall Algorithm

The Floyd-Warshall algorithm is a dynamic programming algorithm, which means that the problem is broken down into smaller problems and is solved in a recursive manner. The blocked version of the algorithm is also dynamic. 
The blocked Floyd-Warshall algorithm splits the adjacency matrix that is given to the program as input into blocks and processes them in three different phases: dependent, partially dependent, and independent. 
First, in the dependent phase,  the kth diagonal block is processed. This means that when k=0, the block on the top left corner is processed. When k=1, the block that is on the first row and first column is processed. The program keeps processing the kth blocks until all blocks on the diagonal of the block adjacency matrix are processed. However, before we increment k, we go into the partially dependent phase. In this phase, we process the kth row and the kth column of blocks. This means that when k=0, this phase processes the zeroth column and zeroth row. Lastly, in the independent phase, the remaining blocks are processed.

## Implementation

### Adjacency Matrix Representation

The graph is represented as a list of data constructor Weight, which has been defined as either having an Integer value associated with it or having the value None. The value None refers to the state of one vertex not having a direct connection to another. Additionally, a diagonal line of Weight 0s runs throughout the input and output adjacency matrices since for example, the shortest path from vertex A to vertex A should be 0. 

### Random Adjacency Matrix Generation

The adjacency matrix, as explained above, should have a diagonal line of Weight 0s run throughout it. The remaining places should either have a weighted edge or be None. To come up with a random adjacency matrix, I have used the function randomIO from the module System.Random to generate a boolean and if it is false, I prepend None to the matrix. If it is true, I need to append a Weight that has a random integer associated with it. To make it random, I use another function from the System.Random module: randomRIO. I gave it a range of -10 to 200 and it will pick a random number. I then convert this Monad to an Int and create a Weight data type and prepend that to the matrix. 

### Parallel Implementation
		
In order to make my program work in parallel, I called the partially dependent and inner independent phases with differing values of the for loop. I achieved this by first creating a list with the possible i values of the for loop. I then mapped different elements of this list as an argument to the phase functions and called  spawnP on them. For example, if i starts from 0 and partially_dependent phase function takes i as an argument, I map 0 as an argument to the function and call it with spawnP. I also had to tweak the phase functions so that they would not be recursive themselves. Additionally, spawnP requires a pure expression. The partially_dependent and inner_independent phase functions return a list of Weights. Therefore, in order for my program to compile, I had to tweak the data constructor Weight to derive normal-form data as well. In order for Weight to work both as a normal-form data and not, I also had to derive Generics, a GHC function that essentially allows the developer to use the same code with differing data types.

## Reference

https://moorejs.github.io/APSP-in-parallel/
