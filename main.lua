local GameState = require('gamestate')
local HighScore = require('highscore')
local manager
function love.load()
    love.math.setRandomSeed(os.time())
    math.randomseed(os.time())
    love.graphics.setNewFont(20)
    love.graphics.setBackgroundColor(0.04, 0.07, 0.11)
    local highscore = HighScore:new('highscore.txt', love.filesystem)
    manager = GameState:new({highscore = highscore, best = highscore:load()})
end
function love.update(dt)
    manager.context.time = (manager.context.time or 0) + dt
    manager:update(dt)
end
function love.draw() manager:draw() end
function love.keypressed(key, _, isrepeat)
    if not isrepeat then manager:keypressed(key) end
end
