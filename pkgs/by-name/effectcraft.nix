{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "effectcraft";
  version = "0.6.0";
  repo = "storytold/effectcraft";
  description = "Open-source motion graphics — clean-room reimplementation of After Effects";
  # effectcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-d8xXa5sce2Q26ZfySoxQsFeD9svlc6rqoOx+EFh3RY4=";
    x86_64-linux = "sha256-cYEHGZAzeM2rMqH+Mo8jyHTTjNPYM6uxnGJj3SutIYw=";
  };
}
