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
| Pending | Level 1 low pressure | Pending | Pending | Pending | Pending | Capture not yet recorded |
| Pending | Level 5+ high pressure | Pending | Pending | Pending | Pending | Capture not yet recorded |

## Reporting Format

Record each capture with:

- Date
- Device/OS
- Godot version
- Observed FPS range
- Largest frame-time spike
- Notes on perceived stutter and cause

## First Capture Status

Pending local Godot editor run.

This workspace environment does not currently have `godot4` installed, so profiler metrics cannot
be captured here. Run the capture procedure on a machine with Godot 4.2.2 installed and replace
all `Pending` values in the Capture Log before submission.
