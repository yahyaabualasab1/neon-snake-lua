function love.conf(t)
    t.identity = 'lua-snake-assignment'
    t.version = '11.5'
    t.window.title = 'Snake | Lua Assignment'
    t.window.width, t.window.height = 624, 576
    t.window.resizable = false
    t.modules.audio = false
    t.modules.physics = false
end
