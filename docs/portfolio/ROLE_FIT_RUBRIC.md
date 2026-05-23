# Role Fit Rubric

This rubric maps repository evidence to game development specialist expectations.

## Core Criteria

1. Engine Competency
- Demonstrates practical fluency in Godot, Defold, Solar2D, Panda3D, and Stride.
- Evidence: runnable demos and clear runbooks.

2. Production Reliability
- Delivers reproducible setup and stable playable builds.
- Evidence: release artifacts, quickstart instructions, known limitations.

3. Systems Thinking
- Shows architecture decisions, tradeoffs, and debugging discipline.
- Evidence: technical packets and decision logs.

4. Performance Awareness
- Captures baseline performance and constraints.
- Evidence: profiling snapshots and optimization notes.

5. Documentation Quality
- Enables reviewers to evaluate quickly with minimal ambiguity.
- Evidence: consistent README, changelog, and provenance docs.

## Pass Condition

A project is considered portfolio-ready when all required artifacts exist, quickstart succeeds on a clean environment, and technical evidence is present.

## Current Evidence Snapshot

- Godot: runnable, documented, acceptance-tested, deterministic seed + replay trace instrumentation.
- Defold: runnable, documented, acceptance-tested, offline-first leaderboard cache/sync workflow, release scripts, and quality gate present.
- Solar2D: runnable vertical slice, documented, acceptance-tested, release scripts, and quality gate present.
- Panda3D: runnable lane-dodge baseline with deterministic seed + trace export, documented, acceptance-tested, release scripts, and quality gate present.
- Stride: runnable C# simulation baseline with deterministic seed + trace export, documented, acceptance-tested, release scripts, and quality gate present.
- Debugging workflow: reproducible case-study path documented in `docs/portfolio/DEBUGGING_CASE_STUDIES.md`.

## Remaining Gaps For Reviewer Confidence

- Gameplay clips currently satisfy the repository gate, but should be replaced with richer production captures for external sharing.
- Expand Panda3D and Stride from baseline slices into advanced slices to match Godot/Defold depth.
- Add one public debugging case study issue/PR showing repro -> fix workflow.
