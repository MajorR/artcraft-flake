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
