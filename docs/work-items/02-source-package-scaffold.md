# 02 — Source Package Scaffold

## Status: `done` — **Codex** — `feat/build-entrypoints`

## Objective

Add the first real Nix package scaffold for ISC Stork source builds.

## Scope

- Introduce package attrs with unambiguous naming.
- Wire the first derivation or staged derivations into `flake.nix`.
- Keep the initial scope narrow enough to iterate on build assumptions safely.

## Outcome

- Added a stage-0 package set in `pkgs/isc-stork/default.nix`.
- Wired the package attrs into `flake.nix`:
  - `isc-stork-source-layout`
  - `isc-stork-server-src`
  - `isc-stork-agent-src`
  - `isc-stork-ui-src`
- Pinned the upstream source to the real `v2.4.0` tag with a verified source
  hash.
- Kept the scaffold buildable today by packaging source boundaries and metadata
  rather than guessing at the full Go/npm/Rake release pipeline.
