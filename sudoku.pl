/*
############################################################
# File: generalsudoku.pl
# Path: SudokuSolver/
# Author: Nate Lao (lao.nathan95@gmail.com)
#
# Sudoku Solver. Given a list of 81 integers in the set
# {0,1,2,3,4,5,6,7,8,9}, where 0 represents an empty value,
# solve the sudoku puzzle based on sudoku rules.
############################################################
*/
/* SUDOKU SOLVER */

solve(Sudoku,Solution) :- checkSudoku(Sudoku), solveHelp([],Sudoku,0,Solution).

solveHelp(Front,[0|Tail],Index,Solution) :-
	Index < 81, 						
	Next is Index + 1,
	between(1,9,New), 							% Find a substitution number
	append([Front,[New],Tail],Sudoku),
	checkRow(Sudoku,Index),
	checkCol(Sudoku,Index),
	checkBox(Sudoku,Index),
	append(Front,[New],NewFront),
	solveHelp(NewFront,Tail,Next,End),
	append([New],End,Solution).
solveHelp(Front,[E|Tail],Index,Solution) :- 
	Index < 81,
	Next is Index + 1,
	E =\= 0,
	append(Front,[E],NewFront),
	solveHelp(NewFront,Tail,Next,End),
	append([E],End,Solution).
solveHelp(_,[],_,[]).

/* Prints the problem and solution cleanly */
printSolution(Sudoku) :- 
	solve(Sudoku,Solution),nl,
	write('Puzzle:'),nl,
	printSudoku(Sudoku),nl,
	write('Solution:'),nl,
	printSudoku(Solution),!.

/* Prints the sudoku puzzle cleanly */
printSudoku(Sudoku) :- printSudokuHelp(Sudoku,0).
printSudokuHelp([E|Tail],Index) :-
	Next is Index + 1,
	Next mod 9 =:= 0,
	write(E), nl,
	printSudokuHelp(Tail,Next).
printSudokuHelp([E|Tail],Index) :-
	Next is Index + 1,
	Next mod 9 =\= 0,
	write(E),
	write(' '),
	printSudokuHelp(Tail,Next).
printSudokuHelp([],_).

/* Check Predicates */
checkRow(Sudoku,Index) :- 
	row(Sudoku,Index,Row),
	valid(Row),!.
checkCol(Sudoku,Index) :-
	col(Sudoku,Index,Col),
	valid(Col),!.
checkBox(Sudoku,Index) :-
	box(Sudoku,Index,Box),
	valid(Box),!.
checkSudoku(Sudoku) :- checkSudokuHelp(Sudoku,0).
checkSudokuHelp(Sudoku,Index) :-
	Index < 81,
	Next is Index + 1,
	checkRow(Sudoku,Index),
	checkCol(Sudoku,Index),
	checkBox(Sudoku,Index),
	checkSudokuHelp(Sudoku,Next),!.
checkSudokuHelp(_,81).

/* Extract Row */
row(Sudoku,Index,Row) :- 
	Start is div(Index,9) * 9,
	End is Start + 9,
	rowHelp(Sudoku,Start,End,Row).
rowHelp(Sudoku,Index,End,Row) :-
	Index < End,
	Next is Index + 1,
	rowHelp(Sudoku,Next,End,Back),
	nth0(Index,Sudoku,Curr),
	append([Curr],Back,Row).
rowHelp(_,End,End,[]).

/* Extract Column */
col(Sudoku,Index,Col) :-
	Start is Index mod 9,
	End is Start + 81,
	colHelp(Sudoku,Start,End,Col).
colHelp(Sudoku,Index,End,Row) :-
	Index < End,
	Next is Index + 9,
	colHelp(Sudoku,Next,End,Back),
	nth0(Index,Sudoku,Curr),
	append([Curr],Back,Row).
colHelp(_,Index,End,[]) :- Index >= End.

/* Extract Box */
box(Sudoku,Index,Box) :-
	boxIndex(Index,BoxIndex),
	TLI = BoxIndex, TCI is TLI + 1, TRI is TLI + 2,
	MLI is TLI + 9, MCI is TCI + 9, MRI is TRI + 9,
	BLI is MLI + 9, BCI is MCI + 9, BRI is MRI + 9,
	nth0(TLI,Sudoku,TL),nth0(TCI,Sudoku,TC),nth0(TRI,Sudoku,TR),
	nth0(MLI,Sudoku,ML),nth0(MCI,Sudoku,MC),nth0(MRI,Sudoku,MR),
	nth0(BLI,Sudoku,BL),nth0(BCI,Sudoku,BC),nth0(BRI,Sudoku,BR),
	append([[TL],[TC],[TR],[ML],[MC],[MR],[BL],[BC],[BR]],Box).
boxIndex(Index,BoxIndex) :- 
	RowIndex is div(Index,9),
	ColIndex is Index mod 9,
	BoxIndex is (div(ColIndex,3) * 3) + ((div(RowIndex,3) * 3) * 9).

/* A List is valid if it contains either unique 1-9 numbers or zeroes */
valid(List) :- validHelp(List,[]).
validHelp([0|Tail],Front) :- validHelp(Tail,Front),!.
validHelp([Head|Tail],Front) :-
	\+ member(Head,Front),
	between(0,9,Head),
	append(Front,[Head],NewFront),
	validHelp(Tail,NewFront),!.
validHelp([],_).

