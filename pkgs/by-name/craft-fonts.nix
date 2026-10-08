# Real derivation (not a placeholder): fonts are plain assets shipped in the
# repo itself — no upstream release assets needed. Font files are OFL-1.1
# (see each family's OFL.txt); the repo's Rust code is Apache-2.0/MIT but we
# ship only the fonts.
{
  lib,
  fetchFromGitHub,
  runCommand,
}:
let
  # pinned rev + SRI hash via `nix flake prefetch github:storytold/craft-fonts/<rev>`
  rev = "8dcdacd5153e64560d109541a47d806f26f048c0";
  hash = "sha256-4E9OrthE5z39xFXpvpwn4Fn6RH3wX2sF56rZZejZT+I=";
  version = "0-unstable-2026-10-06";
in
runCommand "craft-fonts-${version}"
  {
    src = fetchFromGitHub {
      owner = "storytold";
      repo = "craft-fonts";
      inherit rev hash;
    };
    meta = {
      description = "Reusable fonts for the ArtCraft Crafting Apps (BIZ UD, Shippori Mincho, Noto Sans CJK SC, Noto Sans Arabic)";
      homepage = "https://github.com/storytold/craft-fonts";
      license = lib.licenses.ofl;
      platforms = lib.platforms.unix;
    };
    passthru = {
      inherit rev version;
      updateScript = [
        "nix flake prefetch"
        "github:storytold/craft-fonts"
      ];
    };
  }
  ''
    mkdir -p $out/share/fonts/truetype $out/share/fonts/opentype $out/share/doc/craft-fonts
    cp $src/fonts/*/*.ttf $out/share/fonts/truetype/
    cp $src/fonts/*/*.otf $out/share/fonts/opentype/
    cp $src/fonts/manifest.txt $src/ATTRIBUTION.md $out/share/doc/craft-fonts/
  ''
