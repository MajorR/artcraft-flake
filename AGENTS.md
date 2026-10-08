# AGENTS.md

Guidance for AI coding agents (opencode et al.) working in this repository.

## What this is

Nix flake packaging the **ArtCraft Crafting Apps** suite (https://getartcraft.com/apps, https://github.com/storytold) for Linux. Each app lives in its own upstream repo, is written in pure Rust, and is Apache-2.0 licensed. Every Linux release publishes `.tar.gz`, `.rpm`, `.deb`, `.AppImage`, and `.flatpak` assets (x86_64 + aarch64) plus a `SHA256SUMS.txt`.

## Organization

**Flat primary interface + suite bundles.**

- `packages.<system>.<app>` — flat, one package per app. This is what Home-manager/NixOS configs consume and what `nix build .#photocraft` hits.
- `packages.<system>.suites.<name>` — `symlinkJoin` convenience bundles (`nix build .#suites.office`). Suite membership lives **only** in `flake/suites.nix`.
- Suites are declared under `legacyPackages` (flake-parts' `packages` option is strictly flat); `nix build .#suites.<name>` still resolves via Nix's standard legacyPackages fallback. Flat apps are the interface for configs, suites are interactive-user sugar.

| Suite | Apps | Mimics |
|---|---|---|
| `creative` | photocraft 0.3.0, vectorcraft 0.4.0, lightcraft 0.2.1, filmcraft 0.2.1, effectcraft 0.4.0, designcraft 0.2.1 | Photoshop, Illustrator, Lightroom, Premiere Pro, After Effects, InDesign |
| `office` | wordcraft 0.1.0, gridcraft 0.1.0, deckcraft 0.1.0, printcraft 0.2.1 | Word, Excel, PowerPoint, Acrobat Pro |
| `cad` | cadcraft 0.1.0 | AutoCAD |
| `art` | artcraft 0.41.0 — **placeholder, no Linux assets** (macOS/Windows releases only) | — (AI crafting engine) |
| `audio` | soundcraft — **placeholder, no releases yet** (repo exists) | Pro Tools |
| `all` | everything above + **craft-fonts** | — |

- `craft-fonts` is a real (non-placeholder) package: fonts are plain assets in the repo, pinned rev, OFL-1.1; installed to `$out/share/fonts/{truetype,opentype}`. Only included in `suites.all` — apps/users pick it up explicitly.
- **printcraft got renamed upstream to `pdfcraft`** — release assets and the binary are still `printcraft-*`, so `pname = "printcraft"`, `repo = "storytold/pdfcraft"`. Watch for upstream flipping asset names.
- Apps without Linux release assets carry `linuxAssets = false` (visible in `passthru.upstream`) so the real builder can skip/special-case them.
- Verify versions with `just releases <app>`; the tables above are a snapshot.

## Open design decision

**Tarball vs RPM (vs AppImage/flatpak) as the packaging source.** The choice is isolated to exactly one file: `lib/mk-craft-app.nix`. Per-app files under `pkgs/by-name/` carry metadata only and stay format-agnostic. Facts to weigh:

- **tarball**: simplest to unpack; binaries need rpath/interpreter fixing (patchelf / autoPatchelfHook); check the archive layout is stable across releases.
- **RPM**: carries versioned dependency metadata (useful hints about required libs); Nix ignores the deps but the file list is explicit.
- **AppImage**: self-contained; awkward under Nix (extract-then-patch or appimage-run).
- All assets ship with `SHA256SUMS.txt` — fetch and verify when bumping versions.

Today `lib/mk-craft-app.nix` emits a placeholder derivation (stub binary that prints "not implemented") so the flake evaluates and builds end-to-end. `artcraft` will need a from-source build (its Rust repo), not a release-asset repackage — separate builder path, future task.

## Structure rules

- `lib/mk-craft-app.nix` is the **single builder** — every packaging/format decision lives there. Don't hand-roll derivations in app files (exceptions so far: `craft-fonts`, which packages plain repo assets).
- `pkgs/by-name/<app>.nix` is **metadata only** (pname, version, repo, description, `linuxAssets`). Files are auto-discovered via `lib.packagesFromDirectoryRecursive`.
- **Adding an app** = create `pkgs/by-name/<app>.nix`, then add it to a suite list in `flake/suites.nix`. Two touches, never structural change.
- **Adding a suite** = one list + one line in `flake/suites.nix`.
- `flake/dev-shell-packages.nix` is the single source of truth for dev tooling — both the flake devShell (direnv `use flake`) and devenv.nix import it. Add tools there only.
- **`git add` new files before evaluating.** Like every flake, untracked files are invisible to `nix flake check` and builds.
- Don't edit `flake.lock` by hand; use `nix flake update`. Keep flake.nix minimal — it's hand-written (no flake-file generation here).

## Commands

```bash
nix develop               # dev shell (direnv auto-enters)
nix flake check           # validate the flake
nix build .#photocraft    # build an app (stubs build a placeholder binary)
nix build .#suites.office # build a suite bundle
just fmt                  # nixfmt all project nix files
just check                # nix flake check
just build <app>          # nix build .#<app>
just releases <app>       # latest upstream releases via gh
```
