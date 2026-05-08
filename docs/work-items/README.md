# Work Items

This folder is the local agent queue for `nix-isc-stork`.

## Status Model

- `ready` — can start now
- `in-progress` — owned by an active branch / agent
- `blocked` — depends on another item
- `done` — finished and kept briefly for outcome notes

## Current Ranked Queue

- [01-upstream-build-entrypoints.md](./01-upstream-build-entrypoints.md) — `done`
- [02-source-package-scaffold.md](./02-source-package-scaffold.md) — `done`
- [03-nixos-module-surface.md](./03-nixos-module-surface.md) — `blocked`

## Notes

- The packaging-strategy decision is already recorded in
  [docs/packaging-strategy.md](../packaging-strategy.md).
- This queue is derived from the current repo issues and docs, so agents can
  work even if GitHub API access is flaky.
