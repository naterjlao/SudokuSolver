filename = ARGV[0]	# Get the first argument of the command

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