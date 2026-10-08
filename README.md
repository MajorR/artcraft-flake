# artcraft

Nix flake packaging the [ArtCraft Crafting Apps](https://getartcraft.com/apps) — open-source, pure-Rust creative tools from [storytold](https://github.com/storytold) — for Linux.

## Status

**Scaffold.** Package stubs exist for the seven craft apps; each builds a placeholder binary. The real packaging source (tarball vs RPM vs AppImage) is pending design — see [AGENTS.md](AGENTS.md) for the analysis and current upstream facts.

| Package | Upstream | Version |
|---|---|---|
| photocraft | [storytold/photocraft](https://github.com/storytold/photocraft) | 0.3.0 |
| vectorcraft | [storytold/vectorcraft](https://github.com/storytold/vectorcraft) | 0.4.0 |
| filmcraft | [storytold/filmcraft](https://github.com/storytold/filmcraft) | 0.2.1 |
| lightcraft | [storytold/lightcraft](https://github.com/storytold/lightcraft) | 0.2.1 |
| printcraft | [storytold/pdfcraft](https://github.com/storytold/pdfcraft) | 0.2.1 |
| effectcraft | [storytold/effectcraft](https://github.com/storytold/effectcraft) | 0.4.0 |
| designcraft | [storytold/designcraft](https://github.com/storytold/designcraft) | 0.2.1 |

The `artcraft` crafting engine itself is macOS/Windows-only upstream for now.

## Usage

```bash
nix build .#photocraft   # or any app name
nix run .#photocraft     # placeholder prints "not implemented" (for now)
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

Layout: `flake/` (flake-parts modules), `lib/mk-craft-app.nix` (the single builder — packaging decisions land here), `pkgs/by-name/` (one metadata file per app, auto-discovered).
