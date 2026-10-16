local SnakeGame = require('snake_game')
local Input = require('input')
local Playing = {}
function Playing:enter(manager)
    local context = manager.context
    context.game = SnakeGame:new()
    context.input = Input:new(context.game)
    context.notice = nil
    local function record(data)
        local score = data.score
        if score > context.best or (context.notice and score == context.best) then
            context.best = score
            local ok, err = context.highscore:save(score)
            context.notice = not ok and ('Could not save score: ' .. tostring(err)) or nil
        end
    end
    context.game.events:subscribe('food_eaten', record)
    context.game.events:subscribe('game_over', record)
end
function Playing:update(dt, manager) manager.context.game:update(dt) end
function Playing:keypressed(key, manager)
    local context = manager.context
    if key == 'escape' then manager:switch('menu')
    elseif context.game.over and (key == 'return' or key == 'r') then manager:switch('playing')
    else context.input:handleKey(key) end
end
function Playing:draw(manager)
    manager.context.game:draw(manager.context)
end
return Playing
