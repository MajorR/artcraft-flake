{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "filmcraft";
  version = "0.6.0";
  repo = "storytold/filmcraft";
  description = "Open-source video editor — clean-room reimplementation of Premiere Pro";
  # filmcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-qgrVRGnhwle2v7Z1P3XoKZDN8or9nalULlQaVMHVjb8=";
    x86_64-linux = "sha256-s9cG1Zlpnq12tGop1Wlyh7n3WgvJ60D3cz23ZX2uggQ=";
  };
}
