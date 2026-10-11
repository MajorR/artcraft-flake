default:
    @just --list

# nixfmt all project nix files
fmt:
    nixfmt flake.nix flake/*.nix lib/*.nix pkgs/by-name/*.nix devenv.nix

# validate the flake
check:
    nix flake check

# build a package, e.g. just build photocraft
build app:
    nix build .#{{app}}

# list latest upstream releases for an app
releases app:
    gh release list --repo "$(sed -n 's/.*repo = "\(.*\)";/\1/p' pkgs/by-name/{{app}}.nix)" --limit 5

# bump an app to a new upstream release, e.g. just bump photocraft 0.4.0
bump app version:
    script/bump-app.sh {{app}} {{version}}

# show which apps are behind upstream's latest releases
outdated:
    script/check-outdated.sh

# bump every outdated app to its latest release
bump-all:
    script/bump-all.sh

# run the scheduled daily-bump task now (same unit the 06:00 timer fires)
update:
    #!/usr/bin/env bash
    set -u
    unit=opencode-job-artcraft-538deba2186c-artcraft-daily-bump.service
    log="$HOME/.config/opencode/logs/scheduler/artcraft-538deba2186c/artcraft-daily-bump.log"
    off=$(stat -c%s "$log" 2>/dev/null || echo 0)
    systemctl --user start "$unit"; rc=$?
    echo "── this run (full log: $log) ──"
    tail -c +"$((off + 1))" "$log"
    exit "$rc"

# push package closures to cachix, e.g. just cache-push .#suites.all
# (needs ARTCRAFT_CACHE and CACHIX_AUTH_TOKEN in the environment)
cache-push *targets:
    cachix push "$ARTCRAFT_CACHE" {{targets}}
