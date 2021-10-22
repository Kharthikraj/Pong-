Paddle = class{}

function Paddle:init(x, y, width, height, speed)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = paddleSpeed
end

function Paddle:updateup(dt)
    self.y = math.max(0, self.y - self.speed * dt)
end

function Paddle:updatedown(dt)
    self.y = math.min(VIRTUAL_HEIGHT - 20,self.y + self.speed * dt)
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end