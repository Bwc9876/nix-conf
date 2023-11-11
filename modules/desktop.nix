{
  inputs,
  system,
  pkgs,
  ...
}: {
  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = [inputs.xdg-desktop-portal-hyprland.packages.${system}.xdg-desktop-portal-hyprland];
  }; # For screensharing

  # Theming
  environment.pathsToLink = [
    "/share/Kvantum"
    "/share/icons"
  ]; # Kvantum needs linking
  fonts = {
    packages = with pkgs; [(nerdfonts.override {fonts = ["FiraMono"];}) noto-fonts noto-fonts-color-emoji];
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        serif = ["Noto Sans" "FiraMono Nerd Font Mono" "Noto Color Emoji"];
        sansSerif = serif;
        monospace = ["FiraCode Nerd Font Mono" "Noto Sans Mono" "Noto Color Emoji"];
        emoji = ["FiraCode Nerd Font Mono" "Noto Color Emoji"];
      };
    };
  };

  # Waybar
  programs.dconf.enable = true; # Needed for waybar module

  # Polkit
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  }; # For polkit-gnome

  # Lock Screen
  services.accounts-daemon.enable = true; # So gtklock can get user info
  security.pam.services.gtklock.text = ''
    auth            sufficient      pam_unix.so try_first_pass likeauth nullok
    auth            sufficient      pam_fprintd.so
    auth            include         login
  ''; # Allow fingerprint auth

  # KDE Connect
  programs.kdeconnect.enable = true;

  systemd.user.services.kdeconnect = {
    description = "Adds communication between your desktop and your smartphone";
    after = ["graphical-session-pre.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      #   Environment = "PATH=${config.home.profileDirectory}/bin";
      ExecStart = "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
      Restart = "on-abort";
    };
  };

  # Applications
  environment.systemPackages = with pkgs; [
    # Hyprland: Configured in HM

    # Shell Components
    hyprpicker
    hyprpaper
    swaynotificationcenter
    (callPackage ../pkgs/swayosd.nix {})

    ## Waybar
    inputs.waybar.packages.${system}.waybar
    qt6.qttools # For component

    ## Rofi
    rofi
    rofi-emoji
    rofi-power-menu
    rofi-bluetooth
    rofi-calc
    rofi-pulse-select
    (callPackage ../pkgs/rofi-code.nix {})
    (callPackage ../pkgs/rofi-systemd.nix {})

    ## GTK Lock
    gtklock
    gtklock-userinfo-module # For displaying name and picture
    swayidle # For locking when idle

    ## Clipboard
    wl-clipboard
    cliphist

    ## Screenshot / Record
    wl-screenrec
    slurp
    grimblast
    swappy

    # Theming
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    (callPackage ../pkgs/theming.nix {}) # Custom themes
    gnome.adwaita-icon-theme # For fallback icons

    # Applications
    xcowsay
    virtualbox

    ## System Management / Monitoring
    libsForQt5.filelight
    networkmanagerapplet
    pavucontrol

    ## General / Everyday
    firefox-devedition
    obsidian
    keepassxc
    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
    spotify

    ### Dolphin
    libsForQt5.dolphin
    libsForQt5.ark # For archive support
    libsForQt5.kio-extras # For thumbnails
    libsForQt5.kdegraphics-thumbnailers # For thumbnails

    ## Media
    libsForQt5.kdenlive
    obs-studio
    qmplay2
    gimp
    inkscape
    lorien
    tuxpaint
    image-roll

    ## Office
    libreoffice-qt

    ## Games
    # steam: see below
    prismlauncher
    ace-of-penguins

    ## Programming
    github-desktop
    vscode.fhs
    android-studio
    jetbrains.rider
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm-professional

    ## Debug / Utility
    libsForQt5.kmousetool
    wev
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}