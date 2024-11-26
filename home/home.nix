{
  config,
  lib,
  pkgs,
  hostName,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-index-database.hmModules.nix-index
    ./accounts.nix
    ./configFile.nix
    ./desktop.nix
    ./code.nix
    ./firefox.nix
    ./foot.nix
    ./hypr.nix
    ./mime.nix
    ./news.nix
    ./nvim.nix
    ./nushell.nix
    ./shell.nix
    ./swaync.nix
    ./waybar.nix
    ./xdg.nix
  ];

  catppuccin = {
    enable = true;
    accent = "green";
    flavor = "mocha";
  };

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
