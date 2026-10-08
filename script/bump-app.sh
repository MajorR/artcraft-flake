#!/usr/bin/env bash
# Bump a craft app to a new upstream release: rewrites `version` and both
# tarball SRI hashes in pkgs/by-name/<app>.nix from the release's
# SHA256SUMS.txt. Run from the repo root (or via: just bump <app> <version>).
# Afterwards review with `git diff`, then `just check && nix build .#<app>`.
set -euo pipefail

app="${1:?usage: bump-app.sh <app> <version>}"
version="${2:?usage: bump-app.sh <app> <version>}"
file="pkgs/by-name/${app}.nix"

[[ -f $file ]] || { echo "error: $file not found" >&2; exit 1; }

repo=$(sed -n 's/.*repo = "\(.*\)";/\1/p' "$file")
[[ -n $repo ]] || { echo "error: no repo = \"...\" found in $file" >&2; exit 1; }

sums=$(mktemp)
trap 'rm -f "$sums"' EXIT

echo "fetching ${repo} v${version} checksums ..."
if ! curl -sfL "https://github.com/${repo}/releases/download/v${version}/SHA256SUMS.txt" -o "$sums"; then
  echo "error: no SHA256SUMS.txt for ${repo} v${version} (bad tag?)" >&2
  exit 1
fi

sri_for() {
  local hex
  hex=$(awk -v name="${app}-${version}-linux-$1.tar.gz" '$2 == name { print $1 }' "$sums")
  [[ -n $hex ]] || {
    echo "error: checksum missing for ${app}-${version}-linux-$1.tar.gz" >&2
    exit 1
  }
  nix hash convert --to sri --hash-algo sha256 "$hex"
}

sri_x86=$(sri_for x86_64)
sri_arm=$(sri_for aarch64)

sed -i \
  -e "s|^  version = \".*\";|  version = \"${version}\";|" \
  -e "s|x86_64-linux = \"sha256-[^\"]*\";|x86_64-linux = \"${sri_x86}\";|" \
  -e "s|aarch64-linux = \"sha256-[^\"]*\";|aarch64-linux = \"${sri_arm}\";|" \
  "$file"

# verify the rewrites actually landed (sed is silent on no-match)
grep -q "version = \"${version}\"" "$file" ||
  { echo "error: version line not rewritten (unexpected file layout?)" >&2; exit 1; }
grep -q "x86_64-linux = \"${sri_x86}\"" "$file" ||
  { echo "error: x86_64 hash line not rewritten" >&2; exit 1; }
grep -q "aarch64-linux = \"${sri_arm}\"" "$file" ||
  { echo "error: aarch64 hash line not rewritten" >&2; exit 1; }

nixfmt "$file"

echo "bumped ${app} to ${version}:"
git diff --stat "$file"
echo
echo "next: git diff, then 'just check && nix build .#${app}'"
