Enemy = Entity:extend()

function Enemy:new(mode, x, y, height, width)
    self.mode = mode
    Enemy.super.new(self, x, y, height, width)
end

function Enemy:draw()
   love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
end


