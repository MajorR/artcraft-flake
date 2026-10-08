# History: this app shipped as "printcraft" (repo storytold/printcraft);
# upstream renamed the repo to pdfcraft and, as of v0.4.0, flipped the
# release assets and binary names to pdfcraft-* — pname follows upstream.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "pdfcraft";
  version = "0.4.0";
  repo = "storytold/pdfcraft";
  description = "Open-source PDF app — clean-room reimplementation of Acrobat";
  hashes = {
    aarch64-linux = "sha256-CLL/bFOK2zzAioiBSjzObu4Jy5jJr5NMOTpRMaMVWQ4=";
    x86_64-linux = "sha256-SHmzzbTRJhlFrwOxxfAPPoaNBehOd5EZYMrFBaoWwds=";
  };
}
