local score = 0
local missed = 0
local targets = {}

function love.load()
    -- Фиксируем ориентацию, если нужно, или просто разрешаем авто-подстройку
    width, height = love.graphics.getDimensions()
    spawnTimer = 0
end

function love.update(dt)
    -- Обновляем размеры экрана в реальном времени
    width, height = love.graphics.getDimensions()
    
    spawnTimer = spawnTimer + dt
    if spawnTimer > 1.5 then
        table.insert(targets, {
            x = math.random(50, width - 50),
            y = -50,
            speed = math.random(100, 300),
            radius = 40
        })
        spawnTimer = 0
    end

    for i = #targets, 1, -1 do
        local t = targets[i]
        t.y = t.y + t.speed * dt
        
        -- Если улетел за экран
        if t.y > height + t.radius then
            table.remove(targets, i)
            missed = missed + 1
        end
    end
end

function love.mousepressed(x, y, button)
    for i = #targets, 1, -1 do
        local t = targets[i]
        local dist = math.sqrt((x - t.x)^2 + (y - t.y)^2)
        if dist < t.radius then
            table.remove(targets, i)
            score = score + 1
            break
        end
    end
end

function love.draw()
    -- Рисуем фон
    love.graphics.clear(0.1, 0.1, 0.2)

    -- Рисуем шарики с градиентом (простой вариант)
    for _, t in ipairs(targets) do
        love.graphics.setColor(0.4, 1, 0.4)
        love.graphics.circle("fill", t.x, t.y, t.radius)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.circle("line", t.x, t.y, t.radius)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 20, 20, 0, 2, 2)
    love.graphics.print("Missed: " .. missed, 20, 60, 0, 2, 2)
end