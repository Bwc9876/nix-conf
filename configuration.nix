{
  lib,
  config,
  pkgs,
  hostName,
  ags,
  inputs,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
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

  # Set the time zone.
  time.timeZone = "America/New_York";

  # Define a user account.
  users = {
    users.bean = {
      isNormalUser = true;
      description = "Benjamin Crocker";
      extraGroups = ["networkmanager" "wheel" "video" "lpadmin" "wireshark"];
    };
  };

  # Pass extra arguments to home-manager.
  home-manager.extraSpecialArgs = {
    inherit hostName inputs system;
  };
}
