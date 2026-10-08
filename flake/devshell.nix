{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        # Shared with devenv.nix — single source of truth in dev-shell-packages.nix
        packages = import ./dev-shell-packages.nix { inherit pkgs; };
      };
    };
}
