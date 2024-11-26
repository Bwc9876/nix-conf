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
    #systemd.setPath.enable = true;
  };

  catppuccin = {
    enable = true;
    accent = "green";
    flavor = "mocha";
  };

  services.flatpak.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Theming
  environment.pathsToLink = [
    "/share/Kvantum"
    "/share/icons"
  ]; # Kvantum needs linking
  fonts = {
    packages = with pkgs; [(nerdfonts.override {fonts = ["FiraCode"];}) noto-fonts noto-fonts-color-emoji liberation_ttf];
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        serif = ["Noto Sans" "FiraCode Nerd Font" "Noto Color Emoji"];
        sansSerif = serif;
        monospace = ["FiraCode Nerd Font Mono" "Noto Color Emoji"];
        emoji = ["FiraCode Nerd Font" "Noto Color Emoji"];
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

  #   services.syncthing = {
  #     enable = true;
  #     user = "bean";
  #     group = "users";
  #     dataDir = "/home/bean";

  #     openDefaultPorts = true;

  #     settings = {
  #       options = {
  #         urAccepted = 1;
  #       };
  #       folders = {
  #         "ObisidianVault" = {
  #           id = "wswsa6s-zewvd";
  #           enable = true;
  #           label = "Obsidian Vault";
  #           path = "~/Documents/Notes";
  #           devices = ["phone"];
  #           versioning = {
  #             type = "trashcan";
  #             params.cleanoutDays = "120";
  #           };
  #         };
  #       };
  #       devices = {
  #         # Laptop id for when i setup desktop: 76GZ2RN-UX35UUQ-PRHEGJE-MORMEOY-7EC4M2S-YN34YEF-5QS44SW-MMZK5AE
  #         phone = {
  #           name = "Phone";
  #           id = "X7IARRX-PZBFNE3-TMSHIU2-JRMKW53-SVR2NMV-2JZSFBV-WW3THIN-QSD3HQF";
  #         };
  #       };
  #     };
  #   };

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
    # Shell Components
    hyprlock
    swaynotificationcenter
    swayosd

    qt6.qttools # For component

    ### Syncthing tray
    # syncthingtray-minimal

    ## Clipboard
    (callPackage wl-clipboard.overrideAttrs {
      src = fetchFromGitHub {
        owner = "Bwc9876";
        repo = "wl-clipboard";
        rev = "bwc9876/x-kde-passwordManagerHint-sensitive";
        sha256 = "sha256-DD0efaKaqAMqp4KwQPwuKlNtGuHIXvfE0SBfTKSADOM=";
      };
    })
    (callPackage cliphist.overrideAttrs {
      src = fetchFromGitHub {
        owner = "sentriz";
        repo = "cliphist";
        rev = "8c48df70bb3d9d04ae8691513e81293ed296231a";
        sha256 = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
      };
      vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
    })

    wf-recorder
    slurp
    grim
    xdg-utils
    grimblast
    swappy

    # Theming
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    (callPackage ../pkgs/theming.nix {}) # Custom themes
    adwaita-icon-theme # For fallback icons

    # Applications
    xcowsay

    ## System Management / Monitoring
    libsForQt5.filelight
    networkmanagerapplet
    pavucontrol
    zoom-us
    udiskie
    inputs.wayland-mpris-idle-inhibit.packages.${system}.default

    ## General / Everyday
    # obsidian # Needs `electron-25.9.0` (EOL, see flake.nix)
    keepassxc
    vesktop
    chromium
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
    eog

    ## 3D
    prusa-slicer
    # (callPackage renderdoc.overrideAttrs rec {
    #     version = "1.25";
    #     src = fetchFromGitHub {
    #         owner = "baldurk";
    #         repo = "renderdoc";
    #         rev = "v${version}";
    #         sha256 = "sha256-ViZMAuqbXN7upyVLc4arQy2EASHeoYViMGpCwZPEWuo=";
    #     };
    # })

    ## Music
    shortwave

    ## Office
    libreoffice-qt

    ### Spell Check
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_US-large

    ## VNC
    novnc
    (writeScriptBin "ssh-vnc" (lib.readFile ../res/ssh-vnc.nu))

    ## Games
    prismlauncher
    ace-of-penguins
    inputs.ow-mod-man.packages.${system}.owmods-gui
    # (callPackage ../pkgs/olympus.nix {})

    ## Programming
    github-desktop

    ## Debug / Utility
    libsForQt5.kmousetool
    wev
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
