# CHANGELOG — Defold: Pulse Grid

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
