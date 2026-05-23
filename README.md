# Game Development Portfolio

This repository demonstrates production-oriented game development across five engines:

- Godot
- Defold
- Solar2D
- Panda3D
- Stride (Xenko)

It is designed for recruiter and reviewer efficiency:

- Fast navigation by engine and competency
- Reproducible run/build instructions
- Evidence of architecture, debugging, and performance work
- Consistent release packaging and documentation quality

## Top Proof Points

1. Shipped multi-engine playable slices (Godot, Defold, Solar2D) with release/tag discipline.
2. Reproducible debugging workflows (deterministic seeds + trace summaries).
3. Structured performance proof workflow with explicit profiling gates.

## Reviewer Quick Path (10 Minutes)

1. Open competency coverage: `docs/portfolio/COMPETENCY_MATRIX.md`
2. Run flagship Godot slice: `engines/Godot/README.md`
3. Run Defold slice: `engines/defold/README.md`
4. Run Solar2D slice: `engines/solar2d/README.md`
5. Review implementation progress: `docs/portfolio/IMPLEMENTATION_STATUS.md`
6. Review debugging evidence: `docs/portfolio/DEBUGGING_CASE_STUDIES.md`
7. Review profiling evidence index: `docs/portfolio/PROFILING_EVIDENCE_INDEX.md`
8. Review gameplay evidence index: `docs/portfolio/GAMEPLAY_EVIDENCE_INDEX.md`
9. Review professional profile packet: `docs/portfolio/PROFESSIONAL_PROFILE_PACKET.md`
10. Run portfolio preflight: `scripts/run-portfolio-preflight.ps1`
11. Review summary snippets: `docs/portfolio/PROFESSIONAL_SUMMARY_BANK.md`

To execute profiling capture in one pass:

```powershell
./scripts/run-profiling-capture-sprint.ps1 -OpenPaths
```

## Engine Snapshot

| Engine | Project | Current State | Fast Evidence |
| --- | --- | --- | --- |
| Godot | Signal Chase | Production hardening in progress | `engines/Godot/scripts/main.gd`, `engines/Godot/TECHNICAL_PACKET.md`, `engines/Godot/ACCEPTANCE_TEST.md` |
| Defold | Pulse Grid | Advanced slice complete (offline-first leaderboard sync) | `engines/defold/main/game.gui_script`, `engines/defold/TECHNICAL_PACKET.md`, `engines/defold/ACCEPTANCE_TEST.md` |
| Solar2D | Spark Catch | Playable vertical slice in progress | `engines/solar2d/main.lua`, `engines/solar2d/TECHNICAL_PACKET.md`, `engines/solar2d/ACCEPTANCE_TEST.md` |
| Panda3D | Lane Drift | Playable vertical slice baseline implemented | `engines/panda3d/main.py`, `engines/panda3d/TECHNICAL_PACKET.md`, `engines/panda3d/ACCEPTANCE_TEST.md` |
| Stride | Lane Surge | Baseline simulation slice implemented | `engines/stride/src/LaneSurge/Program.cs`, `engines/stride/TECHNICAL_PACKET.md`, `engines/stride/ACCEPTANCE_TEST.md` |

## Start Here

1. Pick an engine directory under `engines/`.
2. Open that engine README.
3. Follow the quickstart to run the demo.
4. Review `TECHNICAL_PACKET.md` for architecture and profiling notes.

Portfolio execution progress is tracked in `docs/portfolio/IMPLEMENTATION_STATUS.md`.

Cross-engine architecture snapshots are tracked in `docs/standards/ARCHITECTURE_REFERENCE.md`.
Deterministic replay trace analysis for Godot is supported by `engines/Godot/scripts/summarize-trace.ps1`.

## Repository Layout

- `engines/` - Engine-specific demos and supporting docs
- `docs/portfolio/` - Portfolio matrix, evidence guides, and release checklists
- `docs/standards/` - Portfolio standards and governance
- `.github/` - Templates and CI workflows
- `scripts/` - Validation scripts used by CI

## Required Artifacts Per Engine Project

Each engine project must include:

- `README.md`
- `PROJECT_SCOPE.md`
- `TECHNICAL_PACKET.md`
- `CHANGELOG.md`
- `ASSET_PROVENANCE.md`

## Quality Gate

Pull requests must pass:

- Markdown linting
- Repository structure validation script

## Releases

Distribution is done through GitHub Releases with consistent artifact naming and versioning.
See `docs/portfolio/RELEASE_CHECKLIST.md`.

Current tag milestones:

- `godot-signal-chase-v0.3.2`
- `defold-pulse-grid-v0.2.0`
- `solar2d-spark-catch-v0.2.1`
- `panda3d-lane-drift-v0.1.0`
- `stride-lane-surge-v0.1.0`

To publish release pages with uploaded artifacts, run:

```powershell
$env:GITHUB_TOKEN="<token>"
./scripts/publish-github-releases.ps1 -Repository "mpatout/mitchell-patout-gamedev-portfolio"
```

Before final portfolio handoff, run:

```powershell
./scripts/run-portfolio-preflight.ps1
```

## License

Code and original assets are repository-specific. Third-party assets must be documented in each project's `ASSET_PROVENANCE.md`.

