local HighScore = {path = 'highscore.txt'}
HighScore.__index = HighScore
local modern
if _VERSION == 'Lua 5.4' then
    -- Modern Lua feature: <close> closes a file at scope exit, even on error.
    -- A separate compiled chunk keeps this syntax out of LuaJIT's parser.
    -- Lua 5.4 executes these real to-be-closed declarations; LÖVE uses its
    -- filesystem API (or the explicitly closed fallback below).
    modern = assert(load([=[
        return {
            save = function(path, content)
                local file <close>, err = io.open(path, 'w')
                if not file then return nil, err end
                local result, writeError = file:write(content)
                if not result then return nil, writeError end
                return file:flush()
            end,
            load = function(path)
                local file <close> = io.open(path, 'r')
                if not file then return nil end
                return file:read('*a')
            end
        }
    ]=], '@highscore.lua:lua54'))()
end
HighScore.backend = modern and 'Lua 5.4 <close>' or 'LuaJIT/Lua 5.1 compatible'
local function valid(value)
    local n = tonumber(value)
    if not n or n ~= n or n == math.huge or n < 0 then return 0 end
    return math.floor(n)
end
function HighScore:new(path, storage)
    return setmetatable({path = path or 'highscore.txt', storage = storage}, self)
end
function HighScore:load()
    if self.storage then return valid(self.storage.read(self.path)) end
    if modern then return valid(modern.load(self.path)) end
    local file = io.open(self.path, 'r')
    if not file then return 0 end
    local ok, content = pcall(file.read, file, '*a')
    file:close()
    return ok and valid(content) or 0
end
function HighScore:save(score)
    local content = tostring(valid(score))
    if self.storage then return self.storage.write(self.path, content) end
    if modern then return modern.save(self.path, content) end
    local file, err = io.open(self.path, 'w')
    if not file then return nil, err end
    -- LuaJIT-compatible resource management: close even when write raises.
    local ok, result, writeError = pcall(file.write, file, content)
    local closed, closeError = file:close()
    if not ok then return nil, result end
    if not result then return nil, writeError end
    if not closed then return nil, closeError end
    return true
end
return HighScore
