# Professional Profile Packet

Use this packet as a concise narrative guide when sharing the repository with recruiters,
engineering managers, or collaborators.

## Portfolio Link

- Repository: https://github.com/mpatout/mitchell-patout-gamedev-portfolio

## Core Portfolio Positioning

- Multi-engine implementation depth across Godot, Defold, Solar2D, Panda3D, and Stride.
- Reproducible engineering workflows:
  - acceptance tests,
  - deterministic run controls,
  - trace export for debugging,
  - release packaging discipline.
- Evidence-first documentation model with architecture notes and profiling gates.

## Suggested Professional Summary

Use this as a short written intro when needed:

- `I build production-oriented gameplay slices across multiple engines with a focus on reproducibility, debugging rigor, and release discipline. This repository highlights concrete implementation evidence including architecture packets, deterministic run traces, acceptance tests, and packaging pipelines.`

## Engine-Specific Highlights

- Godot (Signal Chase): adaptive pressure systems, deterministic seed mode, replay trace export.
- Defold (Pulse Grid): GUI-first gameplay plus offline-first leaderboard sync architecture.
- Solar2D (Spark Catch): touch-first loop, deterministic mode, and telemetry support.
- Panda3D (Lane Drift): lane-dodge baseline with deterministic trace output.
- Stride (Lane Surge): C# simulation baseline with deterministic trace and persistence flow.

## Fast Reviewer Pointers

- Competency map: `docs/portfolio/COMPETENCY_MATRIX.md`
- Current status: `docs/portfolio/IMPLEMENTATION_STATUS.md`
- Debugging process: `docs/portfolio/DEBUGGING_CASE_STUDIES.md`
- Profiling evidence index: `docs/portfolio/PROFILING_EVIDENCE_INDEX.md`
- Gameplay evidence index: `docs/portfolio/GAMEPLAY_EVIDENCE_INDEX.md`

## Final Quality Checklist

Before externally sharing the portfolio link:

- Verify latest commits are on `main`.
- Verify required release tags exist.
- Verify release notes are present under `docs/portfolio/release-notes/`.
- Run: `scripts/run-portfolio-preflight.ps1`.
- If publishing release pages, set `GITHUB_TOKEN` and run `scripts/publish-github-releases.ps1`.
- Review `docs/portfolio/PORTFOLIO_FINAL_REVIEW_CHECKLIST.md`.
