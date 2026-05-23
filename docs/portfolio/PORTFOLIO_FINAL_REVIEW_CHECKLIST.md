# Portfolio Final Review Checklist

Run this checklist before sharing the repository with external reviewers.

## 1) Repository Readiness

- [ ] Repository visibility is set as intended (public or private with invited reviewers).
- [ ] `main` branch is up to date.
- [ ] Required tags exist:
  - `godot-signal-chase-v0.3.2`
  - `defold-pulse-grid-v0.2.0`
  - `solar2d-spark-catch-v0.2.1`
  - `panda3d-lane-drift-v0.1.0`
  - `stride-lane-surge-v0.1.0`

## 2) Evidence Coverage

### Godot Slice

- [ ] Quickstart works: `engines/Godot/README.md`
- [ ] Architecture/debugging evidence present: `engines/Godot/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/Godot/ACCEPTANCE_TEST.md`
- [ ] Profiling baseline completed: `engines/Godot/PROFILING_BASELINE.md`

### Defold Slice

- [ ] Quickstart works: `engines/defold/README.md`
- [ ] Architecture/debugging evidence present: `engines/defold/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/defold/ACCEPTANCE_TEST.md`
- [ ] Profiling baseline completed: `engines/defold/PROFILING_BASELINE.md`

### Solar2D Slice

- [ ] Quickstart works: `engines/solar2d/README.md`
- [ ] Architecture/debugging evidence present: `engines/solar2d/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/solar2d/ACCEPTANCE_TEST.md`
- [ ] Profiling baseline completed: `engines/solar2d/PROFILING_BASELINE.md`

### Panda3D Slice

- [ ] Quickstart works: `engines/panda3d/README.md`
- [ ] Architecture/debugging evidence present: `engines/panda3d/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/panda3d/ACCEPTANCE_TEST.md`
- [ ] Profiling baseline completed: `engines/panda3d/PROFILING_BASELINE.md`

### Stride Slice

- [ ] Quickstart works: `engines/stride/README.md`
- [ ] Architecture/debugging evidence present: `engines/stride/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/stride/ACCEPTANCE_TEST.md`
- [ ] Profiling baseline completed: `engines/stride/PROFILING_BASELINE.md`

### Portfolio Narrative

- [ ] Root reviewer flow is clear: `README.md`
- [ ] Competency matrix is current: `docs/portfolio/COMPETENCY_MATRIX.md`
- [ ] Implementation status is current: `docs/portfolio/IMPLEMENTATION_STATUS.md`

## 3) Delivery Proof

- [ ] Source artifacts generated for each active engine.
- [ ] Release notes exist under `docs/portfolio/release-notes/`.
- [ ] GitHub release pages published (if token available): `scripts/publish-github-releases.ps1`.

## 4) Gameplay Media

- [ ] Gameplay evidence index reviewed: `docs/portfolio/GAMEPLAY_EVIDENCE_INDEX.md`.
- [ ] One gameplay clip per active engine saved under `docs/portfolio/evidence/gameplay/`.
- [ ] Gameplay media gate passes: `scripts/check-gameplay-media-readiness.ps1`.

## 5) Profiling Proof

- [ ] All baseline docs have no placeholder `Pending` values.
- [ ] Required screenshots exist under `docs/portfolio/evidence/profiling/`.
- [ ] Profiling gate passes: `scripts/check-profiling-readiness.ps1`.
- [ ] Optional accelerator used: `scripts/run-profiling-capture-sprint.ps1`.
- [ ] Optional auto-apply used: `scripts/apply-profiling-captures.ps1`.

## 6) Debugging Signal

- [ ] Deterministic replay workflow documented: `docs/portfolio/DEBUGGING_CASE_STUDIES.md`.
- [ ] Trace summarizer script available: `engines/Godot/scripts/summarize-trace.ps1`.

## 7) Final Preflight

- [ ] Run and pass: `scripts/run-portfolio-preflight.ps1`.
- [ ] Review profile packet: `docs/portfolio/PROFESSIONAL_PROFILE_PACKET.md`.
- [ ] Review summary snippets: `docs/portfolio/PROFESSIONAL_SUMMARY_BANK.md`.
