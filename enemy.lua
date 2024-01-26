-- enemy.lua
local bullet = require("bullet")

local enemy = {
    width = 50,
    height = 50,
    hitbox = { x = 0, y = 0, width = 50, height = 50 },
    speed = 100,
    hp = 3,
    maxHp = 3,
    cooldown = 0,
    moveCooldown = 0,
    moveDuration = 1,
    moveSpeed = 200,
    maxY = 730,
    isDead = false,
    deathCooldown = 1,
}

local targetX, targetY = 0, 0
local moving = false

function enemy.newEnemy(x, y, size)
    local newEnemy = {
        x = x,
        y = y,
        width = size,
        height = size,
        hitbox = { x = x, y = y, width = size, height = size },
        speed = 100,
        hp = 3,
        maxHp = 3,
        cooldown = 0,
        moveCooldown = 0,
        moveDuration = 1,
        moveSpeed = 200,
        maxY = 730,
        isDead = false,
        deathCooldown = 1,
    }
    return newEnemy
end

function enemy.load(e)
    e.x = love.math.random(0, 1920 - e.width)
    e.y = love.math.random(400, 730 - e.height)
    setRandomPosition(e)
end

function setRandomPosition(e)
    e.targetX = love.math.random(0, 1920 - e.width)
    e.targetY = love.math.random(400, 730 - e.height)
    e.moving = true
end

function enemy.update(e, dt, otherEnemies)
    if e.hp <= 0 then
        e.isDead = true
        e.deathCooldown = e.deathCooldown - dt
        if e.deathCooldown <= 0 then
            respawnEnemy(e, otherEnemies)
        end
        return
    end

    e.cooldown = e.cooldown - dt
    if e.cooldown <= 0 then
        bullet.shoot('down', e.x + e.width / 2, e.y + e.height) -- Shoot from the center bottom
        e.cooldown = love.math.random(2, 6)
    end

    if e.moving then
        local dx = e.targetX - e.x
        local dy = e.targetY - e.y
        local distance = math.sqrt(dx^2 + dy^2)

        if distance > 1 then
            local moveAmount = e.moveSpeed * dt
            local angle = math.atan2(dy, dx)
            e.x = e.x + moveAmount * math.cos(angle)
            e.y = e.y + moveAmount * math.sin(angle)
            updateHitbox(e) -- Update hitbox along with position
        else
            e.x = e.targetX
            e.y = e.targetY
            e.moving = false
            e.moveCooldown = e.moveDuration
            updateHitbox(e) -- Update hitbox for the final position
        end
    else
        e.moveCooldown = e.moveCooldown - dt
        if e.moveCooldown <= 0 then
            setRandomPosition(e)
        end
    end

    -- Check for collision with other enemies
    for _, otherEnemy in ipairs(otherEnemies) do
        if otherEnemy ~= e and checkCollision(e, otherEnemy) then
            setRandomPosition(e)
            break
        end
    end

    bullet.update(dt, player, e)
end

function respawnEnemy(e, otherEnemies)
    e.isDead = false
    e.deathCooldown = 1
    repeat
        e.x = love.math.random(0, 1920 - e.width)
        e.y = love.math.random(400, 730 - e.height)
    until not checkCollisionWithOtherEnemies(e, otherEnemies)
    setRandomPosition(e)
end

function enemy.load(e)
    e.x = love.math.random(0, 1920 - e.width)
    e.y = love.math.random(400, 730 - e.height)
    setRandomPosition(e)
end

function checkCollisionWithOtherEnemies(e, otherEnemies)
    for _, otherEnemy in ipairs(otherEnemies) do
        if otherEnemy ~= e and checkCollision(e.hitbox, otherEnemy.hitbox) then
            return true
        end
    end
    return false
end

function updateHitbox(e)
    e.hitbox.x = e.x
    e.hitbox.y = e.y
end

function enemy.draw(e)
    if not e.isDead then
        -- Draw enemy
        love.graphics.setColor(0.8, 0, 0)
        love.graphics.rectangle("fill", e.x, e.y, e.width, e.height)
        love.graphics.setColor(1, 1, 1)

        -- Draw health bar
        local healthBarWidth = 50
        local healthBarHeight = 10
        local healthBarX = e.x + (e.width - healthBarWidth) / 2
        local healthBarY = e.y - healthBarHeight - 5

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", healthBarX, healthBarY, healthBarWidth * (e.hp / e.maxHp), healthBarHeight)
        love.graphics.setColor(1, 1, 1)
    end
end

return enemy
