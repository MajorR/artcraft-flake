{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "deckcraft";
  version = "0.3.0";
  repo = "storytold/deckcraft";
  description = "Open-source presentation app — clean-room reimplementation of PowerPoint";
  # deckcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-/h2TbH5nNxq6Lj7Yb/6bwgcgpuH/Wwo5DIIoO7lMJD8=";
    x86_64-linux = "sha256-F51s5HQBujfCM8P8ChgDQSau2BrDaknE327NrKm1q38=";
  };
}
