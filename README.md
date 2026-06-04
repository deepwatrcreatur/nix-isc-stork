# nix-isc-stork

Nix packaging and NixOS module work for **ISC Stork**, the dashboard and
observability layer for Kea DHCP and BIND 9.

## Scope

This repo is intended to hold:

- Nix packaging for ISC Stork components
- a development shell tailored to the upstream Stork build
- packaging notes about upstream release/build structure
- eventually, a reusable NixOS module for running Stork cleanly

## Why This Exists

Two practical problems showed up during router work:

1. `nixpkgs` already contains a package named `stork`, but it is the unrelated
   static-site search tool from `jameslittle230/stork`.
2. There is no obvious ISC Stork package or NixOS module to drop into the
   router stack.

So this repo exists to give ISC Stork its own packaging track with explicit
names such as `isc-stork-server` and `isc-stork-agent`.

## Upstream

- GitHub mirror: <https://github.com/isc-projects/stork>
- ISC docs: <https://stork.readthedocs.io>
- ISC GitLab project/issues: <https://gitlab.isc.org/isc-projects/stork>

## Initial Findings

- Upstream is a monorepo with at least:
  - Go backend in `backend/`
  - Angular web UI in `webui/`
  - Ruby/Rake orchestration at the repo root
- The web UI currently uses `package-lock.json`, so `npm` is the natural first
  build tool choice.
- Upstream docs and tests indicate PostgreSQL is part of the normal runtime and
  test story.
- GitHub releases are not the authoritative distribution channel; ISC’s own
  package/docs pipeline matters more.

## Repo Layout

- [flake.nix](./flake.nix): dev shell and future package/module entrypoint
- [docs/upstream-notes.md](./docs/upstream-notes.md): packaging-oriented
  upstream notes
- [docs/packaging-strategy.md](./docs/packaging-strategy.md): baseline decision
  on source build vs ISC package artifacts

## Current Status

This repo is intentionally starting as a **packaging workspace** rather than a
pretend-finished package. The first goal is to keep evaluation and tooling
clean while the real derivations are built incrementally.

The current stage-0 package attrs are:

- `isc-stork-source-layout`
- `isc-stork-server-src`
- `isc-stork-agent-src`
- `isc-stork-ui-src`

They pin the upstream `v2.4.0` source and preserve the server/agent/UI
boundaries so later work can replace them with real build derivations.
