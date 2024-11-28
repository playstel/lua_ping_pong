-- Константы
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
PADDLE_WIDTH = 10
PADDLE_HEIGHT = 100
BALL_SIZE = 10
PADDLE_SPEED = 400
BALL_SPEED = 300

-- Цвета
BACKGROUND_COLOR = {1.0, 0.8, 0.9} -- Мягко-розовый фон (RGB в формате [0-1])

-- Инициализация
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = false, vsync = true})
    love.window.setTitle("Ping Pong Game")

    -- Левая ракетка
    player1 = {x = 10, y = (WINDOW_HEIGHT - PADDLE_HEIGHT) / 2, score = 0}
    -- Правая ракетка
    player2 = {x = WINDOW_WIDTH - 20, y = (WINDOW_HEIGHT - PADDLE_HEIGHT) / 2, score = 0}

    -- Мяч
    ball = {x = WINDOW_WIDTH / 2 - BALL_SIZE / 2, y = WINDOW_HEIGHT / 2 - BALL_SIZE / 2, dx = BALL_SPEED, dy = BALL_SPEED}
end

-- Управление игроками
-- dt — разница во времени между кадрами игры в сек (если BALL_SPEED = 300 пикселей/секунду, то за один кадр мяч сместится на 4.8 пикселя если FPS 60)
function love.update(dt)
    -- Игрок 1 (W/S)
    if love.keyboard.isDown("w") then
        player1.y = math.max(0, player1.y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("s") then
        player1.y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player1.y + PADDLE_SPEED * dt)
    end

    -- Игрок 2 (UP/DOWN)
    if love.keyboard.isDown("up") then
        player2.y = math.max(0, player2.y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("down") then
        player2.y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player2.y + PADDLE_SPEED * dt)
    end

    -- Движение мяча
    -- dx, dy - приращения координат объекта по горизонтали (X) и вертикали (Y) за единицу времени.
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Отражение от стен
    if ball.y <= 0 or ball.y >= WINDOW_HEIGHT - BALL_SIZE then
        ball.dy = -ball.dy
    end

    -- Отражение от ракеток
    if checkCollision(ball, player1) then
        ball.dx = math.abs(ball.dx)
    elseif checkCollision(ball, player2) then
        ball.dx = -math.abs(ball.dx)
    end

    -- Выход мяча за границы
    if ball.x < 0 then
        player2.score = player2.score + 1
        resetBall()
    elseif ball.x > WINDOW_WIDTH then
        player1.score = player1.score + 1
        resetBall()
    end
end

-- Проверка столкновения
function checkCollision(ball, paddle)
    return ball.x < paddle.x + PADDLE_WIDTH and
           ball.x + BALL_SIZE > paddle.x and
           ball.y < paddle.y + PADDLE_HEIGHT and
           ball.y + BALL_SIZE > paddle.y
end

-- Сброс мяча
function resetBall()
    ball.x = WINDOW_WIDTH / 2 - BALL_SIZE / 2
    ball.y = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
    ball.dx = -ball.dx
    ball.dy = BALL_SPEED * (math.random(2) == 1 and 1 or -1)
end

-- Рисование
function love.draw()
    -- Установим цвет фона
    love.graphics.clear(BACKGROUND_COLOR)

    -- Игровое поле
    love.graphics.setColor(1, 1, 1) -- Белый цвет для ракеток и мяча
    love.graphics.rectangle("fill", player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle("fill", player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle("fill", ball.x, ball.y, BALL_SIZE, BALL_SIZE)

    -- Очки
    love.graphics.setColor(1, 1, 1) -- Белый цвет для текста
    love.graphics.print("Player 1: " .. player1.score, 10, 10)
    love.graphics.print("Player 2: " .. player2.score, WINDOW_WIDTH - 100, 10)
end
