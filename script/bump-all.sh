#!/usr/bin/env bash
# Bump every outdated craft app to its latest upstream release.
# Each bump fetches only SHA256SUMS.txt; the ~60MB tarballs download at
# build time. Review with `git diff`, then `just check` and build.
set -euo pipefail

for file in pkgs/by-name/*.nix; do
  app=$(basename "$file" .nix)
  [[ $app == "craft-fonts" ]] && continue # pinned rev, not release-tracked
  pinned=$(sed -n 's/.*version = "\(.*\)";/\1/p' "$file" | head -1)
  repo=$(sed -n 's/.*repo = "\(.*\)";/\1/p' "$file")
  latest=$(
    curl -sf "https://api.github.com/repos/${repo}/releases/latest" |
      jq -r '.tag_name' | sed 's/^v//'
  )
  if [[ $pinned == "$latest" ]]; then
    echo "== $app: up to date ($pinned)"
  else
    echo "== $app: $pinned -> $latest"
    script/bump-app.sh "$app" "$latest"
  fi
done

echo
echo "all apps processed — review with 'git diff', then 'just check' and build."
