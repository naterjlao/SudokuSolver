############################################################
# File: sudokuParser.rb
# Path: SudokuParser/
# Author: Nate Lao (lao.nathan95@gmail.com)
#
# Takes a given text file and formats the contents into
# list of sudoku puzzles.
############################################################
filename = ARGV[0]	# Input filename

File.readlines(filename).each do |line|
	i = 0 
	while i < 81 do 
		print line[i]
		i = i + 1
		
		if i < 81 then 
			print "," 
		else
			print "\n"
		end

		if i % 9 == 0 then
			print "\n"
		end
	end
end
