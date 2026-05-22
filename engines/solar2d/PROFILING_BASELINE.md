# PROFILING_BASELINE - Solar2D: Spark Catch

## Capture Procedure

1. Open `engines/solar2d` in Solar2D Simulator.
2. Start a round and play through at least 60 seconds.
3. Record two windows:
   - Low pressure: first 10 seconds.
   - High pressure: level 6+ or active overcharge window.
4. Capture FPS and memory readings from Simulator metrics view.
5. Attach one screenshot per capture and fill the log table.

## Capture Log

| Capture | Conditions | FPS | Lua memory (KB) | Active objects | Notes |
| --- | --- | --- | --- | --- | --- |
| Low pressure | Level 1, no overcharge | Pending | Pending | Pending | Capture manually |
| High pressure | Level 6+, overcharge active | Pending | Pending | Pending | Capture manually |

## Expected Targets

- FPS should remain near 60 on desktop simulator.
- Lua memory should remain stable with no unbounded growth.
- Active object count should stay below 30 in normal play.
