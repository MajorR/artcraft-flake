{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "effectcraft";
  version = "0.4.0";
  repo = "storytold/effectcraft";
  description = "Open-source motion graphics — clean-room reimplementation of After Effects";
  # effectcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-1lF6dXFTGRkdfFt948x+ZfkWbKXfqovbRVsbWpiJJmM=";
    x86_64-linux = "sha256-O3tha6g3kQ6BLlPP8XdsVhWf6WRO+NxHpFdZvXq3Z5o=";
  };
}
