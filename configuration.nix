{
  lib,
  config,
  pkgs,
  hostName,
  inputs,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./modules/basics.nix
    ./computers/${hostName}/hardware-configuration.nix
    ./modules/audio.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/greeter.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/printing.nix
    ./modules/shell.nix
  ];
}
