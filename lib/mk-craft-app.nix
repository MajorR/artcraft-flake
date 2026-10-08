# Single packaging decision point for every craft app.
#
# Today this emits a working placeholder derivation (a stub binary that
# prints a "not implemented" message) so the flake evaluates and builds
# end-to-end. When the tarball-vs-RPM(-vs-AppImage) source decision is
# made, replace the builder body here. The per-app files under
# pkgs/by-name/ supply metadata only and should not need to change.
{
  lib,
  runCommand,
  runtimeShell,
}:
{
  pname,
  version,
  # upstream GitHub slug, e.g. "storytold/photocraft"
  repo,
  description,
}@args:

runCommand "${pname}-${version}-placeholder"
  {
    meta = {
      description = "${description} (placeholder — nix packaging not implemented yet)";
      homepage = "https://github.com/${repo}";
      license = lib.licenses.asl20;
      mainProgram = pname;
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
    passthru = {
      inherit pname version repo;
      upstream = {
        # assets published for every Linux release; the future builder picks one
        artifacts = [
          "tar.gz"
          "rpm"
          "deb"
          "AppImage"
          "flatpak"
        ];
        checksums = "SHA256SUMS.txt";
      };
    }
    // (args.passthru or { });
  }
  ''
    mkdir -p $out/bin
    {
      echo '#!${runtimeShell}'
      echo 'echo "${pname} ${version}: nix packaging not implemented yet" >&2'
      echo 'exit 1'
    } > "$out/bin/${pname}"
    chmod +x "$out/bin/${pname}"
  ''
