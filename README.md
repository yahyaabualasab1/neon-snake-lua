# Neon Snake — Lua Game Programming Assignment

## Run
Install LÖVE 11.5, open a terminal in this folder, and run `love .`.
On this Windows PC:
`& "D:\Codex\LOVE\love-11.5-win64\love.exe" "D:\Codex\SnakeGame-Submission"`
The game requires LÖVE; plain `lua main.lua` does not provide its graphics APIs.

Enter / Space starts. Arrow keys steer. Each apple gives 10 points and grows
the snake. Wall or self collision ends the game. Enter / R restarts; Escape
returns to the menu, then quits. A full board wins.

## Assignment structure
`main.lua`: entry point and LÖVE callbacks.
`gamestate.lua`: menu / playing manager with switch, update and draw.
`entity.lua`: position, movement and renderer components.
`vector2.lua`: __add, __eq and __tostring; used by movement and collisions.
`highscore.lua`: file save/load and Lua 5.4 resource management.
`input.lua`: command pattern with bind and handleKey.
`events.lua`: observer bonus with subscribe and emit.
`snake_game.lua`: update, draw and changeDirection; game mechanics.
`states/menu_state.lua`, `states/game_state.lua`: the two states.
`conf.lua`: window settings. `ui.lua`: shared neon drawing helpers.

## Lua 5.4 feature and LÖVE compatibility
Lua 5.4 automatically closes a local file declared with `<close>` when its
scope ends, including during an error. A comment in highscore.lua explains it.
That same file contains the actual `<close>` save/load implementation inside
a string compiled by `load` only when `_VERSION == 'Lua 5.4'`.
This lets Lua 5.4 execute the feature while LuaJIT can still parse the module.
There is no separate Lua 5.4 source folder required for this delivery.
LÖVE uses love.filesystem for persistence; other Lua 5.1-compatible execution
uses explicitly closed io files. LÖVE saves highscore.txt in its application
save directory (identity: lua-snake-assignment), not the source folder.

## Verification
19 logic and integration tests passed under Lua 5.1, Lua 5.4 and LÖVE LuaJIT.
Lua 5.4 tests verified the root highscore.lua closes files after save/load and
on write errors. Callback tests passed. Menu, playing and game-over screens
were rendered with real LÖVE graphics and visually inspected.
Development tests and editor configuration are kept outside this delivery.

## GitHub

Repository: [https://github.com/yahyaabualasab1/neon-snake-lua](https://github.com/yahyaabualasab1/neon-snake-lua)
