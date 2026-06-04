# 01 — Upstream Build Entrypoints

## Status: `done` — **Codex** — `feat/build-entrypoints`

## Objective

Identify the minimal upstream build entrypoints needed to package ISC Stork
from source without relying on Docker or ISC binary artifacts.

## Why

The repo already chose a source-first packaging strategy, but the next real
step is to reduce guesswork about upstream's release/build flow:

- which backend binaries are built directly from Go
- how the Angular `webui/` assets are produced
- whether the Ruby/Rake layer is required for release builds or only
  orchestration

## Requirements

- Document the upstream build entrypoints that matter for Nix packaging.
- Distinguish mandatory build tools from release-only tooling.
- Record any obvious split-output boundaries:
  - `isc-stork-server`
  - `isc-stork-agent`
  - `isc-stork-ui`

## Acceptance Criteria

- A committed note exists under `docs/` with concrete entrypoint findings.
- Item `02` can proceed from those findings without rediscovering basics.

## Outcome

- Added `docs/build-entrypoints.md` with concrete upstream build findings from
  ISC's published installation docs.
- Confirmed the release build is coordinated via `rake build_backend`,
  `rake build_ui`, and `rake build_binaries`.
- Clarified that backend and UI can be reasoned about separately, which
  unblocks the first staged Nix package scaffold.
