# PROJECT_SCOPE — Defold: Pulse Grid

## Current Slice

**v0.1.0** — Production slice 1: playable reaction game, full GUI, persistence.

## In Scope

- 4×4 grid reaction gameplay (click active cells before window expires).
- 10 difficulty levels driven by score threshold.
- Combo multiplier scoring (1–4×).
- Life system: 3 lives, game-over on depletion.
- 60-second round timer → time-up game-over.
- Persistent best score via `sys.save` / `sys.load`.
- Pause / resume via Esc key.
- Title and game-over overlay state machine.
- Mouse and multi-touch input.
- `gui.animate` colour easing on hit, miss, and activation.
- Quality gate + packaging scripts.
- Acceptance test suite.

## Out of Scope (v0.1.0)

- Audio (no sound components).
- Sprite/atlas assets (all rendering via GUI box nodes).
- Networked leaderboard.
- HTML5 or mobile export preset automation.
- Collection proxy / scene streaming.

## Exit Criteria

- [ ] Game loop runs from title → playing → game-over → restart without crash.
- [ ] Score, combo, lives, level, timer all update correctly each round.
- [ ] Best score persists across application restarts.
- [ ] Pause/resume preserves full game state.
- [ ] Quality gate passes.
- [ ] Source package artifact created.
- Technical packet with profiling notes

## Out of Scope

- Non-essential feature creep
- Untracked third-party assets
