require('libs.BPLL.oop')

-- Initialise new class
waves = class:new()

-- Init function
function waves:init(waterheight, resolution)

    -- Default values
    local main = {}

    fshader = require('data.shaders.water')
    main.watershader = love.graphics.newShader(fshader)

    main.friction = 0.025 -- stiffness of water surface
    main.dampening = 0.025 -- Dampening factor on each wave (must be greater than friction)
    main.dispersion = 6 -- Rate at which waves disperse (set proportional to target resolution)
    main.spread = 0.05 -- Spread coefficient (max 0.5)
    main.resolution = resolution
    main.waterheight = love.graphics.getHeight() - waterheight
    main.period = love.graphics.getWidth() / resolution
    main.vertices = {}

    -- Fill water base value
    for i=0, resolution do
        table.insert(main.vertices, {x = i * main.period, y = main.waterheight, vel = 0, speed = 0})
    end

    -- Returns a useable polygon shape for rendering
    local function getPolygon(tb)
        poly = {}

        -- Lay down base
        for i = 0, love.graphics.getWidth(), main.period do
            table.insert(poly, love.graphics.getWidth() - i)
            table.insert(poly, love.graphics.getHeight())
        end

        for i,obj in ipairs(tb) do
            table.insert(poly, obj.x)
            table.insert(poly, obj.y)
        end

        -- If waves are greater than screen i.e. the points become negative this function will fail
        return love.math.triangulate(poly)
    end

    -- Creates a splash at a location
    function main:splash(xpos, speed)

        -- convert xpos to index location (roughly)
        index = 0

        -- Guess correct index
        for i = 0, love.graphics.getWidth(), main.period do
            if (xpos > i) and (xpos <= i + main.period) then
                break
            end
            index = index + 1
        end

        if (index >= 1 and index < #main.vertices) then
            main.vertices[index].y = main.vertices[index].y + speed
        end

    end

    -- Main logic function
    function main:logic()

        -- Adjust for each point
        for i, obj in ipairs(main.vertices) do
            x = obj.y - main.waterheight
            accel = (-main.friction * x) - main.dampening * obj.vel 

            obj.y = obj.y + obj.vel
            obj.vel = obj.vel + accel
        end

        leftdelta = {}
        rightdelta = {}

        for i = 0, #main.vertices do
            leftdelta[i] = 0
            rightdelta[i] = 0 
        end

        -- Make springs pull on their neighbours
        for j = 0, main.dispersion do

            -- Influence neighbours
            for i = 1, #main.vertices do

                if (i > 2) then
                    leftdelta[i] = main.spread * (main.vertices[i].y - main.vertices[i - 1].y)
                    main.vertices[i - 1].speed = main.vertices[i - 1].speed + leftdelta[i]
                end

                if (i < #main.vertices - 1) then
                    rightdelta[i] = main.spread * (main.vertices[i].y - main.vertices[i + 1].y)
                    main.vertices[i + 1].speed = main.vertices[i + 1].speed + rightdelta[i]
                end
            end

            -- Change height
            for i = 1, #main.vertices do
                if (i > 2) then
                    main.vertices[i - 1].y = main.vertices[i - 1].y + leftdelta[i]
                end
                if (i < #main.vertices - 1) then
                    main.vertices[i + 1].y = main.vertices[i + 1].y + rightdelta[i]
                end
            end
        end
    end

    -- Main rendering function
    function main:draw()
        love.graphics.setShader(main.watershader)

        -- Triangulate
        for i, obj in ipairs(getPolygon(main.vertices)) do
            love.graphics.polygon("fill", obj)
        end
        love.graphics.setShader()

        -- Debug draw
        if (_G.dbg.enabled == true) then
            for i, obj in ipairs(main.vertices) do

                if (math.floor(obj.y) ~= main.waterheight) then
                    love.graphics.setColor(255,0,0)
                else
                    love.graphics.setColor(0,255,0)
                end

                love.graphics.circle("line", obj.x, obj.y, 2, 10)
                
            end
        end
    end

    return main

end
