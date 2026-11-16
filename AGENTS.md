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

<!-- nix-agent-guides:core BEGIN (v2). Synced from deepwatrcreatur/nix-agent-guides templates/agents-core.md by scripts/sync-agents-core.sh. Edit it there, not here. -->
## Shared conventions

Canonical, newest version:
https://raw.githubusercontent.com/deepwatrcreatur/nix-agent-guides/main/CONVENTIONS.md
If you can fetch it, read it before larger changes; where it differs from the
summary below, it is newer. This repo's own instructions above take
precedence over both.

Summary (offline fallback):

- **Comments explain why, not what.** Mark them `# WHY:`, `# GOTCHA:`,
  `# INVARIANT:`, `# SECURITY:`, `# UPSTREAM:` or `# TODO(#issue):`. One to
  three lines above the code they protect; longer reasoning goes in `docs/`
  with a pointer (`# WHY: docs/x.md#heading`). Never narrate the next line.
- **Before editing a file**, read its tags:
  `rg -n '# (WHY|GOTCHA|INVARIANT|SECURITY|UPSTREAM|TODO)' <file>`.
  Fix or delete any tag your change makes untrue.
- **Exported Nix functions** get RFC 145 doc comments (`/** ... */`).
- **Validate before committing:** the narrowest `nix build` first, then
  `nix flake check`; read all output. Run `bash -n`/`shellcheck` on shell
  generated from Nix. Exit code 0 is not proof the change worked.
- **Same change, same PR:** behaviour changes come with docs and a check.
- **Never commit secrets**, and do not deploy to or change live hosts unless
  asked.
<!-- nix-agent-guides:core END -->
