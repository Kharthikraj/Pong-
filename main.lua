push = require 'push'

class = require 'class'

require 'Ball'

require 'Paddle'

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

playeronescore = 0
playertwoscore = 0

paddleSpeed = 200

playerserve = 0



function love.load()

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, resizable=true, vsync=true})

    -- fonts
    DefFont = love.graphics.newFont('retrofont.ttf', 8)
    ScoreFont = love.graphics.newFont('retrofont.ttf', 32)

    -- game states
    gameState = 'start'

    -- ball
    ball = Ball(VIRTUAL_WIDTH/2 - 2,VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- paddle
    paddle1 = Paddle(0, 10, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 5, VIRTUAL_HEIGHT - 30, 5, 20)

    -- sound fx gets argument static or stream
    sound = {
        ['paddle_collision'] = love.audio.newSource('paddle_collision.wav', 'static'),
        ['screen_collision'] = love.audio.newSource('paddle_collision.wav', 'static'),
        ['winner_sound'] = love.audio.newSource('winner.wav', 'static'),
        ['point'] = love.audio.newSource('point.wav', 'static')
    }
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'return' or key == 'enter' then
        if gameState == 'start' then
            gameState = 'play'
            
        elseif gameState == 'end' then
            gameState = 'start'
            playerserve = 0
            ball:reset()
            playeronescore = 0
            playertwoscore = 0
        end
    end


end

function love.update(dt)

    if gameState == 'play' then

        -- ball collision for paddle one
        if ball:collide(paddle1) then
            sound['paddle_collision']:play()
            ball.dx = - ball.dx * 1.2
            ball.x = ball.x + 5

            -- change velocity of y but in the same direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end

        -- ball collision for paddle two
        if ball:collide(paddle2) then
            sound['paddle_collision']:play()
            ball.dx = - ball.dx * 1.03
            ball.x = ball.x - 5

            -- change velocity of y but in the same direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 30)
            else 
                ball.dy = math.random(10, 30)
            end
        end

        -- ball screen collision 
        if ball.y + ball.height >= VIRTUAL_HEIGHT then
            ball.dy = - ball.dy
            sound['screen_collision']:play()
        end
        if ball.y <= 0 then
            ball.dy = -ball.dy
            sound['screen_collision']:play()
        end

        -- player one movement
        if love.keyboard.isDown('w') then
            paddle1:updateup(dt)
        elseif love.keyboard.isDown('s') then
            paddle1:updatedown(dt)
        end

        -- player two movement
        if love.keyboard.isDown('up') then
            paddle2:updateup(dt)
        elseif love.keyboard.isDown('down') then
            paddle2:updatedown(dt)
        end

        -- ball movement
        ball:update(dt)

        -- score update
        if ball.x + ball.width < 0 then
            sound['point']:play()
            playerserve = 1
            playertwoscore = playertwoscore + 1
            gameState = 'start'
            ball:reset()
        end
        if ball.x > VIRTUAL_WIDTH then
            sound['point']:play()
            playerserve = 2 
            playeronescore = playeronescore + 1
            gameState = 'start'
            ball:reset()
        end

    end
end

function love.draw()

    push:apply('start')

    -- background
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- welcome text
    if gameState == 'start' then
        love.graphics.setFont(DefFont)
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- paddle one
    paddle1:render()

    -- paddle two
    paddle2:render()

    -- ball
    if gameState == 'play' then
        ball:render()
    end

    -- scores
    if gameState == 'start' then
        love.graphics.setFont(ScoreFont)
        love.graphics.print(tostring(playeronescore), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
        love.graphics.print(tostring(playertwoscore), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
        love.graphics.setFont(DefFont)
        if playerserve == 1 then
            love.graphics.printf('Player one to serve!!', 0, 40, VIRTUAL_WIDTH, 'center')
        elseif playerserve == 2 then
            love.graphics.printf('Player two to serve!!', 0, 40, VIRTUAL_WIDTH, 'center')
        end
    end

    displayfps()

    -- winner!!
    love.graphics.setColor(0, 0, 1, 1)
    if playeronescore == 10 then
        gameState = 'end'
        love.graphics.printf('Player one has won!!', 0, VIRTUAL_HEIGHT/2 - 4, VIRTUAL_WIDTH, 'center')
        sound['winner_sound']:play()

    elseif playertwoscore == 10 then
        gameState = 'end'
        love.graphics.printf('Player two has won!!', 0, VIRTUAL_HEIGHT/2 - 4, VIRTUAL_WIDTH, 'center')
        sound['winner_sound']:play()
    end

    push:apply('end')
end

-- fps function
function displayfps()
    love.graphics.setFont(DefFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 50, 10)
end

function love.resize(w, h)
    push:resize(w, h)
end