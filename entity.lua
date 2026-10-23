Entity = Object:extend()


--
--      Idee für später:
-- function Entity:new(x, y, image_path)
--     self.x = x
--     self.y = y
--     self.image = love.graphics.newImage(image_path)
--     self.width = self.image:getWidth()
--     self.height = self.image:getHeight()
-- end

function Entity:new(x, y, height, width)
    self.x = x 
    self.y = y
    self.height = height
    self.width = width
end

function Entity:update(dt)
    self:keypressed(dt) 
end

function Entity:check_collision(e)
   return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end

function Entity:draw()
    love.graphics.rectangle(self.mode or "fill", self.x, self.y, self.width, self.height)
end

