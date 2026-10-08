# artcraft

Nix flake packaging the [ArtCraft Crafting Apps](https://getartcraft.com/apps) — open-source, pure-Rust creative tools from [storytold](https://github.com/storytold) — for Linux.

## Status

**Real release-tarball packaging** for the 11 apps with Linux assets — binaries are unpacked, auto-patched to Nix's glibc, and wrapped with `LD_LIBRARY_PATH` for their dlopen'd GUI stack (EGL/Vulkan/X11/wayland/xkbcommon). CLI binaries run natively. **craft-fonts** packages repo assets directly. **Not packaged** (no Linux releases upstream): `artcraft` (macOS/Windows only) and `soundcraft` (no releases yet) — they'll be added when Linux builds exist. Decision rationale and binary facts live in [AGENTS.md](AGENTS.md).

Packages come flat (`.#photocraft`) and grouped into suite bundles (`.#suites.office`):

| Suite | Apps (upstream version) |
|---|---|
| `creative` | photocraft (0.3.0), vectorcraft (0.4.0), lightcraft (0.2.1), filmcraft (0.2.1), effectcraft (0.4.0), designcraft (0.2.1) |
| `office` | wordcraft (0.1.0), gridcraft (0.1.0), deckcraft (0.1.0), printcraft (0.2.1) |
| `cad` | cadcraft (0.1.0) |
| `all` | everything above + [craft-fonts](https://github.com/storytold/craft-fonts) (OFL-licensed CJK/Arabic fonts) |

## Usage

```bash
nix build .#photocraft    # or any app name
nix build .#suites.office # a whole suite bundle
nix run .#photocraft      # launches the real app (needs a display)
```

## Import & deployment

Declare the flake as an input **with nixpkgs following yours** — this keeps a single stdenv/glibc closure instead of duplicating one per flake:

```nix
# flake.nix
inputs.artcraft = {
  url = "github:rmichaelolsen/artcraft"; # adjust to the pushed remote
  inputs.nixpkgs.follows = "nixpkgs";
};
```

In a flake-file-based repo (e.g. LunaLabClan), declare the same attrs under `flake-file.inputs.artcraft` in the relevant component and regenerate with `nix run .#write-flake`.

Consume per user (recommended — desktop entries land in the launcher automatically):

```nix
# home-manager
home.packages = [
  inputs.artcraft.packages.${pkgs.system}.photocraft
  inputs.artcraft.packages.${pkgs.system}.vectorcraft
  # or a whole bundle — suites live in legacyPackages (flake-parts'
  # `packages` option is strictly flat):
  inputs.artcraft.legacyPackages.${pkgs.system}.suites.office
];
```

NixOS-wide instead: `environment.systemPackages = [ ... ]` with the same attribute paths. One-off try without importing: `nix run github:rmichaelolsen/artcraft#photocraft`.

Caveats:

- Flat apps (`packages.<system>.<app>`) are the interface for configs; `suites.*` bundles are interactive-user sugar reachable only via legacyPackages.
- aarch64 hashes are taken from upstream `SHA256SUMS.txt` but are build-untested (no arm machine in the loop).
- GUI sessions were verified via CLI smoke tests + linkage inspection, not full interactive runs.

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
