{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "filmcraft";
  version = "0.4.0";
  repo = "storytold/filmcraft";
  description = "Open-source video editor — clean-room reimplementation of Premiere Pro";
  # filmcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-P7/JtJoCv6imumvX8YQXc7Ymoq3wkY9eYWQpnT8S8UQ=";
    x86_64-linux = "sha256-hBeQ/2ZJ8NSdqkqK3hyxjZSOXKQ9AHcQRmY+BsjYzoM=";
  };
}
