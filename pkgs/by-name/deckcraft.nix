{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "deckcraft";
  version = "0.5.0";
  repo = "storytold/deckcraft";
  description = "Open-source presentation app — clean-room reimplementation of PowerPoint";
  # deckcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-n7Q67bmyI89i800rUJAMYzenzVyzF4ubUwu5OiE8QC0=";
    x86_64-linux = "sha256-wmSMYHH2MezGY5zmt9YPaO7YPd6rprFVmwfFBGhjEXw=";
  };
}
