# Competency Matrix

Use this matrix to track which project proves which hiring signal.

| Engine | Project | Gameplay Systems | Architecture | Debugging | Performance | Delivery |
| --- | --- | --- | --- | --- | --- | --- |
| Godot | Signal Chase | `engines/Godot/scripts/main.gd` (state loop, collisions, scaling) | `engines/Godot/TECHNICAL_PACKET.md` (architecture and decisions) | `engines/Godot/TECHNICAL_PACKET.md` (debugging notes) + `engines/Godot/ACCEPTANCE_TEST.md` | `engines/Godot/PROFILING_BASELINE.md` | `engines/Godot/RELEASE_RUNBOOK.md` + `engines/Godot/scripts/package-release.ps1` |
| Defold | Pulse Grid | `engines/defold/main/game.gui_script` (grid state, scoring, progression) | `engines/defold/TECHNICAL_PACKET.md` (architecture and tradeoffs) | `engines/defold/TECHNICAL_PACKET.md` (debugging notes) + `engines/defold/ACCEPTANCE_TEST.md` | `engines/defold/PROFILING_BASELINE.md` | `engines/defold/RELEASE_RUNBOOK.md` + `engines/defold/scripts/package-release.ps1` |
| Solar2D | Spark Catch | `engines/solar2d/main.lua` (spawn budget, overcharge window, collision loop) | `engines/solar2d/TECHNICAL_PACKET.md` (system layout and decisions) | `engines/solar2d/TECHNICAL_PACKET.md` (debugging notes) + `engines/solar2d/ACCEPTANCE_TEST.md` | `engines/solar2d/PROFILING_BASELINE.md` | `engines/solar2d/RELEASE_RUNBOOK.md` + `engines/solar2d/scripts/package-release.ps1` |
| Panda3D | TBD | Planned | Planned | Planned | Planned | Planned |
| Stride | TBD | Planned | Planned | Planned | Planned | Planned |

## Usage

- Replace `TBD` with final demo names.
- Replace `Planned` with concise evidence links once artifacts exist.
- Keep one row per engine in v1.
