# ACCEPTANCE_TEST - Panda3D: Lane Drift

## Prerequisites

- Python 3.10+ available.
- Dependencies installed with `pip install -r engines/panda3d/requirements.txt`.

---

## Section 1: Startup & Controls

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 1.1 | Run `python engines/panda3d/main.py`. | Window opens with player, lane markers, and HUD text. | |
| 1.2 | Press Left/A. | Player shifts exactly one lane left (if lane exists). | |
| 1.3 | Press Right/D. | Player shifts exactly one lane right (if lane exists). | |
| 1.4 | Press Esc. | Application exits cleanly. | |

## Section 2: Core Gameplay Loop

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 2.1 | Stay alive for at least 10 seconds. | Score increments over time and obstacles spawn continuously. | |
| 2.2 | Observe 30+ seconds of play. | Obstacle speed/spawn intensity increases from initial values. | |
| 2.3 | Collide with an obstacle. | State changes to game-over and restart prompt appears. | |
| 2.4 | Press R on game-over. | Round restarts and score resets to 0. | |

## Section 3: Persistence & Determinism

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 3.1 | Achieve a score N, then end run. | HUD best score updates to N. | |
| 3.2 | Relaunch app. | Best score remains N from save file. | |
| 3.3 | Run with `PANDA3D_SEED=20260522` twice. | Spawn pattern and event flow are reproducible enough for debug comparison. | |
| 3.4 | Complete any run. | `engines/panda3d/runtime/lane_drift_latest_run.json` is written. | |

---

## Submission Exit Criteria

All tests in Sections 1-3 must pass before marking v0.1.0 as submission-ready.
