{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "filmcraft";
  version = "0.2.1";
  repo = "storytold/filmcraft";
  description = "Open-source video editor — clean-room reimplementation of Premiere Pro";
  # filmcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-PZm/pX7QPB479CmAgKx7A/yOZAtpKWmpjTbg/CXFwVE=";
    x86_64-linux = "sha256-3/J+ZEvLBrPUwfZnuP1US9Fe5LRGyK7mFwZxLyEoh68=";
  };
}
