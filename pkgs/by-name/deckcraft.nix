{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "deckcraft";
  version = "0.4.0";
  repo = "storytold/deckcraft";
  description = "Open-source presentation app — clean-room reimplementation of PowerPoint";
  # deckcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-aHEnr5N87zWyLICEhuUyAu+AvviN15PvSK8tpyVH0+I=";
    x86_64-linux = "sha256-1gdw8NbaiH/tXHaYP0kABG2H3X+9aWVKMiBJF4lLIs4=";
  };
}
