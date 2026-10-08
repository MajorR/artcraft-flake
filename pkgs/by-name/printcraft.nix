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
  hashes = {
    aarch64-linux = "sha256-x65drACzwRvqTnzFAoeKG2q1IDYtCYhSk+SEF0UuXcA=";
    x86_64-linux = "sha256-c7KXczDXNxaXEjf2j4nLpq1Sy/tWOtCrbZrRj0TUUZI=";
  };
}
