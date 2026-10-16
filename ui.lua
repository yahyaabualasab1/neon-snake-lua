local UI, fonts = {}, {}
function UI.text(text, x, y, width, size, color, align)
    fonts[size] = fonts[size] or love.graphics.newFont(size)
    love.graphics.setFont(fonts[size])
    love.graphics.setColor(color or {0.88, 0.94, 1})
    love.graphics.printf(text, x, y, width, align or 'left')
end
function UI.background()
    love.graphics.clear(0.025, 0.035, 0.075)
    for i = 7, 1, -1 do
        love.graphics.setColor(0.2, 0.1, 0.6, 0.014)
        love.graphics.circle('fill', 580, 70, i * 50)
        love.graphics.setColor(0, 0.65, 0.75, 0.011)
        love.graphics.circle('fill', 30, 530, i * 45)
    end
end
function UI.panel(x, y, w, h, color)
    color = color or {0.2, 0.9, 1}
    for i = 4, 1, -1 do
        love.graphics.setColor(color[1], color[2], color[3], 0.025)
        love.graphics.rectangle('fill', x - i * 2, y - i * 2, w + i * 4, h + i * 4, 14, 14)
    end
    love.graphics.setColor(0.045, 0.06, 0.115, 0.98)
    love.graphics.rectangle('fill', x, y, w, h, 10, 10)
    love.graphics.setColor(color[1], color[2], color[3], 0.45)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', x, y, w, h, 10, 10)
end
function UI.snake(body, movement, size, ox, oy, color)
    color = color or {0.12, 0.95, 0.76}
    local function center(p) return ox + (p.x + 0.5) * size, oy + (p.y + 0.5) * size end
    for layer = 3, 0, -1 do
        for i = #body, 1, -1 do
            local x, y = center(body[i])
            local t = (i - 1) / math.max(#body - 1, 1)
            love.graphics.setColor(color[1] + t * 0.25, color[2] - t * 0.45, color[3] + t * 0.24, layer == 0 and 1 or 0.07)
            local radius = size * 0.39 + layer * 2
            if i < #body then
                local nx, ny = center(body[i + 1])
                love.graphics.setLineWidth(radius * 2)
                love.graphics.line(x, y, nx, ny)
            end
            love.graphics.circle('fill', x, y, radius)
        end
    end
    local x, y = center(body[1])
    local dx, dy = movement.dx, movement.dy
    for _, side in ipairs({-1, 1}) do
        local ex, ey = x + dx * 4 - dy * side * 4.8, y + dy * 4 + dx * side * 4.8
        love.graphics.setColor(0.95, 1, 1)
        love.graphics.circle('fill', ex, ey, 3.4)
        love.graphics.setColor(0.025, 0.04, 0.10)
        love.graphics.circle('fill', ex + dx, ey + dy, 1.8)
    end
    love.graphics.setLineWidth(1)
end
function UI.food(p, size, ox, oy, time)
    local x, y = ox + (p.x + 0.5) * size, oy + (p.y + 0.5) * size
    local pulse = 1 + math.sin(time * 5) * 0.08
    for i = 4, 1, -1 do
        love.graphics.setColor(1, 0.15, 0.5, 0.04)
        love.graphics.circle('fill', x, y, (8 + i * 3) * pulse)
    end
    love.graphics.setColor(1, 0.2, 0.48)
    love.graphics.circle('fill', x - 3, y + 1, 6 * pulse)
    love.graphics.circle('fill', x + 3, y + 1, 6 * pulse)
    love.graphics.setColor(0.4, 1, 0.65)
    love.graphics.ellipse('fill', x + 3, y - 7, 4, 2)
    love.graphics.setColor(1, 0.85, 0.94)
    love.graphics.circle('fill', x - 4, y - 1, 1.8)
end
return UI
