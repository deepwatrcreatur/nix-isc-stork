# 06 — API Codegen Prerequisites

## Status: `ready`

## Objective

Reproduce the upstream pre-build code generation needed before Stork's Go
backend can compile from source.

## Why

The `stork-server` and `stork-agent` builds currently fail because the plain
release tarball lacks generated Go sources that upstream normally creates from:

- `backend/api/agent.proto`
- `api/swagger.in.yaml` and related API YAML fragments

## Scope

- generate `backend/api/agent.pb.go` and `agent_grpc.pb.go`
- generate `backend/server/gen/...` from the Swagger server task
- determine whether `stdoptiondef4.go` / `stdoptiondef6.go` also need to be
  generated as part of the backend package build
- identify the exact Nix tool inputs needed for those steps
