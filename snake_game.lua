local Entity = require('entity')
local Vector2 = require('vector2')
local Events = require('events')
local UI = require('ui')
local SnakeGame = {}
SnakeGame.__index = SnakeGame
function SnakeGame:new(options)
    options = options or {}
    local game = setmetatable({width = options.width or 24, height = options.height or 18,
        interval = options.interval or 0.12, random = options.random or math.random,
        events = options.events or Events:new()}, self)
    assert(game.width >= 4 and game.height >= 2 and game.interval > 0)
    game:reset()
    return game
end
function SnakeGame:reset()
    local x, y = math.floor(self.width / 2), math.floor(self.height / 2)
    self.snake = Entity:new()
        :addComponent('position', Vector2:new(x, y))
        :addComponent('movement', {dx = 1, dy = 0})
        :addComponent('renderer', {color = {0.12, 0.95, 0.76}, size = 24})
    self.body = {Vector2:new(x, y), Vector2:new(x - 1, y), Vector2:new(x - 2, y)}
    self.score, self.elapsed, self.over, self.won = 0, 0, false, false
    self.gameOver = false
    self.pending = nil
    self:spawnFood()
end
function SnakeGame:spawnFood()
    local free = {}
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local p, occupied = Vector2:new(x, y), false
            for _, segment in ipairs(self.body) do
                if p == segment then occupied = true; break end
            end
            if not occupied then free[#free + 1] = p end
        end
    end
    self.food = #free > 0 and free[self.random(#free)] or nil
    return self.food ~= nil
end
function SnakeGame:changeDirection(dx, dy)
    if self.over or self.pending or math.abs(dx) + math.abs(dy) ~= 1 then return false end
    local movement = self.snake:getComponent('movement')
    if dx == -movement.dx and dy == -movement.dy then return false end
    if dx == movement.dx and dy == movement.dy then return false end
    self.pending = {dx = dx, dy = dy}
    return true
end
SnakeGame.setDirection = SnakeGame.changeDirection
function SnakeGame:finish(reason)
    if self.over then return end
    self.over, self.won = true, reason == 'won'
    self.gameOver = true
    self.events:emit('game_over', {score = self.score, reason = reason})
end
function SnakeGame:step()
    if self.over then return end
    local movement = self.snake:getComponent('movement')
    if self.pending then
        movement.dx, movement.dy = self.pending.dx, self.pending.dy
        self.pending = nil
    end
    local head = self.body[1] + Vector2:new(movement.dx, movement.dy)
    if head.x < 0 or head.y < 0 or head.x >= self.width or head.y >= self.height then
        self:finish('wall'); return
    end
    local eating = self.food ~= nil and head == self.food
    -- The tail vacates its cell on non-growing moves.
    local limit = #self.body - (eating and 0 or 1)
    for i = 1, limit do
        if head == self.body[i] then self:finish('self'); return end
    end
    table.insert(self.body, 1, head)
    self.snake:addComponent('position', head)
    if eating then
        self.score = self.score + 10
        self.events:emit('food_eaten', {score = self.score, position = head})
        if not self:spawnFood() then self:finish('won') end
    else table.remove(self.body) end
end
function SnakeGame:update(dt)
    if self.over then return end
    self.elapsed = self.elapsed + math.min(math.max(dt, 0), 0.5)
    while self.elapsed >= self.interval and not self.over do
        self.elapsed = self.elapsed - self.interval
        self:step()
    end
end
function SnakeGame:draw(context)
    local c, g = context or {best = 0, time = 0}, self
    local size, ox, oy = g.snake:getComponent('renderer').size, 24, 72
    UI.background()
    UI.text('NEON SNAKE', 24, 20, 240, 24, {0.3, 0.95, 1})
    UI.text('SCORE', 310, 14, 110, 11, {0.5, 0.65, 0.8})
    UI.text(string.format('%03d', g.score), 310, 29, 110, 25, {0.4, 1, 0.8})
    UI.text('BEST', 470, 14, 130, 11, {0.5, 0.65, 0.8})
    UI.text(string.format('%03d', c.best), 470, 29, 130, 25, {1, 0.75, 0.3})
    UI.panel(ox - 2, oy - 2, g.width * size + 4, g.height * size + 4)
    love.graphics.setColor(0.16, 0.27, 0.4, 0.25)
    for x = 1, g.width - 1 do love.graphics.line(ox + x * size, oy, ox + x * size, oy + g.height * size) end
    for y = 1, g.height - 1 do love.graphics.line(ox, oy + y * size, ox + g.width * size, oy + y * size) end
    if g.food then UI.food(g.food, size, ox, oy, c.time or 0) end
    UI.snake(g.body, g.snake:getComponent('movement'), size, ox, oy, g.snake:getComponent('renderer').color)
    UI.text('ARROWS  /  steer', 24, 533, 250, 13, {0.5, 0.65, 0.8})
    UI.text('ESC  /  menu', 400, 533, 200, 13, {0.5, 0.65, 0.8}, 'right')
    if g.over then
        love.graphics.setColor(0.015, 0.02, 0.055, 0.75)
        love.graphics.rectangle('fill', ox, oy, g.width * size, g.height * size)
        local accent = g.won and {0.4, 1, 0.8} or {1, 0.35, 0.65}
        UI.panel(102, 180, 420, 232, accent)
        UI.text(g.won and 'YOU WIN' or 'GAME OVER', 102, 205, 420, 36, accent, 'center')
        UI.text('FINAL SCORE', 102, 267, 420, 12, {0.55, 0.65, 0.8}, 'center')
        UI.text(tostring(g.score), 102, 286, 420, 38, {0.9, 0.95, 1}, 'center')
        UI.text('ENTER / R  -  TRY AGAIN', 102, 349, 420, 17, {0.4, 1, 0.85}, 'center')
        UI.text('ESC  -  BACK TO MENU', 102, 381, 420, 12, {0.55, 0.65, 0.8}, 'center')
    end
    if c.notice then UI.text(c.notice, 24, 510, 576, 11, {1, 0.7, 0.4}) end
end
return SnakeGame
