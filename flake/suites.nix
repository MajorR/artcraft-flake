# Suite bundles: nested convenience packages under legacyPackages.suites.*
# (flake-parts' `packages` option is strictly flat). Suite membership lives
# ONLY here — moving an app between suites is one word.
# Recipes:
#   new app  -> create pkgs/by-name/<app>.nix, then add it to a suite list below
#   new suite-> add a list to this file's let-block and wire it into `suites`
{
  perSystem =
    { self', pkgs, ... }:
    let
      inherit (self'.packages)
        cadcraft
        craft-fonts
        deckcraft
        designcraft
        effectcraft
        filmcraft
        gridcraft
        lightcraft
        photocraft
        printcraft
        vectorcraft
        wordcraft
        ;

      creative = [
        designcraft
        effectcraft
        filmcraft
        lightcraft
        photocraft
        vectorcraft
      ];
      office = [
        deckcraft
        gridcraft
        printcraft
        wordcraft
      ];
      cad = [ cadcraft ];

      suites = {
        inherit creative office cad;
        all = [ craft-fonts ] ++ creative ++ office ++ cad;
      };
    in
    {
      # Nested bundles live under legacyPackages — flake-parts' `packages`
      # option is strictly flat — which keeps `nix build .#suites.<name>`
      # working via Nix's standard legacyPackages fallback. Flat apps remain
      # in `packages`; that is what configs should consume.
      legacyPackages.suites = builtins.mapAttrs (
        name: apps:
        pkgs.symlinkJoin {
          name = "craft-suite-${name}";
          paths = apps;
          meta = {
            description = "ArtCraft Crafting Apps — ${name} suite bundle";
          };
        }
      ) suites;
    };
}
