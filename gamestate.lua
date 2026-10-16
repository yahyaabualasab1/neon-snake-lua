local GameState = {}
GameState.__index = GameState
function GameState:new(context, states)
    if not context then
        local highscore = require('highscore'):new('highscore.txt', love and love.filesystem)
        context = {highscore = highscore, best = highscore:load()}
    end
    local manager = setmetatable({context = context, states = states or {
        menu = require('states.menu_state'), playing = require('states.game_state')
    }}, self)
    manager:switch('menu')
    return manager
end
function GameState:switch(name)
    assert(self.states[name], 'Unknown state: ' .. tostring(name))
    local previous = self.states[self.current]
    if previous and previous.leave then previous:leave(self) end
    self.current = name
    local state = self.states[name]
    if state.enter then state:enter(self) end
end
function GameState:update(dt) self.states[self.current]:update(dt, self) end
function GameState:draw() self.states[self.current]:draw(self) end
function GameState:keypressed(key)
    local state = self.states[self.current]
    if state.keypressed then state:keypressed(key, self) end
end
return GameState
