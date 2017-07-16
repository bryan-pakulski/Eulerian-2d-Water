-- This is a collection of useful functions that may be used often

-- Displays an error message and closes the lua interpreter
function perror(text)
	print("Error: ",text)
	os.exit()
end

-- Returns the size of a table
function table_size(tb)

	if not tb then
		perror("Tried to find size of non table data structure")
	else
		return #tb
	end
end
