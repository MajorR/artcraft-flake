# History: this app shipped as "printcraft" (repo storytold/printcraft);
# upstream renamed the repo to pdfcraft and, as of v0.4.0, flipped the
# release assets and binary names to pdfcraft-* — pname follows upstream.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "pdfcraft";
  version = "0.6.0";
  repo = "storytold/pdfcraft";
  description = "Open-source PDF app — clean-room reimplementation of Acrobat";
  hashes = {
    aarch64-linux = "sha256-IPtRddtcmSNVtvHHPMWxY74F0vTycK/vahhLuuOzilk=";
    x86_64-linux = "sha256-mhNuceN7RZ7VdG2+GaNkzoTPXZlcb2yYr2FH2Bg5ClM=";
  };
}
