_default:
    @just --list --unsorted --justfile {{justfile()}}

host := if path_exists(".host") == "true" { `cat .host` } else { "INVALID" }

# setup: Set the hostname to build the configuration for
setup HOST:
    @echo "Setting host to {{ HOST }}"
    @echo {{ HOST }} > .host

[private]
alias u := update
# u:    update all inputs
update:
    nix flake update

[private]
alias b := build
# b:    build the configuration
build:
    {{ if host == "INVALID" { error("Invalid host set, please run `just setup HOST`") } else { "" } }}
    nom build .#nixosConfigurations.{{ host }}.config.system.build.toplevel

[private]
alias s := switch
# s:    activate configuration & add to boot menu
switch: 
    sudo nixos-rebuild switch --flake .#{{ host }}

[private]
alias c := check
# c:    run flake checks, including making sure `.#repl` and the system config evaluate
check:
    nix flake check .# --show-trace

[private]
alias f := format
# f: run nix fmt on the flake
format:
    nix fmt

[private]
alias gc := garbage-collect
# gc: Run nix collect-garbage -d
garbage-collect:
    sudo nix-collect-garbage -d
