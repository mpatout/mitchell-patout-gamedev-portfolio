# Pulse Grid - Defold

## Overview

Pulse Grid is a 4x4 reaction arcade game built with **Defold 1.9+** and Lua.
Cells light up at random. Click (or tap) each cell before its activation window
closes. Miss too many and you lose lives; string hits together for combo
multipliers. Speed scales with score across 10 difficulty levels.

Showcases: Defold GUI system, `gui.animate` easing pipeline, `gui.pick_node`
hit-testing, `sys.save`/`sys.load` persistence, optional HTTP sync hooks, and
Lua closure patterns.

## Minimum Version

Defold **1.9.0** (tested on 1.9.4).

## Quickstart

1. [Download Defold](https://defold.com/download/) (free, no licence required).
2. Open Defold Editor -> **File -> Open Project** -> select `engines/defold`.
3. Press **F5** (or **Project -> Build**) to run.
4. The game starts in the browser preview or native runner depending on target.

## Controls

| Key / Action | Effect |
|---|---|
| **Click / Tap** active cell | Score a hit |
| **Enter** | Start round / restart after game-over |
| **Esc** | Pause / resume |
| **M** | Toggle audio mute |

## Core Systems

- 4x4 grid rendered as colored GUI box nodes.
- Cells spawn on a decaying interval (`BASE_PULSE_INTERVAL` -> `MIN_PULSE_INTERVAL`).
- Active window shrinks with level (`BASE_ACTIVE_WINDOW` -> `MIN_ACTIVE_WINDOW`).
- Combo multiplier: 1 pt base + 1 pt per 3 consecutive hits, capped at 4x.
- Persistent best score plus local top-5 leaderboard via `sys.save` / `sys.load`.
- Offline-first score queue (up to 20 pending scores) for future remote sync.
- `gui.animate` easing used for hit flash, miss flash, and cell activation glow.

## Technical Highlights

- **Pure GUI architecture**: entire game in a single `.gui` + `.gui_script`;
  no sprites or physics components, zero external asset dependencies.
- **Mobile-ready input**: `TOUCH_MULTI` binding handled identically to mouse,
  enabling HTML5 / mobile builds without code changes.
- **Easing pipeline**: `gui.EASING_OUTQUAD` on all colour transitions;
  `gui.cancel_animation` called defensively before state transitions.
- **Defold message API**: `on_message` handler for external `restart` message;
  demonstrates inter-object communication pattern via `msg.post`.
- **Offline-first leaderboard sync**: score submissions are written locally first;
  optional `http.request` sync can flush queued scores when an endpoint is set.

## Performance Snapshot

See [PROFILING_BASELINE.md](PROFILING_BASELINE.md).

## Release Operations

- Packaging script: `engines/defold/scripts/package-release.ps1`
- Quality gate: `engines/defold/scripts/quality-gate.ps1`
- Full runbook: [RELEASE_RUNBOOK.md](RELEASE_RUNBOOK.md)

## Known Limitations

- HTML5 build requires Defold Editor to export; not scripted here.
- Save path (`sys.get_save_file`) is platform-resolved; works on desktop and
  mobile, varies on HTML5 (browser local storage via emscripten).
- Remote leaderboard endpoint is intentionally unset (`REMOTE_SYNC_URL = ""`);
  project runs in local leaderboard mode by default.
