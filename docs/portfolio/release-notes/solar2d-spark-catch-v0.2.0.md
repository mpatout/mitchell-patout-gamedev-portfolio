# Solar2D Spark Catch v0.2.0

## Scope Summary

Playable Solar2D vertical slice with mobile-first input and risk-reward scoring.

## Key Technical Updates

- Added runnable Spark Catch gameplay loop in main.lua.
- Added spawn budgeting, level scaling, combo, lives, and overcharge system.
- Added local best-score persistence.
- Added acceptance tests, profiling baseline, release runbook, and packaging/quality scripts.

## Performance Notes

- Primitive-only visuals keep render overhead low.
- Runtime profiling capture is pending on a machine with Solar2D simulator metrics tooling available.

## Known Issues

- Audio is not implemented.
- Native mobile export/signing is not automated in repository scripts.
