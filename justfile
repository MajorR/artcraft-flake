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
    gh release list --repo storytold/{{app}} --limit 5

# bump an app to a new upstream release, e.g. just bump photocraft 0.4.0
bump app version:
    script/bump-app.sh {{app}} {{version}}

# show which apps are behind upstream's latest releases
outdated:
    script/check-outdated.sh

# bump every outdated app to its latest release
bump-all:
    script/bump-all.sh
