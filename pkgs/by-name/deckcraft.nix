{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "deckcraft";
  version = "0.1.0";
  repo = "storytold/deckcraft";
  description = "Open-source presentation app — clean-room reimplementation of PowerPoint";
  # deckcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-Dz7B4BYctwsKEgU/rUBjB4TsVXEb8hoJBg6t/SdSZ20=";
    x86_64-linux = "sha256-L1pOuQGUMk1sF1UAUw7IC49LJAixuW7Of4U+oxMB9ig=";
  };
}
