# 04 — Go Backend Build

## Status: `in-progress` — **Codex** — `feat/build-entrypoints`

## Objective

Add real Go build derivations for the backend binaries that are clearly split
in upstream:

- `stork-server`
- `stork-agent`

## Why

The stage-0 source scaffold proved the pinned source layout and package naming.
The next useful milestone is to replace backend source placeholders with real
buildable packages while leaving the UI pipeline for a later item.

## Current Progress

- Added `isc-stork-server` and `isc-stork-agent` as `buildGoModule` packages.
- Kept `isc-stork-ui-src` and `isc-stork-source-layout` for the later UI/module
  phases.
- Verified the flake evaluates and exposes the new attrs.

## Blocker

The real backend build is not green yet. Both binaries require generated code
that is absent from the plain source tarball:

- `backend/api/agent.pb.go` and `agent_grpc.pb.go` from `agent.proto`
- `backend/server/gen/...` from the Swagger server generation step

That prerequisite is split out into item `06`.
