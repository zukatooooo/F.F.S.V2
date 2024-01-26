-- main.lua
local player = require("player")
local enemy = require("enemy")
local bullet = require("bullet")

local enemies = {}
local numEnemies = 7

function love.load()
    love.window.setTitle("Shooter Game")
    love.window.setMode(1920, 1080)
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

    player.load()

    for i = 1, numEnemies do
        local randomX = love.math.random(0, 1920)
        local randomY = love.math.random(0, 700)

        local newEnemy = enemy.newEnemy(randomX, randomY, 50)
        table.insert(enemies, newEnemy)
    end

    bullet.load()
end

function love.update(dt)
    player.update(dt)

    for i = #enemies, 1, -1 do
        local e = enemies[i]
        enemy.update(e, dt, enemies)
        if e.isDead then
            table.remove(enemies, i)
        end
    end

    bullet.update(dt, player, enemies)
end

function love.draw()
    player.draw()

    for _, e in ipairs(enemies) do
        enemy.draw(e)
    end

    bullet.draw()
end
