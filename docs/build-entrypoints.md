# ISC Stork Build Entrypoints

This note records the minimal upstream build entrypoints that matter for a
source-first Nix packaging strategy.

## Primary Findings

From ISC's installation/build docs, the release build is orchestrated from the
repo root with Rake tasks:

- `rake build_backend`
- `rake build_ui`
- `rake build_binaries`

The docs also describe separate dev/test surfaces for the backend and web UI,
which means the repo is mixed-language but not opaque.

## What Each Layer Appears To Do

### Backend

The backend lives under `backend/` and uses Go modules (`go.mod` is present).
The upstream install docs describe backend-focused development and testing with
Go, which strongly suggests the actual server/agent binaries can be built from
that subtree without needing Docker as the packaging entrypoint.

Implication for Nix:

- the first package scaffold should treat the backend as a normal Go build
  problem
- we should determine the exact binary names/paths from the upstream tree next

### Web UI

The web UI lives under `webui/` and upstream docs describe a Node/npm-based
frontend workflow. The repo contains `package.json` and `package-lock.json`,
which makes npm the natural starting point.

Implication for Nix:

- UI asset generation should be modeled as a separate derivation phase or
  package
- the first scaffold can keep UI assets logically distinct from the Go backend

### Rake Layer

Upstream's documented build entrypoints are Rake tasks at the repo root. That
does not necessarily mean Ruby is required for the final packaged runtime; it
means the upstream release build is coordinated there.

Implication for Nix:

- Ruby/Rake is a build-orchestration dependency
- we should avoid assuming it belongs in the runtime closure unless later
  evidence shows Stork executes Ruby at runtime

## Packaging Boundaries

The current evidence supports these logical package boundaries:

- `isc-stork-server`
- `isc-stork-agent`
- `isc-stork-ui`

Even if the first derivation is temporarily combined, those names are still the
right long-term split.

## Recommended Next Step

Item `02` should start with a narrow scaffold:

1. package the backend path first or at least map its binaries
2. package the web UI asset build separately
3. only use the root Rake tasks as reference/orchestration guidance, not as a
   reason to collapse everything into one opaque derivation

## Sources

- ISC Stork install/build docs:
  <https://stork.readthedocs.io/en/stable/install.html>
- Upstream repo layout notes already recorded in:
  [upstream-notes.md](./upstream-notes.md)
