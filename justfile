_default:
    @just --list --unsorted --justfile {{justfile()}}

[private]
alias u := update
# u:    update all inputs
update:
    nix flake update

_rebuild COMMAND:
    sudo nixos-rebuild {{ COMMAND }} --flake .#b-pc-laptop

[private]
alias b := build
# b:    build the configuration
build:
    nom build .#nixosConfigurations.b-pc-laptop.config.system.build.toplevel

[private]
alias s := switch
# s:    activate configuration & add to boot menu
switch: (_rebuild "switch")

[private]
alias c := check
# c:    run flake checks, including making sure `.#repl` and the system config evaluate
check:
    nix flake check .# --show-trace

