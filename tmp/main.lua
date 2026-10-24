-- ============================================================================
-- infinite_dino_demo.lua
-- ============================================================================
-- Standalone showcase of the "Chrome Dino" endless-scrolling ideas, built
-- with the same building blocks you already use in your game:
--   - AABB collision (like Entity:check_collision)
--   - state machine (alive / dead) + restart on space
--   - love.graphics drawing
--
-- NOTE: LÖVE only supports ONE love.load / love.update / love.draw per state.
-- To run this demo, replace the contents of main.lua with this file (or
-- comment out the require(...) calls in main.lua and paste this in).
-- ============================================================================

local groundY = 400
local scrollSpeed = 300
local jumpSpeed = -350
local gravity = 1000

-- player: x, y (top-left), w, h, vy, ducking
local player = { x = 100, y = groundY - 40, w = 40, h = 40, vy = 0, ducking = false }
local obstacles = {}
local state = "alive"

local function reset()
    player.x = 100
    player.y = groundY - 40
    player.vy = 0
    player.ducking = false
    player.h = 40
    obstacles = {}
    state = "alive"
end

local function overlaps(a, b)
    return a.x + a.w > b.x and a.x < b.x + b.w
        and a.y + a.h > b.y and a.y < b.y + b.h
end

function love.load() end

function love.update(dt)
    -- death state: freeze, wait for restart
    if state == "dead" then
        if love.keyboard.isDown("space") then
            reset()
        end
        return
    end

    -- 1) endless scroll
    --player.x = player.x + scrollSpeed * dt

    -- 2) jump + gravity
    if love.keyboard.isDown("up", "space", "w") and (player.y + player.h >= groundY) then
        player.vy = jumpSpeed
    end
    player.y = player.y + player.vy * dt
    player.vy = player.vy + gravity * dt
    if player.y + player.h > groundY then
        player.y = groundY - player.h
        player.vy = 0
    end

    -- 3) duck
    if love.keyboard.isDown("down", "s") then
        player.ducking = true
        player.h = 20
    else
        player.ducking = false
        player.h = 40
    end

    -- 4) spawn obstacles (tall => jump over, short => duck under)
    if #obstacles == 0 or obstacles[#obstacles].x < -250 then
        local h = math.random() < 0.5 and 40 or 20
        table.insert(obstacles, { x = 800, y = groundY - h, w = 30, h = h })
    end

    -- 5) move obstacles + collision
    for i = #obstacles, 1, -1 do
        local o = obstacles[i]
        o.x = o.x - scrollSpeed * dt
        if overlaps(player, o) then
            state = "dead"
            break
        end
        if o.x + o.w < -60 then
            table.remove(obstacles, i)
        end
    end
end

function love.draw()
    -- parallax backgrounds (offset scaled by different factors)
    love.graphics.clear(0.95, 0.85, 0.7)
    love.graphics.setColor(0.45, 0.75, 0.45)
    love.graphics.rectangle("fill", -((player.x * 0.2) % 400) - 200, 0, 400, 400)
    love.graphics.setColor(0.25, 0.55, 0.35)
    love.graphics.rectangle("fill", -((player.x * 0.5) % 400) - 200, 400, 400, 120)
    love.graphics.setColor(0.8, 0.6, 0.4)
    love.graphics.rectangle("fill", 0, groundY, 800, 20)

    -- player
    love.graphics.setColor(0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- obstacles
    love.graphics.setColor(0.15, 0.15, 0.15)
    for _, o in ipairs(obstacles) do
        love.graphics.rectangle("fill", o.x, o.y, o.w, o.h)
    end

    -- death screen text
    if state == "dead" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("RESTART", 400, 150)
    end
end

return {
    reset = reset,
    overlaps = overlaps,
}
