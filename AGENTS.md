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
| `all` | everything above + **craft-fonts** | — |

- `craft-fonts` is a real (non-placeholder) package: fonts are plain assets in the repo, pinned rev, OFL-1.1; installed to `$out/share/fonts/{truetype,opentype}`. Only included in `suites.all` — apps/users pick it up explicitly.
- **printcraft got renamed upstream to `pdfcraft`** — release assets and the binary are still `printcraft-*`, so `pname = "printcraft"`, `repo = "storytold/pdfcraft"`. Watch for upstream flipping asset names.
- **Not packaged** (no Linux releases upstream): `artcraft` (macOS/Windows only) and `soundcraft` (no releases at all). Add them when Linux assets appear — a new app file + a suite entry is all it takes.
- Verify versions with `just releases <app>`; the tables above are a snapshot.

## Packaging decision (2026-10-08): tarball, with a dlopen wrapper

**The release tarball is the packaging source.** Verified on photocraft v0.3.0: the `.tar.gz`, `.rpm`, and `.deb` assets carry byte-identical payloads, so the tarball wins on fetch/unpack simplicity (`fetchurl` + default unpack, no rpm2cpio/cpio in the sandbox). Asset naming is uniform: `{pname}-{version}-linux-{x86_64|aarch64}.tar.gz`. AppImage/flatpak rejected (squashfs extraction, no benefit). The RPM's only unique content — its auto-generated `requires:` list — documents the dlopen surface and is reproduced in `defaultRuntimeLibs` inside `lib/mk-craft-app.nix`.

Binary facts (all apps built the same way upstream):

- Nearly-static Rust: `NEEDED` is only `libgcc_s`/`libm`/`libc` (glibc 2.35 build); no RPATH. `autoPatchelfHook` fixes the interpreter + libgcc — note `libgcc_s.so.1` needs the explicit `libgcc` buildInput (not in stdenv glibc).
- The GUI stack (winit/wgpu-style, **not** Tauri — no webkit2gtk) is **dlopen'd at runtime** and invisible to ldd/patchelf: EGL, Vulkan, X11/xcb/Xcursor/Xi, xkbcommon(+x11), wayland. Every shipped binary is `wrapProgram`'d with `LD_LIBRARY_PATH` over `defaultRuntimeLibs ++ runtimeLibs`.
- Desktop file uses bare `Exec=<app>` — works as-is under the wrapper.
- filmcraft, effectcraft, and deckcraft link `libasound.so.2` directly (NEEDED) — they carry `runtimeLibs = [ alsa-lib ]` in their app files.
- Verify checksums against each release's `SHA256SUMS.txt` when bumping versions (convert: `nix hash convert --to sri --hash-algo sha256 <hex>` — or just use `just bump`).

## Structure rules

- `lib/mk-craft-app.nix` is the **single builder** — every packaging/format decision lives there. Don't hand-roll derivations in app files (exceptions so far: `craft-fonts`, which packages plain repo assets).
- `pkgs/by-name/<app>.nix` is **metadata only** (pname, version, repo, description, `hashes`, optional `runtimeLibs`). Files are auto-discovered via `lib.packagesFromDirectoryRecursive`.
- **Bumping a version** = `just bump <app> <version>` — fetches the release's `SHA256SUMS.txt`, rewrites `version` + both SRI `hashes`, nixfmts. Then `git diff && just check && nix build .#<app>`. If a new app dlopens more libs, extend `runtimeLibs` in its file — the GUI base set stays in the builder.
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
just bump <app> <version> # rewrite version + SRI hashes from SHA256SUMS.txt
```
