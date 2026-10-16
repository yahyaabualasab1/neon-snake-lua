local Vector2 = {}
Vector2.__index = Vector2
function Vector2:new(x, y) return setmetatable({x = x or 0, y = y or 0}, self) end
function Vector2.__add(a, b) return Vector2:new(a.x + b.x, a.y + b.y) end
function Vector2.__eq(a, b) return a.x == b.x and a.y == b.y end
function Vector2.__tostring(v) return string.format('(%s, %s)', v.x, v.y) end
return Vector2
