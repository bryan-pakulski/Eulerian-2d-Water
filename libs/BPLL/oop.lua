-- This is a small oop class that allows you to "inherit" subclasses
class = {}

-- initialisation function, allows for extending subclasses
function class:new(...)

	local cl = {}

	-- Extend sub classes
	if ... then
		local subClass = {...}

		-- Add sub values from the subclass to our current one
		for _,v in ipairs(subClass) do
			setmetatable(cl, {__index = v})
		end
	end

	return cl
end