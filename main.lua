function love.load()
    Object = require("dependencies/classic")
    require("entity")
    require("player")
    require("enemy")

    font = love.graphics.newFont(32)

    player = Player("fill", 100, 100, 200, 50)
    enemy = Enemy("line", 100, 400, 200, 50)
end

function love.update(dt)
    player:update(dt, enemy)

    if love.keyboard.isDown("space") and player.state == "dead" then
        player:restart_game()
        player.state = "alive"
    end
end

function love.draw()
    player:draw()
    enemy:draw()
    love.graphics.setFont(font)
    if player.state == "dead" and player:check_collision(enemy) then
        love.graphics.print("GAME OVER", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    end
end
