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
  home = {
    username = "bean";
    homeDirectory = "/home/bean";
    stateVersion = "23.05";
    file = {
      ".face".source = ../res/pictures/cow.png;
      ".gtkrc-2.0".source = ../res/gtk/.gtkrc-2.0;
    };
    activation = {
      createXDGFoldersAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p $HOME/Desktop
        mkdir -p $HOME/Documents
        mkdir -p $HOME/Pictures
        mkdir -p $HOME/Videos
        mkdir -p $HOME/Music
      '';
    };
  };

  # Enable management of known folders
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${home.homeDirectory}/Desktop";
      documents = "${home.homeDirectory}/Documents";
      pictures = "${home.homeDirectory}/Pictures";
      videos = "${home.homeDirectory}/Videos";
      music = "${home.homeDirectory}/Music";
    };
    configFile = import ./configFile.nix { inherit lib hostName; };
    mimeApps = import ./mime.nix;
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  # Hyprland
  wayland.windowManager.hyprland = import ./hypr.nix {inherit pkgs lib system inputs;};

  programs = {
    # Shell
    starship = {
      enable = true;
      settings = fromTOML (fileContents ../res/starship.toml);
    };

    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = { show_banner: false }
      '';
      envFile.text = ''
        alias py = python
        alias cat = bat
        alias neofetch = hyfetch
        alias screensaver = pipes-rs -k curved -p 10 --fps 30
        alias hyperctl = hyprctl
        alias hyprland = Hyprland
        alias hyperland = hyprland
      '';
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      location = "center";
      theme = ../res/rofi-style.rasi;
      plugins = with pkgs; [
        rofi-emoji
        rofi-power-menu
        rofi-bluetooth
        rofi-calc
        rofi-pulse-select
      ];
    };

    # CLI Tools
    bat.enable = true;
    ripgrep.enable = true;
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    foot = import ./foot.nix;

    # GUI Apps
    chromium.enable = true;
    thunderbird = {
      enable = true;
      profiles.bean.isDefault = true;
    };
  };

  # Enable KDE Connect
  services = {
    kdeconnect.enable = true;
  };
}
