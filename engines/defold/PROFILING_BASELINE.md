# PROFILING_BASELINE \u2014 Defold: Pulse Grid

## Capture Procedure

1. Open the project in Defold Editor from `engines/defold`.
2. Enable the built-in profiler: **Debug \u2192 Toggle Profile**.
3. Run a full 60-second round, reaching at least level 4 (score 24+).
4. Note the frame time and script self-time values from the profiler overlay.
5. Record two captures: **Low Pressure** (first 10 s, 1-2 active cells) and
   **High Pressure** (level 6+, 3-4 active cells simultaneously).

## Capture Log

| Capture | Scene conditions | Frame time (ms) | Script self-time (ms) | Active nodes | Notes |
|---|---|---|---|---|---|
| Low pressure  | Level 1, 1 active cell  | Pending | Pending | 25 | Capture manually |
| High pressure | Level 6+, 3-4 active cells | Pending | Pending | 25 | Capture manually |

> **Note:** Defold Editor must be installed locally to run the profiler.
> Fill in the Pending values before submission.

## Expected Targets

- Frame time: < 4 ms at 60 Hz (headroom for mobile).
- Script self-time: < 0.5 ms (O(16) loop + 25 GUI nodes is trivial).
- No GC spikes from table allocation in hot path (active_cells is a fixed map).

## Screenshot Evidence

- Low pressure screenshot path: `docs/portfolio/evidence/profiling/defold/low-pressure.png`
- High pressure screenshot path: `docs/portfolio/evidence/profiling/defold/high-pressure.png`

See `docs/portfolio/PROFILING_EVIDENCE_INDEX.md` for cross-engine evidence requirements.
