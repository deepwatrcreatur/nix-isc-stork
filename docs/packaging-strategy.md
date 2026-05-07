# Packaging Strategy

## Recommendation

Use a **source-build-first** strategy for this repo.

Treat ISC's published Debian/RPM packages as:

- a reference for runtime layout
- a fallback for early smoke testing
- and a comparison point when source packaging drifts

But do **not** make repackaging ISC's binary artifacts the primary Nix path.

## Why

### 1. This repo exists to produce real Nix packaging

The upstream Stork project is a mixed-source monorepo:

- Go backend in `backend/`
- Angular web UI in `webui/`
- Ruby/Rake orchestration in the repo root

That is exactly the kind of software stack Nix is good at building
reproducibly from source.

### 2. Source build fits Nix's strengths better

Source packaging gives us:

- reproducibility
- patchability
- clearer dependency accounting
- easier long-term maintenance in a flake/module repo
- less dependence on ISC's distribution format choices

### 3. ISC's package distribution is useful, but not ideal as the main path

The official docs emphasize installing from Debian/RPM packages, and ISC ships
those packages through its normal packaging flow. That is valuable operational
evidence, but for Nix it has tradeoffs:

- opaque runtime bundling
- weaker patchability
- less control over split outputs
- more friction if we want clean module integration for services, paths, users,
  and database setup

### 4. We eventually want a NixOS module

If the end goal includes `services.isc-stork`, source packaging is the cleaner
base. Repackaging foreign `.deb`/`.rpm` artifacts would likely make the module
more fragile and less idiomatic.

## What This Means Practically

### v1 packaging direction

Start by packaging from source and decompose the problem explicitly:

1. build the web UI assets from `webui/`
2. build the Go server/agent components from `backend/`
3. determine what runtime filesystem layout the upstream expects
4. add service/module work only after the package layout is understood

### Fallback path

If source packaging is blocked on an upstream build assumption that would take
too long to unwind, a temporary artifact-based package is acceptable for:

- smoke testing
- runtime inspection
- comparing service layout

But that should be documented as an interim measure, not the target design.

## Open Questions

- Which upstream build entrypoint is the minimal one outside Docker?
- Are server and agent naturally separable outputs?
- Does upstream require the Ruby/Rake layer only for orchestration, or also for
  the actual release build?
- What database/bootstrap assumptions should inform the eventual NixOS module?

## Sources

- ISC Stork README:
  <https://github.com/isc-projects/stork/blob/master/README.md>
- ISC Stork docs:
  <https://stork.readthedocs.io>
