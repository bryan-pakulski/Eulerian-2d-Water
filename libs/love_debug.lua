-- This class contains a collection of useful debugging snippets
require('libs.BPLL.oop')

debugging = class:new()

function debugging:init(x)

	local dbg = {}

	dbg.enabled = x

	if (dbg.enabled == true) then
		print("Debug mode activated")
	end

	-- Draw text on screen
	function dbg:draw_text(text, xpos, ypos)
		if (dbg.enabled == true) then
			love.graphics.print(text, xpos, ypos)
		end
	end

	-- Print text to console
	function dbg:print(text)
		if (dbg.enabled == true) then
			print(text)	
		end
	end

	return dbg

end