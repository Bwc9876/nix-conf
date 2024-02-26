{
  inputs,
  lib,
  system,
  pkgs,
  hostName,
  ...
}: {
  programs.hyprland = {
    enable = true;
    portalPackage = inputs.xdph.packages.${system}.default;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [inputs.xdph.packages.${system}.default];
  };

  services.flatpak.enable = true;

  # Theming
  environment.pathsToLink = [
    "/share/Kvantum"
    "/share/icons"
  ]; # Kvantum needs linking
  fonts = {
    packages = with pkgs; [(nerdfonts.override {fonts = ["FiraMono"];}) noto-fonts noto-fonts-color-emoji liberation_ttf];
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
  security.pam.services.swaylock.text = ''
    auth            sufficient      pam_unix.so try_first_pass likeauth nullok
    auth            sufficient      pam_fprintd.so
    auth            include         login
  ''; # Allow fingerprint auth

  services.syncthing = {
    enable = true;
    user = "bean";
    group = "users";
    dataDir = "/home/bean";

    openDefaultPorts = true;

    settings = {
      options = {
        urAccepted = 1;
      };
      folders = {
        "ObisidianVault" = {
          id = "wswsa6s-zewvd";
          enable = true;
          label = "Obsidian Vault";
          path = "~/Documents/Notes";
          devices = ["phone"];
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "120";
          };
        };
      };
      devices = {
        # Laptop id for when i setup desktop: 76GZ2RN-UX35UUQ-PRHEGJE-MORMEOY-7EC4M2S-YN34YEF-5QS44SW-MMZK5AE
        phone = {
          name = "Phone";
          id = "X7IARRX-PZBFNE3-TMSHIU2-JRMKW53-SVR2NMV-2JZSFBV-WW3THIN-QSD3HQF";
        };
      };
    };
  };

  # KDE Connect
  programs.kdeconnect.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    wrapperConfig = {
      pipeWireSupport = true;
    };
  };

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

    ### Syncthing tray
    syncthingtray-minimal

    ## Rofi
    rofi
    rofi-power-menu
    rofi-emoji
    rofi-bluetooth
    rofi-calc

    ## GTK Lock
    swaylock-effects
    swayidle # For locking when idle

    ## Clipboard
    (callPackage wl-clipboard.overrideAttrs {
      src = fetchFromGitHub {
        owner = "Bwc9876";
        repo = "wl-clipboard";
        rev = "bwc9876/x-kde-passwordManagerHint-sensitive";
        sha256 = "sha256-DD0efaKaqAMqp4KwQPwuKlNtGuHIXvfE0SBfTKSADOM=";
      };
    })
    cliphist

    ## Screenshot / Record
    wf-recorder
    slurp
    inputs.hyprland-contrib.packages.${system}.grimblast
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
    zoom-us
    udiskie

    ## General / Everyday
    obsidian # Needs `electron-25.9.0` (EOL, see flake.nix)
    keepassxc
    vesktop
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

    ## 3D
    prusa-slicer
    # blender
    # (callPackage renderdoc.overrideAttrs rec {
    #     version = "1.25";
    #     src = fetchFromGitHub {
    #         owner = "baldurk";
    #         repo = "renderdoc";
    #         rev = "v${version}";
    #         sha256 = "sha256-ViZMAuqbXN7upyVLc4arQy2EASHeoYViMGpCwZPEWuo=";
    #     };
    # })

    ## Office
    libreoffice-qt

    ## Games
    prismlauncher
    ace-of-penguins
    inputs.ow-mod-man.packages.${system}.owmods-gui
    (callPackage ../pkgs/olympus.nix {})

    ## Programming
    github-desktop
    vscode.fhs
    android-studio
    jetbrains.rider
    jetbrains.idea-ultimate
    java-language-server

    ## Debug / Utility
    libsForQt5.kmousetool
    wev
    flatpak-builder
    xcowsay
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
