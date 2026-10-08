# Single packaging decision point for every craft app.
#
# Source-format decision (2026-10-08): the release TARBALL. The tar.gz,
# rpm, and deb assets carry byte-identical payloads, so the tarball wins
# on fetch/unpack simplicity. The RPM's auto-generated `requires:` list —
# the only content unique to it — documents the GUI libs the binaries
# dlopen at runtime; that set is reproduced below as `defaultRuntimeLibs`.
#
# Binary facts (verified on photocraft v0.3.0; apps are built the same way
# upstream): nearly-static Rust — NEEDED is only libgcc_s/libm/libc on a
# glibc-2.35 build — while the winit/wgpu-style GUI stack (EGL, Vulkan,
# X11, xkbcommon, wayland) is dlopen'd at runtime and therefore invisible
# to autoPatchelfHook. Every shipped binary is wrapped with LD_LIBRARY_PATH.
{
  lib,
  stdenv,
  runCommand,
  runtimeShell,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  # dlopen'd GUI runtime base set (mirrors the RPM `requires` metadata)
  libgcc,
  libGL,
  vulkan-loader,
  libxkbcommon,
  wayland,
  libx11,
  libxcb,
  libxcursor,
  libxi,
}:
{
  pname,
  version,
  # upstream GitHub slug, e.g. "storytold/photocraft"
  repo,
  description,
  # SRI hashes of the release tarballs per system:
  #   hashes = { x86_64-linux = "sha256-..."; aarch64-linux = "sha256-..."; }
  # (grep the app's SHA256SUMS.txt; convert with
  #  `nix hash convert --to sri --hash-algo sha256 <hex>`)
  # Only required when linuxAssets = true.
  hashes ? { },
  # extra runtime (dlopen'd) libs beyond the GUI base set
  runtimeLibs ? [ ],
  # false for apps without Linux release assets (artcraft: mac/win only;
  # soundcraft: no releases yet) — emits a placeholder stub instead
  linuxAssets ? true,
}@args:

let
  systems = builtins.attrNames hashes;
  # GitHub asset arch spelling
  ghArch = {
    x86_64-linux = "x86_64";
    aarch64-linux = "aarch64";
  };
  defaultRuntimeLibs = [
    libgcc # NEEDED: libgcc_s.so.1 (not in stdenv glibc)
    libGL # libEGL.so.1 (+ GLX)
    vulkan-loader # libvulkan.so.1
    libxkbcommon # libxkbcommon.so.0, libxkbcommon-x11.so.0
    wayland # libwayland-client.so.0
    libx11 # libX11.so.6, libX11-xcb.so.1
    libxcb # libxcb.so.1
    libxcursor # libXcursor.so.1
    libxi # libXi.so.6
  ];
  allRuntimeLibs = defaultRuntimeLibs ++ runtimeLibs;
in
assert
  linuxAssets -> hashes != { } || throw "${pname}: linuxAssets = true requires per-system hashes";
if linuxAssets then
  stdenv.mkDerivation {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/${repo}/releases/download/v${version}/${pname}-${version}-linux-${
        ghArch.${stdenv.hostPlatform.system}
      }.tar.gz";
      hash = hashes.${stdenv.hostPlatform.system};
    };
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    buildInputs = allRuntimeLibs;
    # tarball root is the /usr tree: bin/ + share/ (single top dir is
    # auto-stripped by the default unpackPhase)
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r bin share $out/
      runHook postInstall
    '';
    postFixup = ''
      for exe in $out/bin/*; do
        wrapProgram "$exe" \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath allRuntimeLibs}
      done
    '';
    meta = {
      inherit description;
      homepage = "https://github.com/${repo}";
      license = lib.licenses.asl20;
      mainProgram = pname;
      platforms = systems;
    };
    passthru = {
      inherit pname version repo;
      upstream = {
        # false = no Linux release assets upstream yet
        inherit linuxAssets;
        # assets published for every Linux release
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
else
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
          # false = no Linux release assets upstream yet
          inherit linuxAssets;
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
