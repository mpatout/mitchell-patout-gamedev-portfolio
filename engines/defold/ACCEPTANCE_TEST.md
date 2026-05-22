# ACCEPTANCE_TEST - Defold: Pulse Grid

## Prerequisites

- Defold Editor 1.9.0+ installed.
- Project opened from `engines/defold` in Defold Editor.
- Build target: Local (desktop native runner).

---

## Section 1: Gameplay Loop

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 1.1 | Launch game. | Title overlay visible: "PULSE GRID" + instructions. No cells are active. | |
| 1.2 | Press **Enter** from title. | Overlay disappears. Round starts. Timer counts down from 60. | |
| 1.3 | Wait ~2 seconds. | At least one grid cell glows green. | |
| 1.4 | Click an active (green) cell. | Cell flashes white then returns to idle colour. Score increments. | |
| 1.5 | Let an active cell expire without clicking. | Cell flashes red then returns to idle. Lives decrements by 1. | |
| 1.6 | Play until timer reaches 0. | Time-up overlay appears with final score and best score. | |

## Section 2: State Machine / Input

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 2.1 | Press **Esc** during play. | Game pauses. Overlay shows "PAUSED". Cells freeze. | |
| 2.2 | Press **Esc** again while paused. | Game resumes exactly where it left off. | |
| 2.3 | Press **Enter** on game-over overlay. | New round starts; all HUD values reset. | |
| 2.4 | Click an idle (dark) cell during play. | No effect. Score unchanged. | |
| 2.5 | Click in empty area between cells. | No effect. | |

## Section 3: Scoring & Difficulty

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 3.1 | Hit 3 consecutive cells without missing. | Combo label shows "Combo x3". | |
| 3.2 | Miss a cell immediately after combo. | Combo resets to 0. Combo label clears. | |
| 3.3 | Score 8+ points. | Level label advances to 2. Cells spawn slightly faster. | |
| 3.4 | Score 72+ points. | Level label shows 10. Spawn and window near minimum values. | |

## Section 4: Persistence

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 4.1 | Achieve a score of N. Best score label updates. | Best label shows N. | |
| 4.2 | Close and reopen the game. | "Best:" label on title screen shows N. | |
| 4.3 | Achieve score < N in next round. | Best score label still shows N (not overwritten). | |

## Section 5: Leaderboard & Offline Sync Fallback

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 5.1 | Finish a round with score S1, then another with score S2 (S2 > S1). | Overlay shows top scores with S2 listed above S1. | |
| 5.2 | Restart app after two scored rounds. | Overlay still shows previously stored top scores. | |
| 5.3 | Play with default config (`ENABLE_REMOTE_SYNC = false`). | Overlay shows local mode/offline queue status; no crash or request failure. | |
| 5.4 | Inspect save payload via `sys.load` during debug. | Save table contains keys: `best`, `leaderboard`, `pending_scores`. | |

## Section 6: Stability

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 6.1 | Deliberately miss all cells for a full round (3 lives). | Game-over triggers cleanly; no crash or freeze. | |
| 6.2 | Click rapidly across the whole grid. | No crash; only active cells register hits. | |
| 6.3 | Restart 5 times in succession. | Each round starts cleanly; no state bleed from previous round. | |

---

## Submission Exit Criteria

All tests in Sections 1-6 must pass before marking v0.2.0 as submission-ready.
