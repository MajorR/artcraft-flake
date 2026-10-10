# Note: from community dev bherbruck, not the storytold org — but it follows
# the exact same release pattern (tar.gz/rpm/deb/AppImage/flatpak +
# SHA256SUMS.txt) and the same "craft" naming.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "solvecraft";
  version = "0.1.3";
  repo = "bherbruck/solvecraft";
  description = "Open-source parametric 3D CAD — clean-room reimplementation of Autodesk Fusion 360";
  hashes = {
    aarch64-linux = "sha256-VSjoeGwug0CyVsVZOq3Y3uptrqxs99ZMjWkp7PzvP/A=";
    x86_64-linux = "sha256-WQ3Mk99Da0wCEgd52epePoO/STjzK2YKRCRLh/oQrUE=";
  };
}
