{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "filmcraft";
  version = "0.5.0";
  repo = "storytold/filmcraft";
  description = "Open-source video editor — clean-room reimplementation of Premiere Pro";
  # filmcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-scdYeOkcgMYvqr/4thfc1B/yWgnsQ8R0XxJcr2mWIMQ=";
    x86_64-linux = "sha256-viGD+YWcATy/Lo3ClSRTJQOj63XiFWr2F71N9/+tQN0=";
  };
}
