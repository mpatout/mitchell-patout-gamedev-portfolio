# Defold Pulse Grid v0.2.0

## Scope Summary

Advanced Defold milestone release focused on leaderboard depth and offline reliability.

## Key Technical Updates

- Added local top-5 leaderboard persistence.
- Added offline-first pending score queue with bounded growth.
- Added optional remote sync hook (HTTP + JSON) with safe local default behavior.
- Added overlay leaderboard/sync status output on title, time-up, and game-over states.
- Expanded acceptance tests and technical packet coverage for sync fallback behavior.

## Performance Notes

- Queue cap keeps save payload growth bounded during long sessions.
- Runtime profiling capture is still pending on a machine with Defold profiler tooling available.

## Known Issues

- Audio is not implemented.
- HTML5/mobile export pipeline remains manual.
- Remote sync endpoint is not configured by default (local mode is expected).
