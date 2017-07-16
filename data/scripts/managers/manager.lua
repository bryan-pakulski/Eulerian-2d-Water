local manager = {}

print("Loading main manager")

-- Modules to load
require("libs.waves.waves")

waves = waves:init(250, 128)

-- Logic function
local function logic()
    
    if (love.mouse.isDown(1) == true) then
        waves:splash(love.mouse.getX(), 50)
    end
	waves:logic()
end

-- Draw function
local function draw()
    love.graphics.setColor(0,0,0)
	_G.dbg:draw_text("water friction: " .. waves.friction, 10, 5)
	_G.dbg:draw_text("water height: " .. math.abs(love.graphics.getHeight() - waves.waterheight), 10, 20)
    _G.dbg:draw_text("mouseX:" .. love.mouse.getX(), 10, 35)

	waves:draw()
end

-- Pass functions to manager object
manager.logic = logic
manager.draw = draw

return manager