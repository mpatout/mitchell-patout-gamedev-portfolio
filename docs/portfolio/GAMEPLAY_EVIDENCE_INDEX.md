# Gameplay Evidence Index

This index tracks lightweight gameplay media for recruiter review speed.

## Required Evidence Per Active Engine

- One short gameplay clip (`.mp4` preferred).
- One optional GIF for quick inline preview.
- Link or note in release notes where applicable.

## Suggested Artifact Paths

| Engine | Primary Clip | Optional GIF |
| --- | --- | --- |
| Godot | `docs/portfolio/evidence/gameplay/godot/gameplay.mp4` | `docs/portfolio/evidence/gameplay/godot/gameplay.gif` |
| Defold | `docs/portfolio/evidence/gameplay/defold/gameplay.mp4` | `docs/portfolio/evidence/gameplay/defold/gameplay.gif` |
| Solar2D | `docs/portfolio/evidence/gameplay/solar2d/gameplay.mp4` | `docs/portfolio/evidence/gameplay/solar2d/gameplay.gif` |

## Recommended Clip Scope

- 8 to 20 seconds per engine.
- Show one core loop action and one escalation moment.
- Avoid menus-only footage.

## Optional Gate

Run optional gameplay media check:

```powershell
./scripts/check-gameplay-media-readiness.ps1
```

Use this as a Month 2 quality target. It is not required for current submission preflight unless explicitly enabled.
