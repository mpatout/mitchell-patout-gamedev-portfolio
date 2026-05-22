# PROJECT_SCOPE - Stride: Lane Surge

## Goal

Deliver a Stride-oriented C# baseline that proves gameplay systems, deterministic
debug workflows, and release discipline while keeping the implementation fully
reproducible in source control.

## In Scope

- C# lane-dodge core loop simulation with difficulty ramp.
- Deterministic seed mode via environment variable.
- JSON run trace export for debug and regression comparison.
- Basic local persistence for best score.
- Acceptance test, profiling baseline template, and release runbook.
- Packaging and quality gate scripts.

## Out of Scope

- Full Stride editor scene/content pipeline.
- Audio integration.
- Networked systems and online leaderboards.
