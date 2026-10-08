{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Shared tooling lives in flake/dev-shell-packages.nix so the flake devShell
  # (direnv `use flake`) and this devenv CLI shell never diverge.
  packages = import ./flake/dev-shell-packages.nix { inherit pkgs; };

  languages.nix.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
