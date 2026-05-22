# Handshake Final Review Checklist

Run this checklist right before submitting the Handshake form.

## 1) Repository Readiness

- [ ] Repository is public.
- [ ] `main` branch is up to date.
- [ ] Required tags exist:
  - `godot-signal-chase-v0.3.2`
  - `defold-pulse-grid-v0.1.0`
  - `solar2d-spark-catch-v0.2.1`

## 2) Evidence Coverage (Role Prompt Mapping)

### Godot Experience Prompt

- [ ] Godot project quickstart works: `engines/Godot/README.md`
- [ ] Architecture and debugging evidence present: `engines/Godot/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/Godot/ACCEPTANCE_TEST.md`
- [ ] Performance baseline completed: `engines/Godot/PROFILING_BASELINE.md`

### Defold Experience Prompt

- [ ] Defold project quickstart works: `engines/defold/README.md`
- [ ] Architecture and debugging evidence present: `engines/defold/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/defold/ACCEPTANCE_TEST.md`
- [ ] Performance baseline completed: `engines/defold/PROFILING_BASELINE.md`

### Solar2D Experience Prompt

- [ ] Solar2D project quickstart works: `engines/solar2d/README.md`
- [ ] Architecture and debugging evidence present: `engines/solar2d/TECHNICAL_PACKET.md`
- [ ] Acceptance tests present: `engines/solar2d/ACCEPTANCE_TEST.md`
- [ ] Performance baseline completed: `engines/solar2d/PROFILING_BASELINE.md`

### Portfolio Link Prompt

- [ ] Root reviewer flow is clear: `README.md`
- [ ] Competency matrix is current: `docs/portfolio/COMPETENCY_MATRIX.md`
- [ ] Implementation status is current: `docs/portfolio/IMPLEMENTATION_STATUS.md`

## 3) Delivery Proof

- [ ] Source artifacts generated for each active engine.
- [ ] Release notes exist under `docs/portfolio/release-notes/`.
- [ ] GitHub release pages published (if token available): `scripts/publish-github-releases.ps1`.

## 3.5) Gameplay Media Proof (Month 2 Target)

- [ ] Gameplay evidence index reviewed: `docs/portfolio/GAMEPLAY_EVIDENCE_INDEX.md`.
- [ ] One gameplay clip per active engine saved under `docs/portfolio/evidence/gameplay/`.
- [ ] Optional gate passes: `scripts/check-gameplay-media-readiness.ps1`.

## 4) Profiling Proof

- [ ] All baseline docs have no `Pending` values.
- [ ] Required screenshots exist under `docs/portfolio/evidence/profiling/`.
- [ ] Profiling gate passes: `scripts/check-profiling-readiness.ps1`.
- [ ] Optional accelerator used: `scripts/run-profiling-capture-sprint.ps1`.
- [ ] Optional auto-apply used: `scripts/apply-profiling-captures.ps1`.

## 5) Debugging Process Signal

- [ ] Deterministic replay workflow documented: `docs/portfolio/DEBUGGING_CASE_STUDIES.md`.
- [ ] Trace summarizer script available: `engines/Godot/scripts/summarize-trace.ps1`.

## 6) Submission Packet

- [ ] Application packet reviewed and customized with truthful details:
  `docs/portfolio/HANDSHAKE_APPLICATION_PACKET.md`.
- [ ] LinkedIn URL and role/employer fields filled accurately.
- [ ] Final portfolio URL pasted in form.
