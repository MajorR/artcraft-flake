# Suite bundles: nested convenience packages under packages.<system>.suites.*.
# Suite membership lives ONLY here — moving an app between suites is one word.
# Recipes:
#   new app  -> create pkgs/by-name/<app>.nix, then add it to a suite list below
#   new suite-> add a list to this file's let-block and wire it into `suites`
{
  perSystem =
    { self', pkgs, ... }:
    let
      inherit (self'.packages)
        artcraft
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
        soundcraft
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
      audio = [ soundcraft ];
      art = [ artcraft ];

      suites = {
        inherit
          creative
          office
          cad
          audio
          art
          ;
        all = [ craft-fonts ] ++ creative ++ office ++ cad ++ audio ++ art;
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
