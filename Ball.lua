Ball = class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:reset()
    if playerserve == 1 then
        self.x = VIRTUAL_WIDTH/2 - 2
        self.y = VIRTUAL_HEIGHT/2 - 2
        self.dx = 100 
        self.dy = math.random(-50, 50)
    elseif playerserve == 2 then
        self.x = VIRTUAL_WIDTH/2 - 2
        self.y = VIRTUAL_HEIGHT/2 - 2
        self.dx = -100
        self.dy = math.random(-50, 50)
    else
        self.x = VIRTUAL_WIDTH/2 - 2
        self.y = VIRTUAL_HEIGHT/2 - 2
        self.dx = math.random(2) == 1 and 100 or -100
        self.dy = math.random(-50, 50)
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collide(paddle)
    if paddle.x + paddle.width < self.x or paddle.x > self.x + self.width then
        return false
    end
    if paddle.y > self.y + self.height or self.y > paddle.y + paddle.height then
        return false
    end
     
    return true
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end