# CHANGELOG — Defold: Pulse Grid

## [Unreleased] — 2026-05-22

### Added

- Lightweight audio stack with event SFX and looped ambience (`main/audio/*.wav`).
- Sound components wired to game object (`sfx_catch`, `sfx_hit`, `sfx_powerup`, `sfx_round_end`, `music_loop`).
- Audio mute toggle on `M` key.

## [0.2.0] — 2026-05-22

### Added

- Local top-5 leaderboard persistence in save payload.
- Offline-first pending score queue (`PENDING_QUEUE_LIMIT = 20`).
- Overlay leaderboard summary (top 3 shown) on title/game-over/time-up states.
- Optional remote sync hook via `http.request` + JSON payload.
- Remote sync status messaging in overlay UI.

### Changed

- Save payload evolved from `{ best }` to `{ best, leaderboard, pending_scores }`.
- Acceptance test expanded for leaderboard and offline sync fallback checks.
- Technical packet updated with queue and sync architecture notes.

## [0.1.0] — 2026-05-04

### Added

- Full Defold project scaffold (`game.project`, `input/`, `main/`).
- 4x4 GUI grid reaction gameplay with 60-second rounds.
- 10 difficulty levels: pulse interval and active window shrink per level.
- Combo multiplier scoring system (1-4x based on consecutive hits).
- Life system: 3 lives, game-over on depletion or time-up.
- `gui.animate` OUTQUAD easing on all cell colour transitions.
- `gui.pick_node` click/touch hit-testing for mobile-ready input.
- Persistent best score via `sys.save` / `sys.load`.
- Pause/resume state via Esc key.
- `on_message` handler demonstrating Defold message-passing API.
- Quality gate script (`scripts/quality-gate.ps1`).
- Release packaging script (`scripts/package-release.ps1`).
- Full documentation suite (README, PROJECT_SCOPE, TECHNICAL_PACKET,
  ACCEPTANCE_TEST, PROFILING_BASELINE, RELEASE_RUNBOOK, ASSET_PROVENANCE).
