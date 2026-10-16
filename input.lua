local Input = {}
Input.__index = Input
local function turn(dx, dy)
    return function(game) return game:changeDirection(dx, dy) end
end
function Input:new(game)
    local input = setmetatable({game = game, commands = {}}, self)
    input:bind('up', turn(0, -1))
    input:bind('down', turn(0, 1))
    input:bind('left', turn(-1, 0))
    input:bind('right', turn(1, 0))
    return input
end
function Input:bind(key, command)
    assert(type(key) == 'string' and type(command) == 'function', 'Invalid command')
    self.commands[key] = command
end
function Input:handleKey(key, game)
    local command = self.commands[key]
    if command then return command(game or self.game) end
    return false
end
-- Compatibility with the earlier development tests.
Input.handle = Input.handleKey
return Input
