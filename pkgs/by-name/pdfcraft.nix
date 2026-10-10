# History: this app shipped as "printcraft" (repo storytold/printcraft);
# upstream renamed the repo to pdfcraft and, as of v0.4.0, flipped the
# release assets and binary names to pdfcraft-* — pname follows upstream.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "pdfcraft";
  version = "0.5.0";
  repo = "storytold/pdfcraft";
  description = "Open-source PDF app — clean-room reimplementation of Acrobat";
  hashes = {
    aarch64-linux = "sha256-J+WLjrrOvKbE5LMRCr0HelysAXCYcinT7Gncs1/LT4Q=";
    x86_64-linux = "sha256-ILNbP9CZwO8Cpye/m6267rZjnFZ0K00ERMwpdNv/X98=";
  };
}
