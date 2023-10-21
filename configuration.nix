{
  lib,
  config,
  pkgs,
  hostName,
  ags,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./computers/${hostName}/hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernelPatches = [
      {
        name = "kernel-lockdown";
        patch = null;
        extraConfig = ''
          SECURITY_LOCKDOWN_LSM y
          MODULE_SIG y
        '';
      }
    ];
    kernelParams = ["lockdown=confidentiality"];
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };

  # Set the time zone.
  time.timeZone = "America/New_York";

  # Enable sound with pipewire.
  sound.enable = true;

  services = {
    logind.powerKey = "ignore";
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting \"Authenticate into ${hostName}\" --time --cmd ${pkgs.hyprland}/bin/Hyprland";
          user = "bean";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    fwupd.enable = true;
  };

  # Use FiraMono Nerd Font
  fonts = {
    packages = with pkgs; [(nerdfonts.override {fonts = ["FiraMono"];}) noto-fonts-color-emoji];
    fontconfig = {
      enable = true;
      defaultFonts = rec {
        serif = ["FiraMono Nerd Font Mono" "Noto Color Emoji"];
        sansSerif = serif;
        monospace = serif;
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.bean = {
      isNormalUser = true;
      description = "Benjamin Crocker";
      extraGroups = ["networkmanager" "wheel" "video"];
      shell = pkgs.nushell;
    };
    defaultUserShell = pkgs.nushell;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        advice = {
          addIgnoredFile = false;
        };
      };
    };
    hyprland = {
      enable = true;
    };
  };

  environment = {
    pathsToLink = [
      "/share/Kvantum"
      "/share/icons"
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [nushell];
    systemPackages = with pkgs; [
      # Shell Stuff
      nushell

      # Hyprland Stuff
      hyprland
      xdg-desktop-portal-hyprland
      wev
      waybar
      hyprpicker
      hyprpaper
      swaynotificationcenter
      libsForQt5.polkit-kde-agent
      (callPackage ./pkgs/swayosd.nix {})

      ## Theming
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      (callPackage ./pkgs/theming.nix {})

      ## Screenshot/Record
      wl-screenrec
      slurp
      grimblast

      ## GTK Lock
      gtklock
      gtklock-userinfo-module

      ## Clipboard
      wl-clipboard
      cliphist

      ## Rofi
      rofi
      rofi-emoji
      rofi-power-menu
      rofi-bluetooth
      rofi-calc
      rofi-pulse-select

      # Useful CLI Tools
      neofetch
      hyfetch
      lolcat
      wget
      xorg.xkill
      cowsay
      xcowsay
      toilet
      pipes-rs
      brightnessctl
      playerctl
      libnotify

      # Networking
      nmap
      dig
      inetutils
      speedtest-cli

      # Apps
      drawing
      firefox-devedition
      font-manager
      obsidian
      keepassxc
      discord
      spotify
      partition-manager
      qmplay2
      gimp
      inkscape
      libreoffice-qt
      peek
      github-desktop
      prismlauncher
      virtualbox
      lorien
      tuxpaint
      veusz
      networkmanagerapplet

      ## LibsForQt5
      libsForQt5.dolphin
      libsForQt5.kdenlive
      libsForQt5.gwenview
      libsForQt5.kruler
      libsForQt5.kate
      libsForQt5.filelight
      libsForQt5.ark
      libsForQt5.booth
      libsForQt5.kmousetool
      libsForQt5.kolourpaint
      libsForQt5.soundkonverter
      libsForQt5.kcalc

      ## Games
      libsForQt5.kmines
      libsForQt5.kolf
      libsForQt5.klines
      libsForQt5.ksudoku
      libsForQt5.kbreakout
      libsForQt5.kmahjongg
      ace-of-penguins

      # Programming
      git
      vscode.fhs

      ## Android
      android-tools
      android-studio

      ## Python
      python3
      poetry
      pipenv
      black

      ## Rust
      rustc
      cargo
      cargo-tauri
      rustfmt
      clippy
      mprocs
      rust-analyzer

      ## JavaScript
      nodejs
      nodePackages.pnpm
      yarn

      ## C/C++
      gcc

      ## JetBrains
      jetbrains.rider
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.pycharm-professional

      ## Build Tools
      pkg-config
      just
      nix-output-monitor
      gnumake
    ];
  };

  # TODO: Remove this eventually
  # Use legacy renegotiation for wpa_supplicant because some things are silly geese
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
  '';

  security = {
    pam.services.gtklock.text = ''
      auth            sufficient      pam_unix.so try_first_pass likeauth nullok
      auth            sufficient      pam_fprintd.so
      auth            include         login
    '';
    rtkit.enable = true;
  };

  home-manager.extraSpecialArgs.hostName = hostName;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
        "no-url-literals"
        "ca-derivations"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
