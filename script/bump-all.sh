#!/usr/bin/env bash
# Bump every outdated craft app to its latest upstream release.
# Each bump fetches only SHA256SUMS.txt; the ~60MB tarballs download at
# build time. Review with `git diff`, then `just check` and build.
#
# Version resolution uses the /releases/latest redirect Location header —
# no api.github.com calls, so no rate limit.
set -euo pipefail

# latest <repo> — print upstream's latest release version (no "v" prefix)
latest() {
  curl -sI "https://github.com/$1/releases/latest" |
    awk 'tolower($1) == "location:" { print $2 }' |
    tr -d '\r' | sed 's#.*/tag/##; s/^v//'
}

for file in pkgs/by-name/*.nix; do
  app=$(basename "$file" .nix)
  [[ $app == "craft-fonts" ]] && continue # pinned rev, not release-tracked
  pinned=$(sed -n 's/.*version = "\(.*\)";/\1/p' "$file" | head -1)
  repo=$(sed -n 's/.*repo = "\(.*\)";/\1/p' "$file")
  latest=$(latest "$repo")
  if [[ -z $latest ]]; then
    echo "== $app: no upstream releases, skipping"
  elif [[ $pinned == "$latest" ]]; then
    echo "== $app: up to date ($pinned)"
  else
    echo "== $app: $pinned -> $latest"
    script/bump-app.sh "$app" "$latest"
  fi
done

echo
echo "all apps processed — review with 'git diff', then 'just check' and build."
