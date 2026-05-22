# Handshake Application Packet

Use this packet to answer the screening form with concrete, verifiable evidence.

## Portfolio Link

- Repository: https://github.com/mpatout/mitchell-patout-gamedev-portfolio

## Evidence Highlights To Mention

- Multi-engine implementation in active progress:
  - Godot (Signal Chase) with adaptive difficulty, deterministic seed support, and replay trace instrumentation.
  - Defold (Pulse Grid) production baseline with release + quality scripts.
  - Solar2D (Spark Catch) playable vertical slice with mobile-first control model.
- Reproducible engineering process:
  - Acceptance tests per engine.
  - Structured release runbooks and package scripts.
  - Profiling evidence framework and readiness gate.

## Suggested Form Wording (Truthful)

For copy/paste-ready field responses, use:

- `docs/portfolio/HANDSHAKE_FORM_RESPONSE_BANK.md`

### What is your current job title?

- Example: Independent Game Development Portfolio Builder (or your current real title).

### Who is your current employer?

- Use your current real employer or "Self-directed / Independent" if applicable.

### LinkedIn profile URL

- Paste your current LinkedIn URL.

### How many years of experience do you have with Godot?

- Select the truthful bracket based on your actual history.
- Support statement (optional):
  - "Built Signal Chase in Godot with deterministic replay support, adaptive pressure director, acceptance tests, and release tooling."

### How many years of experience do you have with Defold?

- Select truthful bracket.
- Support statement (optional):
  - "Built Pulse Grid in Defold with GUI-driven architecture, persistence, and release quality gates."

### How many years of experience do you have with Solar 2D?

- Select truthful bracket.
- Support statement (optional):
  - "Built Spark Catch playable slice with touch-first controls, scaling difficulty, and release docs/tooling."

### How many years of experience do you have with Panda3D / O3DE / Stride?

- Select truthful bracket for each.
- If low/no direct experience, mention adjacent transferable work when possible.

### Please provide a link to your portfolio or any work samples

- Primary link:
  - https://github.com/mpatout/mitchell-patout-gamedev-portfolio
- Optional supporting paths:
  - README quick path and competency matrix
  - release tags and release notes folder

## Fast Reviewer Pointers

- Competency map: `docs/portfolio/COMPETENCY_MATRIX.md`
- Current status: `docs/portfolio/IMPLEMENTATION_STATUS.md`
- Debugging process: `docs/portfolio/DEBUGGING_CASE_STUDIES.md`
- Profiling readiness: `docs/portfolio/PROFILING_EVIDENCE_INDEX.md`

## Before Submission Checklist

- Verify GitHub repo is public.
- Confirm latest commits are on `main`.
- Confirm tags exist:
  - `godot-signal-chase-v0.3.2`
  - `defold-pulse-grid-v0.1.0`
  - `solar2d-spark-catch-v0.2.1`
- If token available, publish release pages with `scripts/publish-github-releases.ps1`.
- Fill profiling baseline logs and add screenshots, then run `scripts/check-profiling-readiness.ps1`.
- Run full final gate: `scripts/run-handshake-preflight.ps1`.
- Optionally review step-by-step checklist: `docs/portfolio/HANDSHAKE_FINAL_REVIEW_CHECKLIST.md`.
