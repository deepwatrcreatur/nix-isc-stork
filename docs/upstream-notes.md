# ISC Stork Upstream Notes

These notes are intentionally packaging-focused.

## Canonical Sources

- GitHub mirror: `isc-projects/stork`
- primary docs: <https://stork.readthedocs.io>
- primary development/issues: ISC GitLab

## Observed Repo Shape

From upstream `master`:

- `backend/`
  - contains `go.mod`
  - likely holds the Stork server/agent Go code
- `webui/`
  - contains `package.json`
  - contains `package-lock.json`
  - Angular-based frontend
- repo root
  - contains `Rakefile`
  - contains `docker/`
  - contains `tests/pkgs-install/`

## Packaging Implications

1. This is not a single-language package.
2. A realistic package likely needs at least:
   - Go toolchain
   - Node/npm for web UI build
   - Ruby/Rake for orchestration or release scripts
3. Runtime/module work will likely need PostgreSQL in the service model.
4. We should avoid colliding with the existing unrelated `nixpkgs.stork`.

## Naming

Recommended attr naming:

- `isc-stork-server`
- `isc-stork-agent`
- `isc-stork-ui`

Potential module namespace later:

- `services.isc-stork`

## Next Steps

1. Identify upstream build entrypoints used outside Docker.
2. Determine whether packaging should start from source build or from ISC’s own
   package artifacts.
3. Split packaging work into:
   - source/build derivations
   - runtime module
   - database/bootstrap integration
