# Profiling Baseline

This document defines how to capture and evaluate baseline performance for Signal Chase.

## Capture Procedure

1. Open the Godot project from `engines/godot`.
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

## Reporting Format

Record each capture with:

- Date
- Device/OS
- Godot version
- Observed FPS range
- Largest frame-time spike
- Notes on perceived stutter and cause

## First Capture Status

Pending local engine run and profiler capture in Godot editor.
