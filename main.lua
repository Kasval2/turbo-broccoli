-- Настройки экрана для мобилки
local screenW = love.graphics.getWidth()
local screenH = love.graphics.getHeight()

-- Переменные игры
local score = 0
local lives = 3
local targets = {}

-- Функция создания нового "врага"
function spawnTarget()
    local target = {
        x = math.random(50, screenW - 50),
        y = -50,
        speed = math.random(100, 300),
        radius = 40,
        color = {math.random(), math.random(), math.random()}
    }
    table.insert(targets, target)
end

function love.load()
    math.randomseed(os.time())
    -- Создаем первого врага через 1 секунду
    spawnTimer = 1
end

function love.update(dt)
    spawnTimer = spawnTimer - dt
    if spawnTimer <= 0 then
        spawnTarget()
        spawnTimer = 1.5 -- Интервал появления
    end

    -- Двигаем цели вниз
    for i = #targets, 1, -1 do
        local t = targets[i]
        t.y = t.y + t.speed * dt

        -- Если упал за экран - теряем жизнь
        if t.y > screenH + t.radius then
            table.remove(targets, i)
            lives = lives - 1
        end
    end
end

function love.draw()
    -- Фон
    love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

    -- Рисуем цели
    for _, t in ipairs(targets) do
        love.graphics.setColor(t.color)
        love.graphics.circle("fill", t.x, t.y, t.radius)
    end

    -- Интерфейс
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("СЧЕТ: " .. score, 20, 20, 0, 2, 2)
    love.graphics.print("ЖИЗНИ: " .. lives, 20, 60, 0, 2, 2)

    if lives <= 0 then
        love.graphics.printf("ИГРА ОКОНЧЕНА!", 0, screenH/2, screenW/2, "center", 0, 4, 4)
    end
end

-- Обработка тапа на телефоне
function love.mousepressed(x, y, button)
    if lives <= 0 then return end
    
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