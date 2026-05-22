# Project Scope

## Goal

Deliver a reviewer-ready Solar2D vertical slice that demonstrates gameplay
system ownership, mobile-oriented input handling, deterministic round flow, and
release discipline consistent with the rest of the portfolio.

## Current Vertical Slice (v0.2.0)

- 75-second catch-and-survive rounds.
- Horizontal drag catcher with collision checks against falling objects.
- Progressive level curve tied to score milestones.
- Three object types:
	- Spark: positive score on catch, life penalty on miss.
	- Shard: life penalty on catch, safe to miss.
	- Overcharge token: starts a temporary risk-reward multiplier window.
- Best-score persistence between sessions.
- Pause/resume, title state, round-over state, and instant restart.

## In Scope

- Core playable loop
- Stable build and run path
- Technical packet with profiling notes
- Acceptance test and release runbook
- Primitive-only rendering to avoid asset-pipeline delay

## Out of Scope

- Non-essential feature creep
- Untracked third-party assets
- Native mobile binary signing/distribution
- Monetization and ad SDK integration

## Exit Criteria For Current Step

- Reviewer can run from Solar2D Simulator in under 5 minutes.
- Full round can be completed and restarted with stable state resets.
- Controls, known limitations, and system behavior are documented.
- Release scripts can package source artifact for GitHub Releases.
