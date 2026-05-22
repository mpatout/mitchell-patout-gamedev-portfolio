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
- Defold: runnable, documented, acceptance-tested, release scripts and quality gate present.
- Solar2D: runnable vertical slice, documented, acceptance-tested, release scripts and quality gate present.
- Panda3D/Stride: planned only; no runnable implementation yet.

## Remaining Gaps For Reviewer Confidence

- Capture and commit real profiling data/screenshots for all active engines.
- Publish tagged GitHub releases with downloadable source artifacts and notes.
- Add one public debugging case study issue/PR showing repro -> fix workflow.
