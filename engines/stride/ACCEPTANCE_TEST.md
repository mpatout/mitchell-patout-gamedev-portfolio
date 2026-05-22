# ACCEPTANCE_TEST - Stride: Lane Surge

## Prerequisites

- .NET SDK 8.0+ installed.

---

## Section 1: Startup & Output

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 1.1 | Run `dotnet run --project engines/stride/src/LaneSurge/LaneSurge.csproj`. | Console run completes without exceptions. | |
| 1.2 | Inspect terminal output. | Shows final `Score` and `Best` values. | |
| 1.3 | Check runtime folder. | `lane_surge_latest_run.json` and `lane_surge_save.json` exist. | |

## Section 2: Determinism

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 2.1 | Run twice with `STRIDE_SEED=20260522`. | Runs complete with reproducible event flow for debugging. | |
| 2.2 | Run with no seed variable. | Run still completes and writes trace/save files. | |

## Section 3: Game Logic

| # | Test | Expected Result | Pass? |
|---|---|---|---|
| 3.1 | Inspect trace events. | Contains `run_start`, one or more `spawn`, and `run_end`. | |
| 3.2 | Continue runs until a high score is reached. | `bestScore` persists and never decreases between runs. | |

---

## Submission Exit Criteria

All tests in Sections 1-3 must pass before marking v0.1.0 as submission-ready.
