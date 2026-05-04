# Game Development Specialist Portfolio

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

## Start Here

1. Pick an engine directory under `engines/`.
2. Open that engine README.
3. Follow the quickstart to run the demo.
4. Review `TECHNICAL_PACKET.md` for architecture and profiling notes.

Portfolio execution progress is tracked in `docs/portfolio/IMPLEMENTATION_STATUS.md`.

## Repository Layout

- `engines/` - Engine-specific demos and supporting docs
- `docs/portfolio/` - Hiring-facing matrix and release checklists
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

## License

Code and original assets are repository-specific. Third-party assets must be documented in each project's `ASSET_PROVENANCE.md`.
