# Exposes one package per app stub in pkgs/by-name. Files there are
# auto-discovered — adding an app is a new metadata file, no edits here.
{
  perSystem =
    { pkgs, lib, ... }:
    let
      pkgs' = pkgs.extend (
        final: prev: {
          mk-craft-app = final.callPackage ../lib/mk-craft-app.nix { };
        }
      );
    in
    {
      packages = lib.packagesFromDirectoryRecursive {
        callPackage = pkgs'.callPackage;
        directory = ../pkgs/by-name;
      };
    };
}
