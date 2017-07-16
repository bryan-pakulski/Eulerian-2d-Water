require("libs.love_debug")

-- Global debugging
debug = true
_G.dbg = debugging:init(debug)

function love.load()

    -- This is our manager
    manager = require("data.scripts.managers.manager")

    love.graphics.setBackgroundColor(255,255,255,255)

end

function love.update(dt)
    -- Logic gets updated here
    manager.logic()
end

function love.draw()

    -- Graphics get updated here
    manager.draw()
end
