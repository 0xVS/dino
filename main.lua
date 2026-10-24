local scroll_speed = 300
local scroll_offset = 0

local obstacles = {}
local player

function love.load()
    Object = require("dependencies/classic")
    require("entity")
    require("player")
    require("enemy")

    player = Player("fill", 100, 360, 0, 40, 40)
end

function love.update(dt)
    if player.state ~= "dead" then
        player:update(dt)
    end

    scroll_offset = scroll_offset + scroll_speed * dt

    if #obstacles == 0 or obstacles[#obstacles].x < -250 then
        local h = math.random() < 0.5 and 40 or 20
        table.insert(obstacles, { x = 800, y = 400 - h, width = 30, height = h })
    end

    for i = #obstacles, 1, -1 do
        local o = obstacles[i]
        o.x = o.x - scroll_speed * dt
        if player:check_collision(o) then
            player.state = "dead"
            break
        end
        if o.x + o.width < -60 then
            table.remove(obstacles, i)
        end
    end

    if love.keyboard.isDown("space") and player.state == "dead" then
        player:restart_game()
        obstacles = {}
    end
end

function love.draw()
    love.graphics.setColor(0.95, 0.85, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(0.45, 0.75, 0.45)
    love.graphics.rectangle("fill", -((scroll_offset * 0.2) % 400) - 200, 0, 400, 400)

    love.graphics.setColor(0.25, 0.55, 0.35)
    love.graphics.rectangle("fill", -((scroll_offset * 0.5) % 400) - 200, 400, 400, 120)

    love.graphics.setColor(0.8, 0.6, 0.4)
    love.graphics.rectangle("fill", 0, 400, 800, 20)

    player:draw()

    love.graphics.setColor(0.15, 0.15, 0.15)
    for _, o in ipairs(obstacles) do
        love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
    end

    if player.state == "dead" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GAME OVER", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
end
