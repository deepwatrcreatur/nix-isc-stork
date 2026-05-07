# nix-isc-stork

## Purpose

This repo exists to package **ISC Stork** for Nix and eventually provide a
clean NixOS module surface for running Stork with Kea.

## Rules

1. Do not use the bare package name `stork` for produced attrs unless you are
   intentionally referring to the unrelated static-site search package already
   present in `nixpkgs`.
2. Prefer explicit names such as:
   - `isc-stork-server`
   - `isc-stork-agent`
   - `isc-stork-ui`
3. Keep packaging notes grounded in the actual upstream ISC Stork repo:
   - GitHub mirror: `isc-projects/stork`
   - primary issue/development home: ISC GitLab / docs
4. Keep the repo evaluable while work is incomplete. Avoid committing flakes
   that fail to evaluate just because the package derivation is unfinished.

## Current Direction

- Start with a packaging/devShell workspace.
- Capture upstream build and release facts in docs.
- Add package derivations only once source/build inputs are verified enough to
  keep the flake sane.
