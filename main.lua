local player = { x = 0, y = 0, radius = 30 }
local enemies = {}
local score = 0
local gameOver = false

function love.load()
    width, height = love.graphics.getDimensions()
    player.x = width / 2
    player.y = height / 2
    spawnTimer = 0
end

function love.update(dt)
    if gameOver then return end

    width, height = love.graphics.getDimensions()
    player.x = width / 2
    player.y = height / 2

    spawnTimer = spawnTimer + dt
    if spawnTimer > 1 then
        -- Появление врагов с разных сторон экрана
        local side = math.random(1, 4)
        local ex, ey
        if side == 1 then ex, ey = -20, math.random(0, height) -- Слева
        elseif side == 2 then ex, ey = width + 20, math.random(0, height) -- Справа
        elseif side == 3 then ex, ey = math.random(0, width), -20 -- Сверху
        else ex, ey = math.random(0, width), height + 20 end -- Снизу

        table.insert(enemies, { x = ex, y = ey, speed = 150 + score * 5 })
        spawnTimer = 0
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]
        -- Враги летят к центру (к тебе)
        local angle = math.atan2(player.y - e.y, player.x - e.x)
        e.x = e.x + math.cos(angle) * e.speed * dt
        e.y = e.y + math.sin(angle) * e.speed * dt

        -- Проверка столкновения с игроком
        local dist = math.sqrt((e.x - player.x)^2 + (e.y - player.y)^2)
        if dist < player.radius + 15 then
            gameOver = true
        end
    end
end

function love.mousepressed(x, y, button)
    if gameOver then
        -- Рестарт при тапе после проигрыша
        enemies = {}
        score = 0
        gameOver = false
        return
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]
        local dist = math.sqrt((x - e.x)^2 + (y - e.y)^2)
        if dist < 40 then -- Радиус тапа
            table.remove(enemies, i)
            score = score + 1
            break
        end
    end
end

function love.draw()
    love.graphics.clear(0.05, 0.05, 0.1) -- Темный космос

    -- Игрок
    love.graphics.setColor(0, 0.8, 1)
    love.graphics.circle("line", player.x, player.y, player.radius + math.sin(love.timer.getTime()*5)*5)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- Враги
    love.graphics.setColor(1, 0.3, 0.3)
    for _, e in ipairs(enemies) do
        love.graphics.circle("fill", e.x, e.y, 15)
    end

    -- Интерфейс
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Kills: " .. score, 20, 20, 0, 2, 2)

    if gameOver then
        love.graphics.printf("GAME OVER\nTap to Restart", 0, height/2 - 40, width/2, "center", 0, 2, 2)
    end
end