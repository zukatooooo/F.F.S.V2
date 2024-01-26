-- bullet.lua
local bullet = {
    speed = 500,
    bullets = {}
}

function bullet.load()
end

function bullet.update(dt, player, enemy)
    for i = #bullet.bullets, 1, -1 do
        local b = bullet.bullets[i]

        if b.direction == 'up' then
            b.y = b.y - bullet.speed * dt
        elseif b.direction == 'down' then
            b.y = b.y + bullet.speed * dt
        end

        -- Check for collisions with player
        if player and player.hp and checkCollision(b, player) then
            table.remove(bullet.bullets, i)
            player.hp = player.hp - 1
        end

        -- Check for collisions with enemy
        if enemy and enemy.hp and checkCollision(b, enemy) then
            table.remove(bullet.bullets, i)
            enemy.hp = enemy.hp - 1
        end

        -- Remove bullets that go off-screen
        if b.y > 1080 or b.y < 0 then
            table.remove(bullet.bullets, i)
        end
    end
end

function bullet.draw()
    love.graphics.setColor(1, 1, 1)
    for _, b in ipairs(bullet.bullets) do
        love.graphics.rectangle("fill", b.x, b.y, 5, 10)
    end
    love.graphics.setColor(1, 1, 1)
end

function bullet.shoot(direction, x, y)
    table.insert(bullet.bullets, { x = x, y = y, direction = direction })
end

-- Function to check for collision between two rectangles
function checkCollision(a, b)
    return a.x < b.hitbox.x + b.hitbox.width and
           a.x + 5 > b.hitbox.x and
           a.y < b.hitbox.y + b.hitbox.height and
           a.y + 10 > b.hitbox.y
end

return bullet
