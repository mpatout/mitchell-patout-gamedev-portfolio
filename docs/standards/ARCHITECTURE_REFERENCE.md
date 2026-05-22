# Architecture Reference

This document gives a fast architecture snapshot for each implemented engine slice.

## Godot: Signal Chase

```text
Input -> GameState FSM -> Movement/Threat Update -> Collision Checks -> HUD/Draw
                    |                         |
                    +-> Save/Best Score       +-> Replay Trace Events
```

### Notes

- Single-script simulation with explicit state transitions.
- Threats are array-based for predictable update order.
- Deterministic seed mode and replay trace output support reproducible debugging.

## Defold: Pulse Grid

```text
Input Binding -> GUI Script Controller -> Cell Activation Loop -> Score/Lives HUD
                                  |
                                  +-> Persistence (sys.save/sys.load)
```

### Notes

- Pure GUI architecture with one controlling `game.gui_script`.
- `gui.animate` drives visual transitions without external assets.
- Message handler supports extension to multi-object orchestration.

## Solar2D: Spark Catch

```text
Touch/Key Input -> Round State Loop -> Spawn Budget -> Drop Update/Collision -> HUD
                               |
                               +-> Save File + Release/Test Tooling
```

### Notes

- Delta-time `enterFrame` loop with explicit state gate.
- Mobile-first drag control and risk/reward overcharge system.
- Lightweight object lifecycle and deterministic bounds management.

## Cross-Engine Pattern Comparison

| Concern | Godot | Defold | Solar2D |
| --- | --- | --- | --- |
| State management | Enum-based FSM in script | Explicit state flags in GUI script | String state gate in main loop |
| Rendering style | Primitive draw calls in `_draw` | GUI node colors/animation | Runtime display primitives |
| Persistence | JSON file in `user://` | `sys.save`/`sys.load` | JSON file in documents directory |
| Difficulty scaling | Score-driven level + threats | Score-driven pulse/window shrink | Score-driven spawn interval/speed |
| Reproducibility | Seed + trace export | Deterministic ruleset docs | Deterministic loop docs |
