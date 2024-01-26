-- player.lua
local bullet = require("bullet")

local player = {
    x = 960,
    y = 1080 - 50,
    width = 50,
    height = 50,
    hitbox = { x = 960, y = 1080 - 50, width = 50, height = 50 },
    speed = 400,
    hp = 3,
    maxHp = 3,
    cooldown = 0
}

function player.load()
end

function player.update(dt)
    if love.keyboard.isDown("w") and player.y > 730 then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") and player.y < 1025 then
        player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown("a") and player.x > 0 then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("d") and player.x < 1868 then
        player.x = player.x + player.speed * dt
    end

    player.hitbox.x = player.x
    player.hitbox.y = player.y

    player.cooldown = player.cooldown - dt
    if love.keyboard.isDown("space") and player.cooldown <= 0 then
        bullet.shoot('up', player.x + player.width / 2, player.y - player.height) -- Shoot from the center top
        player.cooldown = 0.5
    end

    bullet.update(dt, player, enemies)
end

function player.draw()
    -- Draw player
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.setColor(1, 1, 1)

    -- Draw health bar
    local healthBarWidth = 50
    local healthBarHeight = 10
    local healthBarX = player.x + (player.width - healthBarWidth) / 2
    local healthBarY = player.y - healthBarHeight - 5

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", healthBarX, healthBarY, healthBarWidth * (player.hp / player.maxHp), healthBarHeight)
    love.graphics.setColor(1, 1, 1)
end

return player
