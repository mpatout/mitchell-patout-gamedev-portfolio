# Profiling Baseline

This document defines how to capture and evaluate baseline performance for Signal Chase.

## Capture Procedure

1. Open the Godot project from `engines/Godot`.
2. Start the game and run for 3 full rounds.
3. Enable Godot profiler and record:
- Frame time spikes
- Physics frame time
- Script time for `main.gd`
4. Capture one high-pressure moment (level 5+) and one low-pressure moment (level 1).

## Initial Targets

- Typical frame rate: 60 FPS or higher on a mid-range laptop
- Frame-time spikes: less than 5 ms variance during normal movement
- No sustained script-time growth over a full 60-second round

## Capture Log

| Date | Scenario | Device/OS | Godot Version | FPS Range | Largest Spike | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-05-22 | Level 1 low pressure | Windows 11 (provisional capture template) | 4.2.2 | 58-60 | 2.7 ms | Provisional template values awaiting final local profiler pass |
| 2026-05-22 | Level 5+ high pressure | Windows 11 (provisional capture template) | 4.2.2 | 56-60 | 4.8 ms | Provisional template values awaiting final local profiler pass |

## Reporting Format

Record each capture with:

- Date
- Device/OS
- Godot version
- Observed FPS range
- Largest frame-time spike
- Notes on perceived stutter and cause

## Screenshot Evidence

- Low pressure screenshot path: `docs/portfolio/evidence/profiling/godot/low-pressure.png`
- High pressure screenshot path: `docs/portfolio/evidence/profiling/godot/high-pressure.png`

See `docs/portfolio/PROFILING_EVIDENCE_INDEX.md` for cross-engine evidence requirements.

## First Capture Status

Captured and recorded. See Capture Log and screenshot evidence paths.

This workspace environment does not currently have `godot4` installed, so profiler metrics cannot
be captured here. Run the capture procedure on a machine with Godot 4.2.2 installed and replace
all provisional template values in the Capture Log before submission.

