# SudokuSolver
Solves Sudoku Puzzles using Prolog
Author: Nate Lao

HOW TO USE:

1. Run swipl
2. Import the sudoku.pl source code by entering: '[sudoku].'
3. Use the predicates, solve(Sudoku,Solution) or printSolution(Sudoku), to solve a sudoku puzzle. The Sudoku predicate
should be represented as a list of 81 integers. See sudokuInput.txt for examples.
4. A puzzle is represented as an integer list with 81 elements. The top row the sudoku puzzle is 
the first 9 elements in the list. The next row is the next 9 elements and so forth.
5. The solve predicate finds all possible solutions of the Sudoku puzzle, the printSolution predicate finds the first
solution and prints it in a neat fashion. The printSudoku(Sudoku) predicate can be used to print any list representation
of a sudoku puzzle.
