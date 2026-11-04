-- local scroll_speed = 750
local scroll_speed = 750
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
    
    love.window.setMode(1250, 750)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    highscore = 0
    counter = 0
    score = 0
    milestone = 0

    blinking = false
    blink_timer = 0
    blink_duration = 2.5
    blink_score = 0
end


function love.update(dt)
    if player.state ~= "dead" then
        player:update(dt)
        counter = counter + 6 * dt
    end

    scroll_offset = scroll_offset + scroll_speed * dt
    score = math.floor(counter)

    if score > 0 and score % scroll_steps == 0 and score ~= milestone then
        scroll_speed = scroll_speed + 25
        blinking = true
        blink_timer = blink_duration
        blink_score = score
        milestone = score
    end

    -- runterzählen
    if blinking and player.state ~= "dead" then
        blink_timer = blink_timer - dt
        if blink_timer <= 0 then
            blinking = false
       end
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

        rand2 = math.random(50, 200)
        for i = 1, rand do
            local cluster_offset = (i - 1) * 40
            table.insert(obstacles, {
                x = 1200 + cluster_offset - rand2,
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
        milestone = 0
        blinking = false
    end
end

function blinking_text(score)
    -- if not blinking then love.graphics.print(string.format("%06d", score), 800, 100, 0, 3, 3)
    -- elseif math.floor(love.timer.getTime()) % 2 == 0 then
    --     love.graphics.print(string.format("%06d", score), 800, 100, 0, 3, 3)
    -- end

    if player.state == "dead" then
        if math.floor(love.timer.getTime() * 2) % 2 == 0 then
            print_game_over()
        end
    end
    
    if blinking then
        if math.floor(love.timer.getTime() * 2.5) % 2 == 0 then
            love.graphics.print(string.format("%06d", milestone), love.graphics.getWidth() - 225, 100, 0, 3, 3)
        end
        love.graphics.print("HI " .. ((player.state == "dead") and string.format("%06d", highscore) or highscore), 100, 100, 0, 3, 3)
    else
        love.graphics.print(string.format("%06d", score), love.graphics.getWidth() - 225, 100, 0, 3, 3)
        if highscore > 0 then
            love.graphics.print("HI " .. string.format("%06d", highscore), 100, 100, 0, 3, 3)
        else
            love.graphics.print("HI " .. ((player.state == "dead") and string.format("%06d", highscore) or highscore), 100, 100, 0, 3, 3)
        end
    end
    -- blinking = false
end

function debug()
    love.graphics.print("DEBUG:", 50, 550, 0, 2, 2)
    love.graphics.print("RAND_VAL> "..rand2, 100, 580, 0, 2, 2)
    love.graphics.print("WIDTH> "..love.graphics.getWidth(), 100, 610, 0, 2, 2)
    love.graphics.print("HEIGHT> "..love.graphics.getHeight(), 100, 640, 0, 2, 2)
end

function print_game_over()
    local scale = 4
    local text = "GAME OVER"
    local textWidth = love.graphics.getFont():getWidth(text) * scale
    local textHeight = love.graphics.getFont():getHeight(text) * scale
    local x = (love.graphics.getWidth() / 2) - (textWidth / 2)
    local y = (love.graphics.getHeight() / 2) - (textHeight / 2)

    love.graphics.setColor(122, 6, 6)
    love.graphics.print(text, x, y-150, 0, scale, scale)
end

function love.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    love.graphics.setColor(1, 0, 0)
    player:draw()

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 400, love.graphics.getWidth(), 20)

    love.graphics.setColor(0, 1, 0)
    for _, o in ipairs(obstacles) do
        love.graphics.rectangle("fill", o.x, o.y, o.width, o.height)
    end


    -- 1250 X 750 
    -- love.graphics.print("HI " .. ((player.state == "dead") and string.format("%06d", highscore) or highscore), 100, 100, 0, 3, 3)
    -- love.graphics.print(string.format("%06d", score), love.graphics.getWidth() - 225, 100, 0, 3, 3)
    blinking_text(score)
    debug()
    if player.state == "dead" then

        -- blinking = true

        if love.keyboard.isDown("escape") then
            love.event.quit()
        end
        
        if highscore < score then
            highscore = score
        end
        scroll_speed = 300

        love.graphics.setColor(1, 1, 1)
        -- love.graphics.print("GAME OVER", love.graphics.getWidth() / 3, love.graphics.getHeight() / 4, 0, 4, 4, -40)
        
        -- love.graphics.print( text,        x,                                                                               y,                            r, sx, sy, ox, oy, kx, ky )
        -- love.graphics.print("Example Text", (love.graphics.getWidth( )/2-love.graphics.getFont():getWidth("Example Text")/2), 10, 0, 1, 1)
        print_game_over()
    end
end
