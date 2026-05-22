# TECHNICAL_PACKET - Stride: Lane Surge

## Architecture

```
engines/stride/
|- src/LaneSurge/
|  |- LaneSurge.csproj
|  \- Program.cs                    Core simulation loop + persistence + tracing
|- runtime/
|  |- lane_surge_latest_run.json    Latest run trace export
|  \- lane_surge_save.json          Best-score persistence
|- scripts/
|  |- package-release.ps1           Source zip packaging
|  \- quality-gate.ps1              Engine slice validation and CI preview package
\- *.md                              Scope, tests, profiling, and release docs
```

## Key Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Runtime form | .NET simulation harness | Keeps baseline runnable without heavy editor/runtime setup |
| World model | 5 fixed lanes | Predictable collision checks and clear difficulty tuning |
| Determinism | `STRIDE_SEED` env var | Reproducible debug traces |
| Trace format | JSON event stream | Easy diffing and reviewer-friendly evidence |
| Persistence | Local JSON save | No external dependency for best-score verification |

## Debugging Notes

- Use the same `STRIDE_SEED` across runs to compare trace event ordering.
- If trace export fails, verify write access to `engines/stride/runtime/`.
- If simulation exits too early, inspect collision threshold and lane decision logic in `Program.cs`.

## Performance Notes

- Per-tick work is O(active_obstacles), with active obstacle count bounded by
	despawn/cleanup logic.
- Current baseline is CPU-light and suitable for deterministic test runs.

## Known Limitations

- Not yet a full Stride scene/entity implementation.
- No visual render loop benchmark captured yet.
- Profiling values are template-only until capture sprint is executed.
