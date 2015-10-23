# 8 Puzzle
Solve 8 sliding tile puzzle using IDA* algorithm and Manhattan heuristics.

## State Representation
There are nine board locations and eight tiles and a blank. The tiles are numbered 1 through 8, and the blank is represented by the number 0. A state is represented by a list. In the list, the first element indicates which tile is in the upper left hand location, the second element the upper middle location, etc.

## Problem Representation
The IDA* problem solver will be given problems to solve. The problem will be represented using a functor called "problem" and two arguments: initial state and goal state. For example:
`problem([2, 8, 3, 4, 1, 6, 5, 7, 0], [1,2,3,4,5,6,7,8,0]).`

## Usage
`?- solution(puzzle0, S).`
