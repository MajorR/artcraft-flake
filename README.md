# artcraft

Nix flake packaging the [ArtCraft Crafting Apps](https://getartcraft.com/apps) — open-source, pure-Rust creative tools from [storytold](https://github.com/storytold) — for Linux.

## Status

**Real release-tarball packaging** for the 11 apps with Linux assets — binaries are unpacked, auto-patched to Nix's glibc, and wrapped with `LD_LIBRARY_PATH` for their dlopen'd GUI stack (EGL/Vulkan/X11/wayland/xkbcommon). `photocraft-cli --version` and friends run natively. Placeholders remain for **artcraft** (upstream has no Linux builds — future source build) and **soundcraft** (no releases yet); **craft-fonts** packages repo assets directly. Decision rationale and binary facts live in [AGENTS.md](AGENTS.md).

Packages come flat (`.#photocraft`) and grouped into suite bundles (`.#suites.office`):

| Suite | Apps (upstream version) |
|---|---|
| `creative` | photocraft (0.3.0), vectorcraft (0.4.0), lightcraft (0.2.1), filmcraft (0.2.1), effectcraft (0.4.0), designcraft (0.2.1) |
| `office` | wordcraft (0.1.0), gridcraft (0.1.0), deckcraft (0.1.0), printcraft (0.2.1) |
| `cad` | cadcraft (0.1.0) |
| `art` | artcraft (0.41.0) — placeholder; upstream has no Linux builds (macOS/Windows only) |
| `audio` | soundcraft — placeholder; upstream has no releases yet |
| `all` | everything + [craft-fonts](https://github.com/storytold/craft-fonts) (OFL-licensed CJK/Arabic fonts) |

The `artcraft` crafting engine itself will eventually need a from-source build.

## Usage

```bash
nix build .#photocraft    # or any app name
nix build .#suites.office # a whole suite bundle
nix run .#photocraft      # launches the real app (needs a display)
```

## Development

The dev shell is wired for both direnv (`use flake`) and the devenv CLI; both share tooling from `flake/dev-shell-packages.nix`.

```bash
direnv allow        # or: nix develop / devenv shell
just                # list recipes
just fmt            # nixfmt all nix files
just check          # nix flake check
just releases <app> # latest upstream releases
```

Layout: `flake/` (flake-parts modules: packages, suites, devshell), `lib/mk-craft-app.nix` (the single builder — packaging decisions land here), `pkgs/by-name/` (one metadata file per app, auto-discovered).
