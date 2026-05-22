# TECHNICAL_PACKET — Defold: Pulse Grid

## Architecture

```
engines/defold/
├── game.project              Defold project config (bootstrap, display, input)
├── input/
│   └── game.input_binding    Key + mouse + TOUCH_MULTI bindings
└── main/
    ├── main.collection       Root bootstrap collection
    ├── game.go               Game object prototype (owns GUI component)
    ├── game.gui              GUI layout: 16 cell box nodes + HUD text nodes
    └── game.gui_script       All game logic in Lua (~330 LOC)
```

### Why a Single GUI Script?

Defold supports two common architectures:

1. **Factory / game object pattern** - a controller script spawns `factory.create`
   instances (cell game objects), each with its own `.script` component. Objects
   communicate via `go.post` / `msg.url`. Ideal for games with many independently
   animated sprites.

2. **Pure GUI pattern** - all nodes defined in a `.gui` file and manipulated by a
   single `gui_script`. No factory, no collision objects. Natural for tile/grid
   games where all cells share the same update logic and there are no physics
   requirements.

Pulse Grid uses pattern 2 because: the grid is static topology (position never
changes), rendering is colour-only (no sprite atlas required), and keeping all
state in one script avoids inter-object message latency. For a larger game the
factory pattern would be preferred; the `on_message` handler in `game.gui_script`
demonstrates the message-passing API that would be used there.

## Key Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Cell rendering | GUI TYPE_BOX nodes | No texture asset required; colour via `gui.set_color` |
| Animation | `gui.animate` OUTQUAD | Built-in easing; non-blocking; cancellable |
| Input | `gui.pick_node` | Correct for GUI-space coordinates; works for touch |
| Persistence | `sys.save` / `sys.load` | Defold-idiomatic; stores best, top-5 leaderboard, pending sync queue |
| Leaderboard model | Offline-first queue + optional HTTP sync | No backend required for local mode; remote path can be enabled later |
| Difficulty curve | Linear per-level deduction capped at min | Predictable feel; easily tunable |
| Combo scoring | pts = 1 + min(floor(combo/3), 3) | Low floor, meaningful ceiling; not punishing |

## Defold-Specific Patterns Demonstrated

### Message Passing
```lua
-- External restart (collection proxy use case)
function on_message(self, message_id, message, sender)
  if message_id == hash("restart") then start_round() end
end
-- Caller side would use:
-- msg.post("/game#gui", "restart")
```

### GUI Animation Pipeline
```lua
-- Cancel any in-flight animation, then start a new one
gui.cancel_animation(cell_node(idx), gui.PROP_COLOR)
gui.set_color(cell_node(idx), C_MISS)
gui.animate(cell_node(idx), gui.PROP_COLOR, C_IDLE,
  gui.EASING_OUTQUAD, 0.40, 0)
```

### sys.save / sys.load Pattern
```lua
local function save_best()
  sys.save(sys.get_save_file("pulsegrid", "save.json"),
           {
             best = best_score,
             leaderboard = leaderboard,
             pending_scores = pending_scores,
           })
end
local function load_best()
  local data = sys.load(sys.get_save_file("pulsegrid", "save.json"))
  best_score = (data and data.best) and data.best or 0
  leaderboard = sanitize_scores(data and data.leaderboard or {}, 5)
  pending_scores = sanitize_queue(data and data.pending_scores or {})
end
```

### Optional Remote Sync Hook
```lua
-- Disabled by default: keeps portfolio artifact fully local and deterministic.
local ENABLE_REMOTE_SYNC = false
local REMOTE_SYNC_URL = ""

if ENABLE_REMOTE_SYNC and REMOTE_SYNC_URL ~= "" and #pending_scores > 0 then
  http.request(REMOTE_SYNC_URL, "POST", on_sync_response,
    { ["Content-Type"] = "application/json" },
    json.encode({ app = "pulsegrid", scores = pending_scores }))
end
```

## Balance Notes

- `LEVEL_THRESHOLD = 8`: level-up every 8 points -> level 10 at score 72.
- At level 10: `pulse_interval ~0.39 s`, `active_window ~0.90 s`.
- Up to 4 cells can be active simultaneously at high levels.
- A 60-second round with 0 misses and max combo yields ~120 points.

## Debugging Notes

- If cells never appear: check `game.project` bootstrap path and build target.
- If `gui.pick_node` never fires: confirm `msg.post(".", "acquire_input_focus")`
  is called in `init` and that the input binding action IDs match.
- `gui.cancel_animation` before `gui.animate` prevents colour flickering on
  rapid hit/miss sequences.
- Queue truncation (`PENDING_QUEUE_LIMIT = 20`) caps offline growth and keeps
  save payloads bounded across long sessions.

## Performance Notes

- GUI node count: 25 (16 cells + 9 HUD). Well within Defold's `max_nodes: 512`.
- `update` runs at display refresh (60 Hz by default); the linear pass over
  `active_cells` (max 16 entries) is O(16) - negligible.
- `gui.animate` callbacks are engine-managed; no per-frame Lua cost after fire.

## Known Limitations

- No audio. Defold sound sources require `.wav`/`.ogg` assets.
- No export preset automation. HTML5/mobile export requires Defold Editor.
- `sys.get_save_file` on HTML5 resolves to emscripten FS; data persists only
  within browser origin.
