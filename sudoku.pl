/* 
	Sudoku Solver - will solve a sudoku puzzle using the backtracking method (brute force)
	Author: Nate Lao
*/

/*
	Predicate: num(Num)
	Description: The only valid elements in a sudoku puzzles are numbers between 1-9.
	Zeroes represents an unknown number, the program will try to determine the possible
	values for the zeroes.
*/
num(Num) :- between(1,9,Num).


/*
	Predicate: nonequal(A,B)
	Description: Assuming that A and B are elements in sudoku puzzle, the predicate is
	true iff A and B are not equal.
*/
nonequal(A,B) :- num(A), num(B), A =\= B.

/*
	Predicate: valid(List)
	Description: True iff the provided list has only valid elements of a sudoku puzzle and
	all elements are unique.
*/
valid(List) :- validhelp(List, []).		% Call helper
validhelp([Head|Tail],Front) :- 		% Helper for valid(List)
	\+ member(Head,Front), 				% Check if the current num doesn't appear in the front of the list
	num(Head), 							% Check if the current num is an element	
	append(Front,[Head],NewFront),		% Append the current num to the front
	validhelp(Tail,NewFront).			% Check the rest of the list
validhelp([],_).						% Base Case: an empty list is automatically valid

/*
	Predicate: row(Sudoku,RowNum,Row)
	Description: True iff Row represents the RowNum row of the Sudoku list. Indexing starts at 0.
*/
row(Sudoku,RowNum,Row) :-
	Start is RowNum * 9,				% Define start position index
	End is Start + 9,					% Define end position index
	rowhelp(Sudoku,Start,End,[],Row).	% Call helper
rowhelp(Sudoku,Curr,End,List,Row) :-			% Helper for row(Sudoku,RowNum,Row)
	Curr < End,									% Loop guard
	NewCurr is Curr + 1,						% Iterate
	nth0(Curr,Sudoku,Elem),						% Extract element
	append(List,[Elem],NewList),				% Append to list
	rowhelp(Sudoku,NewCurr,End,NewList,Row).	% Recursive call
rowhelp(_,End,End,Row,Row).						% Helper: Base Case: End of the recursion

/*
	Predicate: col(Sudoku,RowNum,Row)
	Description: True iff Col represents the ColNum col of the Sudoku list. Indexing starts at 0.
*/
col(Sudoku,ColNum,Col) :-
	Start is ColNum,					% Define start
	End is Start + (9^2),				% Define end
	colhelp(Sudoku,Start,End,[],Col).	% Call helper
colhelp(Sudoku,Curr,End,List,Col) :-			% Helper for col(Sudoku,ColNum,Col)
	Curr < End,									% Loop guard
	NewCurr is Curr + 9,						% Iterate
	nth0(Curr,Sudoku,Elem),						% Extract element
	append(List,[Elem],NewList),				% Append to list
	colhelp(Sudoku,NewCurr,End,NewList,Col).	% Recursive call
colhelp(_,End,End,Col,Col).						% Helper: Base Case: End of the recursion

/**/
box(Sudoku,BoxNum,Box) :-
	BoxNum >= 0, BoxNum < 3,
	TLS is BoxNum * 3,
	boxextract(Sudoku,TLS,Box).
box(Sudoku,BoxNum,Box) :-
	BoxNum >= 3, BoxNum < 6,
	TLS is (BoxNum mod 3) * 3 + 27,
	boxextract(Sudoku,TLS,Box).
box(Sudoku,BoxNum,Box) :-
	BoxNum >= 6, BoxNum < 9,
	TLS is (BoxNum mod 3) * 3 + 54,
	boxextract(Sudoku,TLS,Box).

boxcoordinates(TLS,TLE,MLS,MLE,BLS,BLE) :-
	TLE is TLS + 3,
	MLS is TLS + 9, MLE is MLS + 3,
	BLS is TLS + 18, BLE is BLS + 3.

boxextract(Sudoku,TLS,Box) :-
	boxcoordinates(TLS,TLE,MLS,MLE,BLS,BLE),
	rowhelp(Sudoku,TLS,TLE,[],Top),
	rowhelp(Sudoku,MLS,MLE,[],Middle),
	rowhelp(Sudoku,BLS,BLE,[],Bottom),
	append(Top,Middle,TopMiddle),
	append(TopMiddle,Bottom,Box).


/*
	Predicate: solve(List,Solution)
	Description: True iff Solution represents List with its zeroes replaced with sudoku elements,
	in which all elements in Solution is unique.
*/
solve([0|Tail],Solution) :-				% Case where the number is a zero
	num(Num),							% The solution is an element
	solve(Tail,NewTail),				% Call helper on tail
	append([Num],NewTail,Solution),		% Append the new tail
	valid(Solution).					% The solution must be considered valid
solve([Head|Tail],Solution) :-			% Case where the number is an element
	num(Head),							% The element must be an element
	solve(Tail,NewTail),				% Call helper on tail
	append([Head],NewTail,Solution),	% Append the new tail
	valid(Solution).					% The solution must be considered valid
solve([],[]).							% Base Case: an empty is itself a solution

/*
	Predicate: solverows(Sudoku,Solution)
	Description: True iff the Solution is representation of all rows in the Sudoku list solved
*/
solverows(Sudoku,Solution) :-
	length(Sudoku,Size),							% Get the size of the list
	Length is Size/9,								% Divide by 9 to get the number of rows
	solverowshelp(Sudoku,0,Length,Solution).		% Call helper
solverowshelp(Sudoku,RowNum,Length,Solution) :-		% Helper for solverows(Sudoku,Solution)
	RowNum < Length,								% Loop guard
	row(Sudoku,RowNum,CurrRow),						% Get row
	solve(CurrRow,NewRow),							% Solve the row
	NewRowNum is RowNum + 1,						% Iterate 
	solverowshelp(Sudoku,NewRowNum,Length,Rest),	% Call helper on the rest
	append(NewRow,Rest,Solution).					% Append to the rest to yield a solution
solverowshelp(_,End,End,[]).						% Base Case: the end is reached

/*
	Predicate: solvecols(Sudoku,Solution)
	Description: True iff the Solution is representation of all cols in the Sudoku list is solved
*/
solvecols(Sudoku,Solution) :-
	length(Sudoku,Size),							% Get the size of the list
	Length is Size/9,								% Divide by 9 to get the number of rows
	solvecolshelp(Sudoku,0,Length,Solution).		% Call helper
solvecolshelp(Sudoku,ColNum,Length,Solution) :-		% Helper for solverows(Sudoku,Solution)
	ColNum < Length,								% Loop guard
	col(Sudoku,ColNum,CurrCol),						% Get row
	solve(CurrCol,NewCol),							% Solve the row
	NewColNum is ColNum + 1,						% Iterate 
	solvecolshelp(Sudoku,NewColNum,Length,Rest),	% Call helper on the rest
	append(NewCol,Rest,Solution).					% Append to the rest to yield a solution
solvecolshelp(_,End,End,[]).						% Base Case: the end is reached

/*
*/
solveboxes(Sudoku,Solution) :-
	End is 3,
	solveboxeshelp(Sudoku,0,End,Solution).
solveboxeshelp(Sudoku,Index,End,Solution) :-
	Index < End,
	Next is Index + 1,
	LBI is Index * 3,
	MBI is Index * 3 + 1,
	RBI is Index * 3 + 2,
	box(Sudoku,LBI,LeftBox),
	box(Sudoku,MBI,MidBox),
	box(Sudoku,RBI,RightBox),
	solve(LeftBox,NewLeftBox),
	solve(MidBox,NewMidBox),
	solve(RightBox,NewRightBox),
	mergeboxes(NewLeftBox,NewMidBox,NewRightBox,MergeBox), % NEED TO CODE
	solveboxeshelp(Sudoku,Next,End,Rest),
	append(MergeBox,Rest,Solution).
solveboxeshelp(_,End,End,[]).

mergeboxes(Left,Mid,Right,[L0,L1,L2,M0,M1,M2,R0,R1,R2,L3,L4,L5,M3,M4,M5,R3,R4,R5,L6,L7,L8,M6,M7,M8,R6,R7,R8]) :-
	nth0(0,Left,L0),nth0(1,Left,L1),nth0(2,Left,L2),
	nth0(3,Left,L3),nth0(4,Left,L4),nth0(5,Left,L5),
	nth0(6,Left,L6),nth0(7,Left,L7),nth0(8,Left,L8),
	nth0(0,Mid,M0),nth0(1,Mid,M1),nth0(2,Mid,M2),
	nth0(3,Mid,M3),nth0(4,Mid,M4),nth0(5,Mid,M5),
	nth0(6,Mid,M6),nth0(7,Mid,M7),nth0(8,Mid,M8),
	nth0(0,Right,R0),nth0(1,Right,R1),nth0(2,Right,R2),
	nth0(3,Right,R3),nth0(4,Right,R4),nth0(5,Right,R5),
	nth0(6,Right,R6),nth0(7,Right,R7),nth0(8,Right,R8).

solvesudoku(Sudoku,Solution) :-
	solverows(Sudoku,Solution),
	solvecols(Sudoku,Solution),
	solveboxes(Sudoku,Solution).











