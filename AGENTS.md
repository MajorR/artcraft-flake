# AGENTS.md

Guidance for AI coding agents (opencode et al.) working in this repository.

## What this is

Nix flake packaging the **ArtCraft Crafting Apps** suite (https://getartcraft.com/apps, https://github.com/storytold) for Linux. Each app lives in its own upstream repo, is written in pure Rust, and is Apache-2.0 licensed. Every Linux release publishes `.tar.gz`, `.rpm`, `.deb`, `.AppImage`, and `.flatpak` assets (x86_64 + aarch64) plus a `SHA256SUMS.txt`.

## Suite roster

| App | Role (Adobe analogue) | Upstream repo | Current |
|---|---|---|---|
| photocraft | image editor (Photoshop) | `storytold/photocraft` | v0.3.0 |
| vectorcraft | vector illustration (Illustrator) | `storytold/vectorcraft` | v0.4.0 |
| filmcraft | video editing (Premiere) | `storytold/filmcraft` | v0.2.1 |
| lightcraft | photo management (Lightroom) | `storytold/lightcraft` | v0.2.1 |
| printcraft | PDF (Acrobat) | `storytold/pdfcraft` | v0.2.1 |
| effectcraft | motion graphics (After Effects) | `storytold/effectcraft` | v0.4.0 |
| designcraft | page layout (InDesign) | `storytold/designcraft` | v0.2.1 |

- **printcraft got renamed upstream to `pdfcraft`** — release assets and the binary are still `printcraft-*`, so `pname = "printcraft"`, `repo = "storytold/pdfcraft"`. Watch for upstream flipping asset names.
- The main `storytold/artcraft` crafting engine has **no Linux release assets** (macOS/Windows only). Packaging it from source is a separate future task, not a `pkgs/by-name/` entry.
- Verify versions with `just releases <app>`; the table above is a snapshot.

## Open design decision

**Tarball vs RPM (vs AppImage/flatpak) as the packaging source.** The choice is isolated to exactly one file: `lib/mk-craft-app.nix`. Per-app files under `pkgs/by-name/` carry metadata only and stay format-agnostic. Facts to weigh:

- **tarball**: simplest to unpack; binaries need rpath/interpreter fixing (patchelf / autoPatchelfHook); check the archive layout is stable across releases.
- **RPM**: carries versioned dependency metadata (useful hints about required libs); Nix ignores the deps but the file list is explicit.
- **AppImage**: self-contained; awkward under Nix (extract-then-patch or appimage-run).
- All assets ship with `SHA256SUMS.txt` — fetch and verify when bumping versions.

Today `lib/mk-craft-app.nix` emits a placeholder derivation (stub binary that prints "not implemented") so the flake evaluates and builds end-to-end.

## Structure rules

- `lib/mk-craft-app.nix` is the **single builder** — every packaging/format decision lives there. Don't hand-roll derivations in app files.
- `pkgs/by-name/<app>.nix` is **metadata only** (pname, version, repo, description). Files are auto-discovered via `lib.packagesFromDirectoryRecursive` — adding an app is one new file, no edits elsewhere.
- `flake/dev-shell-packages.nix` is the single source of truth for dev tooling — both the flake devShell (direnv `use flake`) and devenv.nix import it. Add tools there only.
- **`git add` new files before evaluating.** Like every flake, untracked files are invisible to `nix flake check` and builds.
- Don't edit `flake.lock` by hand; use `nix flake update`. Keep flake.nix minimal — it's hand-written (no flake-file generation here).

## Commands

```bash
nix develop               # dev shell (direnv auto-enters)
nix flake check           # validate the flake
nix build .#photocraft    # build an app (stubs build a placeholder binary)
just fmt                  # nixfmt all project nix files
just check                # nix flake check
just build <app>          # nix build .#<app>
just releases <app>       # latest upstream releases via gh
```
