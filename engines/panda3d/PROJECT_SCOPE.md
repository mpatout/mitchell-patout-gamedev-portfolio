# PROJECT_SCOPE - Panda3D: Lane Drift

## Goal

Deliver a reproducible Panda3D vertical slice demonstrating a complete gameplay
loop, deterministic debug runs, and portfolio-grade documentation/release
operations.

## In Scope

- Keyboard-controlled player movement across 5 lanes.
- Obstacle spawn/movement loop with increasing difficulty.
- Score tracking, best-score persistence, and game-over/restart flow.
- Deterministic seeded runs using `PANDA3D_SEED`.
- Lightweight JSON run trace export for debugging.
- Baseline acceptance test, profiling template, release runbook, and packaging scripts.

## Out of Scope

- Audio implementation and content pipeline.
- Advanced art/animation pipeline.
- Networked leaderboard integration.
- Mobile export automation.
