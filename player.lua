Player = Entity:extend()

function Player:new(mode, x, y, height, width)
    self.mode = mode
    self.speed = 500

    self.start_x = x
    self.start_y = y

    self.state = "alive"

    Player.super.new(self, x, y, height, width)
end

function Player:restart_game()
    self.state = "alive"
    self.x = self.start_x
    self.y = self.start_y
end

function Player:update(dt, e)
    if self.state == "dead" then
        return
    end

    if not self:check_collision(e) then
        self:keypressed(dt) 
    else
        -- love.graphics.print("TEST", (love.graphics.getWidth() / 2), (love.graphics.getHeight()/2))
        -- self:restart_game()
        self.state = "dead"
    end
end


function Player:draw()
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:check_collision(e)
    return self.super.check_collision(self, e)
end

function Player:keypressed(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("up", "w") then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown("down", "s") then
        self.y = self.y + self.speed * dt
    end

    if love.keyboard.isDown("right", "d") then
        self.x = self.x + self.speed * dt
    elseif love.keyboard.isDown("left", "a") then
        self.x = self.x - self.speed * dt
    end
end
