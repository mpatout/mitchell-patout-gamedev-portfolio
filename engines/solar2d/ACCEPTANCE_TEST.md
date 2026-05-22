# ACCEPTANCE_TEST - Solar2D: Spark Catch

## Prerequisites

- Solar2D Simulator installed.
- Project opened from `engines/solar2d`.

## Section 1: Round Flow

| # | Test | Expected Result | Pass? |
| --- | --- | --- | --- |
| 1.1 | Launch project. | Title prompt appears with instructions. | |
| 1.2 | Tap title prompt. | Round starts, timer counts down, objects spawn. | |
| 1.3 | Let timer reach zero. | Round-over prompt appears with score and best score. | |
| 1.4 | Tap round-over prompt. | New round starts with reset score/lives/combo. | |

## Section 2: Input and State

| # | Test | Expected Result | Pass? |
| --- | --- | --- | --- |
| 2.1 | Drag catcher left/right. | Catcher follows touch smoothly within bounds. | |
| 2.2 | Press `P` during play. | Game pauses and prompt indicates paused state. | |
| 2.3 | Press `P` again. | Game resumes from paused state. | |

## Section 3: Gameplay Systems

| # | Test | Expected Result | Pass? |
| --- | --- | --- | --- |
| 3.1 | Catch 3 sparks in a row. | Score increases and combo increments. | |
| 3.2 | Catch an unstable shard. | Life decrements and combo resets. | |
| 3.3 | Catch overcharge token. | Overcharge timer activates and score multiplier increases. | |
| 3.4 | Miss a spark. | Life decrements by 1. | |

## Section 4: Persistence

| # | Test | Expected Result | Pass? |
| --- | --- | --- | --- |
| 4.1 | Finish round with score N. | Best score updates when N exceeds previous best. | |
| 4.2 | Restart simulator. | Best score persists across session restart. | |

## Section 5: Deterministic Trace

| # | Test | Expected Result | Pass? |
| --- | --- | --- | --- |
| 5.1 | Set `SPARK_CATCH_SEED` to a fixed integer and run one full round. | `spark_catch_latest_run.json` is written to DocumentsDirectory. | |
| 5.2 | Re-run with the same seed. | Early spawn/flow is reproducible for debugging. | |
| 5.3 | Inspect trace JSON. | Contains seed, duration, score, and non-empty `events` array. | |

## Exit Criteria

All tests above pass before marking release-ready.
