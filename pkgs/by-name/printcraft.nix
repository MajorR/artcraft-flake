# NOTE: upstream renamed the repo to pdfcraft, but release assets and the
# product binary are still named printcraft-* — pname follows the binary.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "printcraft";
  version = "0.2.1";
  repo = "storytold/pdfcraft";
  description = "Open-source PDF app — clean-room reimplementation of Acrobat";
}
