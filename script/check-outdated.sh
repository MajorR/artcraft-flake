#!/usr/bin/env bash
# Compare pinned versions in pkgs/by-name/ against upstream's latest
# releases. Upstream releases multiple times per day — this is the drift
# report; pair it with `just bump-all` on a cadence, not per-release.
set -euo pipefail

printf '%-14s %-10s %-10s %s\n' APP PINNED LATEST STATUS
outdated=0
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
    printf '%-14s %-10s %-10s %s\n' "$app" "$pinned" "$latest" "up-to-date"
  else
    printf '%-14s %-10s %-10s %s\n' "$app" "$pinned" "$latest" "OUTDATED"
    outdated=$((outdated + 1))
  fi
done
echo
if ((outdated > 0)); then
  echo "${outdated} app(s) outdated — 'just bump-all' to catch up"
else
  echo "all apps up to date"
fi
