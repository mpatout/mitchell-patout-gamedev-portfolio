# Solar2D Spark Catch v0.2.1

## Scope Summary

Deterministic debugging and telemetry instrumentation update for Spark Catch.

## Key Technical Updates

- Added deterministic run support via `SPARK_CATCH_SEED`.
- Added run trace export (`spark_catch_latest_run.json`) with event stream.
- Added telemetry events for catches, misses, level transitions, pause, and round end.
- Added trace summary helper script: `engines/solar2d/scripts/summarize-trace.ps1`.
- Updated acceptance tests and technical packet for reproducible-debug workflow.

## Performance Notes

- Gameplay update is logic instrumentation only; object counts and draw approach are unchanged.
- Runtime profiling capture is complete; see docs/portfolio/PROFILING_EVIDENCE_INDEX.md.

## Known Issues

- Audio is not implemented.
- Native mobile export/signing is not automated in repository scripts.
- Trace is event-sampled and not per-frame full-state replay.
