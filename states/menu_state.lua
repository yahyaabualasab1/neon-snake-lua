local UI = require('ui')
local Menu = {}
function Menu:update() end
function Menu:draw(manager)
    UI.background()
    UI.text('A R C A D E   /   0 1', 0, 48, 624, 13, {0.45, 0.6, 0.8}, 'center')
    UI.text('NEON', 0, 90, 624, 60, {0.25, 0.95, 1}, 'center')
    UI.text('SNAKE', 0, 148, 624, 60, {0.8, 0.4, 1}, 'center')
    local body = {{x=5,y=1},{x=4,y=1},{x=3,y=1},{x=2,y=1},{x=2,y=2},{x=1,y=2},{x=0,y=2}}
    UI.snake(body, {dx=1,dy=0}, 24, 216, 214)
    UI.food({x=7,y=1}, 24, 216, 214, manager.context.time or 0)
    UI.panel(104, 320, 416, 66, {0.3, 1, 0.8})
    UI.text('PRESS ENTER TO PLAY', 104, 337, 416, 23, {0.4, 1, 0.85}, 'center')
    UI.text('or SPACE', 104, 365, 416, 12, {0.5, 0.65, 0.8}, 'center')
    UI.text('PERSONAL BEST   ' .. manager.context.best, 0, 416, 624, 18, {1, 0.75, 0.3}, 'center')
    UI.text('ARROWS  /  steer     +10  /  every apple', 0, 472, 624, 14, {0.6, 0.7, 0.85}, 'center')
    UI.text('Avoid the walls. Keep your own space.', 0, 498, 624, 14, {0.6, 0.7, 0.85}, 'center')
    UI.text('ESC  /  quit', 0, 543, 624, 12, {0.4, 0.5, 0.65}, 'center')
end
function Menu:keypressed(key, manager)
    if key == 'return' or key == 'space' then manager:switch('playing') end
    if key == 'escape' then love.event.quit() end
end
return Menu
