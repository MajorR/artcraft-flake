{
  mk-craft-app,
  alsa-lib,
}:
mk-craft-app {
  pname = "effectcraft";
  version = "0.7.0";
  repo = "storytold/effectcraft";
  description = "Open-source motion graphics — clean-room reimplementation of After Effects";
  # effectcraft's main binary links libasound.so.2 directly (NEEDED, not dlopen)
  runtimeLibs = [ alsa-lib ];
  hashes = {
    aarch64-linux = "sha256-27c4poniPoVcx7Boiavt3bfRQ17IC8Gtpb3LrUnHAdc=";
    x86_64-linux = "sha256-/+x316LjSdn7AMjruQKvwsuO9UyKLVjdQEurFfW4Q4c=";
  };
}
