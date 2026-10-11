{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "effectcraft";
  version = "0.8.0";
  repo = "storytold/effectcraft";
  description = "Open-source motion graphics — clean-room reimplementation of After Effects";
  # effectcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-Z3g/5lUyh54TrrpECosPJgsPvcmzbpkRgXIL2meusn4=";
    x86_64-linux = "sha256-clyIzzeRItcPlB3T7ay1RHnWP/HioA+uMY6u4CrXYsQ=";
  };
}
