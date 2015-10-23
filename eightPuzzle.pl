% Author: Zhen Chen

neighbors(State, Neighbors) :-
	findall(Neighbor, successor(State, Neighbor), Neighbors).

successor(State, Neighbor) :-
	moveUp(State, Neighbor);
	moveDown(State, Neighbor);
	moveLeft(State, Neighbor);
	moveRight(State, Neighbor).

location(State, X, Y, Elem) :-
	nth0(Index, State, Elem),
	divmod(Index, 3, X, Y).

index(Index, X, Y) :-
	Index is 3 * X + Y.

swap(State, I1, I2, Final) :-
	same_length(State, Final),
	length(BeforeI1, I1),
	length(BeforeI2, I2),
	append(BeforeI1, [EI1|PastI1], State),
	append(BeforeI1, [EI2|PastI1], Temp),
	append(BeforeI2, [EI2|PastI2], Temp),
	append(BeforeI2, [EI1|PastI2], Final).

moveUp(State, Final) :-
	location(State, X, Y, 0),
	X > 0,
	Z is X - 1,
	index(Index, X, Y),
	index(NewIndex, Z, Y),
	swap(State, Index, NewIndex, Final).

moveDown(State, Final) :-
	location(State, X, Y, 0),
	X < 2,
	Z is X + 1,
	index(Index, X, Y),
	index(NewIndex, Z, Y),
	swap(State, Index, NewIndex, Final).

moveLeft(State, Final) :-
	location(State, X, Y, 0),
	Y > 0,
	Z is Y - 1,
	index(Index, X, Y),
	index(NewIndex, X, Z),
	swap(State, Index, NewIndex, Final).

moveRight(State, Final) :-
	location(State, X, Y, 0),
	Y < 2,
	Z is Y + 1,
	index(Index, X, Y),
	index(NewIndex, X, Z),
	swap(State, Index, NewIndex, Final).

h(State, HeuristicValue) :-
	is_goal(GoalState),
	manhattan(State, GoalState, 1, 0, HeuristicValue).

manhattan(State, GoalState, Elem, InValue, InValue) :-
	same_length(State, GoalState),
	length(State, Length),
	Elem =:= Length.

manhattan(State, GoalState, Elem, InValue, HeuristicValue) :-
	location(State, X, Y, Elem),
	location(GoalState, A, B, Elem),
	Value is InValue + abs(X - A) + abs(Y - B),
	NewElem is Elem + 1,
	manhattan(State, GoalState, NewElem, Value, HeuristicValue).
