% Computational Intelligence: a logical approach. 
% Prolog Code.
% Iterative deepening A* search, based on the generic search algorithm.
% Copyright (c) 1998, Poole, Mackworth, Goebel and Oxford University Press.

% Modified by Mike Barley, University of Auckland, 2014
:- dynamic problem/2.

% solution(+ProblemName, ?Solution)

solution(ProblemName, Solution) :-
	retractall(problem(_,_)),
	[ProblemName],
	problem(I,G),
	solutionAux(problem(I,G), Solution).


% solutionAux(problem(+InitialState, +GoalState), -Solution)

solutionAux(problem(InitialState, GoalState), Solution) :-
	retractall(is_goal(_)),
	assert(is_goal(GoalState)),
	idsearch(InitialState, RevSolution),
	reverse(RevSolution, Solution).


% idsearch(N,P) is true if path P is a path found from node N
% using iterative deepening A* search 
% Example query: idsearch(o103,P).
idsearch(N,P) :-
   h(N,HN),
   writeln(['Trying Depth bound: ',HN]),
   dbsearch([node(N,[],0)],HN,[node(N,[],0)],natural,P).

% dbsearch(F,DB,Q,How1,P) is true if a depth bound search from frontier F
% can find a path P of length >= DB.
% where Q is the initial frontier to (re)start from,
% How specifies whether the previous bound failed naturally or gives
% the minimum f-value for which the search failed.

% The frontier is a list of  node(Node,Path,PathLength)
%   where Node is a node, Path is the path found to Node,
%   PathLength is the length of the path.

%dbsearch(F,_,_,_,_) :-
%   writeln(['Frontier: ',F]),
%   fail.
dbsearch([],_,Q,NDB,S) :-
   number(NDB),
   writeln(['Trying Depth bound: ',NDB]),
   dbsearch(Q,NDB,Q,natural,S).
dbsearch([node(N,P,DB)|_],DB,_,_,[N|P]) :-
   is_goal(N).
dbsearch([node(N,P,PL)|F1],DB,Q,H,S) :-
   h(N,HN),
   HN+PL =< DB,
   neighbors(N,NewNs),
   subtract(NewNs, P, NNs),  % loop elimination
   add_paths_db(NNs,N,[N|P],PL,F1,F2),
   dbsearch(F2,DB,Q,H,S).
dbsearch([node(N,_,PL)|F1],DB,Q,H,S) :-
   h(N,HN),
   HN+PL > DB,
   min1(HN+PL,H,LUB),
   dbsearch(F1,DB,Q,LUB,S).

%   add_paths(NNs,N,Path,PL,F0,F1)
add_paths_db([],_,_,_,F,F).
add_paths_db([NN|R],N,Path,PL,F0,[node(NN,Path,PL1)|F1]) :-
   cost(N,NN,AC),
   PL1 is PL+AC,
   add_paths_db(R,N,Path,PL,F0,F1).

min1(E,natural,V) :- !, V is E.
min1(E,V,V) :- V =< E.
min1(E,V,V1) :- V > E, V1 is E.

% **************************************************
% writeln(L) is true if L is a list of items where each
% item is written on a separate line, followed by a newline.
writeln([]) :- nl.
writeln([H|T]) :- write(H), nl, writeln(T).


%% we are making all edge costs to be 1
%% if you want different edges to have 
%% different costs you must comment this out
%% and include a cost predicate in the domain
%% file
cost(_,_,1).
