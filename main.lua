local scroll_speed = 300
local scroll_steps = 100
local scroll_offset = 0

local obstacles = {}
local player

function love.load()
    Object = require("dependencies/classic")
    require("entity")
    require("player")
    require("enemy")

    player = Player("fill", 100, 360, 0, 40, 40)
    
    love.window.setMode(1000, 600)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    highscore = 0
    counter = 0
    score = 0

    blinking = false
    -- blink_timer = 0
    -- blink_duration = 1.5
    -- blink_score = 0
end

function love.update(dt)
    if player.state ~= "dead" then
        player:update(dt)
        counter = counter + 0.1
    end

    scroll_offset = scroll_offset + scroll_speed * dt

    score = math.floor(counter)

    if score % scroll_steps == 0 then
        scroll_speed = scroll_speed + 25
        blinking = true
    end

    if #obstacles == 0 or obstacles[#obstacles].x < -250 then
        local rand = love.math.random(1, 3)
        
        local low, mid, high = 20, 50, 85
        local h

        if rand == 1 then
            local r = math.random()
            h = (r < 0.33) and low or (r < 0.66) and mid or high
            
        elseif rand == 2 then
            h = (math.random() < 0.5) and mid or high
            
        elseif rand == 3 then
            h = (math.random() < 0.5) and low or mid
        end

        for i = 1, rand do
            local cluster_offset = (i - 1) * 40
            table.insert(obstacles, {
                x = 900 + cluster_offset,
                y = 400 - h,
                width = 30,
                height = h
            })
        end
    end

    for i = #obstacles, 1, -1 do
        local o = obstacles[i]
        if player.state == "alive" then o.x = o.x - scroll_speed * dt end
        if player:check_collision(o) then
            player.state = "dead"
            break
        end
        if o.x + o.width < -60 then
            table.remove(obstacles, i)
        end
    end

    if love.keyboard.isDown("return") and player.state == "dead" then
        player:restart_game()
        obstacles = {}
        counter = 0
    end
end

function blinking_text()
    if not blinking then love.graphics.print(string.format("%06d", score), 800, 100, 0, 3, 3)
    -- elseif math.floor(love.timer.getTime())
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 0, 0)
    player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 400, 1000, 20)


    love.graphics.setColor(0, 1, 0)
    for _, o in ipairs(obstacles) do
        love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
    end

    love.graphics.print(string.format("%06d", score), 800, 100, 0, 3, 3)
    love.graphics.print("HI " .. ((player.state == "dead") and string.format("%06d", highscore) or highscore), 100, 100, 0, 3, 3)


    if player.state == "dead" then
        if love.keyboard.isDown("escape") then
            love.event.quit()
        end
        
        if highscore < score then
            highscore = score
        end
        scroll_speed = 300

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("GAME OVER", love.graphics.getWidth() / 3, love.graphics.getHeight() / 4, 0, 4, 4)
    end
end
