# Shared dev tooling, consumed by BOTH the flake devShell (direnv `use flake`)
# and devenv.nix (the devenv CLI shell). Add new tools here — single source of
# truth so the two shells never diverge.
{ pkgs }:
[
  pkgs.just

  # nix tooling
  pkgs.nixfmt
  pkgs.nixd
  pkgs.nil
  pkgs.deadnix
  pkgs.statix
  pkgs.nurl # derive GitHub revs + hashes when bumping app versions

  # release / upstream integration tooling
  pkgs.gh
  pkgs.jq

  # pin-durability: push fetched tarball closures to a cachix cache
  # (just cache-push; needs ARTCRAFT_CACHE + CACHIX_AUTH_TOKEN)
  pkgs.cachix

  # binary repackaging kit (tarball / rpm / deb / AppImage sources)
  pkgs.patchelf
  pkgs.dpkg # inspect upstream .deb assets
  pkgs.rpm # inspect upstream .rpm assets
  pkgs.file
  pkgs.unzip
  pkgs.p7zip

  # LSPs used by agent sessions (see opencode.json)
  pkgs.bash-language-server
  pkgs.marksman
  pkgs.yaml-language-server

  # npx for npm-based MCP servers (tavily-mcp, see opencode.json)
  pkgs.nodejs

  # bun for JS/web tooling (opencode plugin dev)
  pkgs.bun
]
