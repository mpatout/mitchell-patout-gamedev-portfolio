# Debugging Case Studies

This file tracks reproducible debugging workflows for portfolio projects.

## Case 1: Signal Chase Pressure Spike Reproduction

### Goal

Verify that late-round pressure transitions are reproducible and inspect whether
powerup cadence remains within expected bounds.

### Reproduction Setup

1. Set deterministic seed before launch:
   - PowerShell: $env:SIGNAL_CHASE_SEED="424242"
2. Launch Godot project from engines/Godot.
3. Play one full round while capturing notable behavior.
4. After round end, inspect generated trace file:
   - user://signal_chase_latest_run.json

### Analysis Steps

1. Run trace summarizer:
   - ./engines/Godot/scripts/summarize-trace.ps1
2. Open generated report:
   - docs/portfolio/evidence/godot_trace_summary.md
3. Confirm:
   - level-up cadence is monotonic
   - hit events reduce pressure level as intended
   - max pressure remains in [0, 1]

### Outcome (Current)

- Deterministic trace capture confirmed.
- Pressure events and hit recovery events are present in telemetry.
- Runtime profiling capture is completed and indexed in docs/portfolio/PROFILING_EVIDENCE_INDEX.md.

### Follow-up

- Add profiler screenshot and frame-time metrics to correlate pressure spikes
  with rendering and script timing.

## Case 2: Spark Catch Deterministic Flow Verification

### Goal

Verify that Solar2D spawn and event progression can be reproduced for debugging
using a fixed RNG seed.

### Reproduction Setup

1. Set deterministic seed before launch:
   - PowerShell: $env:SPARK_CATCH_SEED="424242"
2. Launch Solar2D project from engines/solar2d.
3. Play one full round and exit.

### Analysis Steps

1. Run summary generator:
   - ./engines/solar2d/scripts/summarize-trace.ps1
2. Open generated report:
   - docs/portfolio/evidence/solar2d_trace_summary.md
3. Confirm run metadata includes seed, score, duration, and event totals.

### Outcome (Current)

- Deterministic trace capture is implemented in the runtime.
- Summary tooling is available for release/debug evidence.
- Profiling screenshot capture is completed and indexed in docs/portfolio/PROFILING_EVIDENCE_INDEX.md.
