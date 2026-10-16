local Events = {listeners = {}}
Events.__index = Events
function Events:new() return setmetatable({listeners = {}}, self) end
function Events:subscribe(name, callback)
    assert(type(callback) == 'function')
    local list = self.listeners[name] or {}
    self.listeners[name] = list
    list[#list + 1] = callback
    local active = true
    return function()
        if not active then return end
        active = false
        for i, fn in ipairs(list) do
            if fn == callback then table.remove(list, i); break end
        end
    end
end
Events.on = Events.subscribe
function Events:emit(name, ...)
    -- Snapshot lets observers unsubscribe safely during dispatch.
    local snapshot = {}
    for i, fn in ipairs(self.listeners[name] or {}) do snapshot[i] = fn end
    for _, fn in ipairs(snapshot) do fn(...) end
end
return Events
