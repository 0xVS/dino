local groundY = 400
local scrollSpeed = 300
local jumpSpeed = -350
local gravity = 1000

Player = Entity:extend()

function Player:new(mode, x, y, vy, height, width)
    self.mode = mode
    self.speed = 500
    self.velocity_y = vy
    self.start_x = x
    self.start_y = y
    self.state = "alive"
    self.ducking = false
    Player.super.new(self, x, y, height, width)
end

function Player:restart_game()
    self.state = "alive"
    self.x = self.start_x
    self.y = self.start_y
    self.velocity_y = 0
    self.height = 40
    self.ducking = false
end

function Player:update(dt)
    if self.state == "dead" then
        return
    end

    self:keypressed(dt)

    self.y = self.y + self.velocity_y * dt
    self.velocity_y = self.velocity_y + gravity * dt
    if self.y + self.height > groundY then
        self.y = groundY - self.height
        self.velocity_y = 0
    end
end

function Player:draw()
    love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end

function Player:check_collision(e)
    return self.super.check_collision(self, e)
end

function Player:keypressed(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if (love.keyboard.isDown("up") or love.keyboard.isDown("space") or love.keyboard.isDown("w")) and (self.y + self.height >= groundY) then
        self.velocity_y = jumpSpeed
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.ducking = true
        self.height = 20
        self.y = groundY - self.height
    else
        self.ducking = false
        self.height = 40
    end
end
