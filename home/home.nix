{
  config,
  lib,
  pkgs,
  hostName,
  inputs,
  system,
  ...
}:
with lib; rec {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./accounts.nix
    ./configFile.nix
    ./desktop.nix
    ./foot.nix
    ./hypr.nix
    ./mime.nix
    ./news.nix
    ./nushell.nix
    ./shell.nix
    ./xdg.nix
  ];

  home = {
    username = "bean";
    homeDirectory = "/home/bean";
    stateVersion = "23.05";
    file = {
      ".face".source = ../res/pictures/cow.png;
      ".gtkrc-2.0".source = ../res/gtk/.gtkrc-2.0;
      ".tuxpaintrc".source = ../res/tuxpaintrc;
    };
  };
}
