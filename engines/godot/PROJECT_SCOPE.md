# Project Scope

## Goal

Deliver a polished, recruiter-readable Godot vertical slice that proves gameplay-loop ownership,
input handling, state transitions, and release-readiness discipline.

## Current Vertical Slice (v0.3.0)

- Survival score-attack arena gameplay (60-second rounds)
- Progressive difficulty with level-scaled threats
- Enemy pursuit and hazard collision systems
- Combo scoring and life system with invulnerability timing
- Stasis powerup behavior and persistent best-score save
- End-of-round state, pause/resume flow, and instant restart loop
- Runnable in Godot editor and from CLI path

## In Scope

- Core playable loop
- Stable build and run path
- Technical packet with profiling notes
- Clear technical handoff documentation
- Primitive-only rendering to avoid asset pipeline delay in early slice
- Release runbook and packaging script for reproducible artifacts

## Out of Scope

- Non-essential feature creep
- Untracked third-party assets
- Multiplayer
- Asset-heavy art production before mechanics lock
- Monetization or platform SDK integration

## Exit Criteria For Step 1

- Reviewer can run game in under 5 minutes from clean checkout
- Round can be completed and restarted without errors
- Project docs describe controls, scope, and known limitations
- Threat scaling, pause, and persistence behavior are demonstrated in-play
