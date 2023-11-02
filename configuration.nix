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
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernelPackages = pkgs.linuxPackages_latest;
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
    hostName = lib.toUpper hostName;
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
  };

  services = {
    accounts-daemon.enable = true;
    logind.powerKey = "ignore";
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting \"Authenticate into ${lib.toUpper hostName}\" --time --cmd Hyprland";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    printing.enable = true;
    fwupd.enable = true;
  };

  # Use FiraMono Nerd Font
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
        commit.gpgSign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsVzdJra+x5aEuwTjL1FBOiMh9bftvs8QwsM1xyEbdd bean@b-pc-laptop";
        advice = {
          addIgnoredFile = false;
        };
        gpg.format = "ssh";
      };
    };
    ssh = {
      startAgent = true;
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
      wev
      hyprpicker
      hyprpaper
      swaynotificationcenter
      (callPackage ./pkgs/swayosd.nix {})

      ## Waybar
      inputs.waybar.packages.${system}.waybar
      qt6.qttools

      ## Theming
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      (callPackage ./pkgs/theming.nix {})
      gnome.adwaita-icon-theme # For fallback

      ## Screenshot/Record
      wl-screenrec
      slurp
      grimblast
      swappy

      ## GTK Lock
      gtklock
      gtklock-userinfo-module
      swayidle # For locking when idle

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
      (callPackage ./pkgs/rofi-code.nix {})
      (callPackage ./pkgs/rofi-systemd.nix {})

      # Useful CLI Tools
      neofetch
      hyfetch
      lolcat
      wget
      jq
      xorg.xkill
      cowsay
      xcowsay
      toilet
      pipes-rs
      brightnessctl
      playerctl
      libnotify
      file
      perl536Packages.TextLorem

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
      qmplay2
      gimp
      inkscape
      libreoffice-qt
      github-desktop
      prismlauncher
      virtualbox
      lorien
      tuxpaint
      networkmanagerapplet
      image-roll

      ## Mod Manager
      inputs.ow-mod-man.packages.${system}.owmods-cli
      #   inputs.ow-mod-man.packages.${system}.owmods-gui

      ## LibsForQt5
      libsForQt5.dolphin
      libsForQt5.kdenlive
      libsForQt5.filelight
      libsForQt5.ark
      libsForQt5.kmousetool

      ## Games
      ace-of-penguins

      # Programming
      git
      vscode.fhs

      ## Android
      android-tools
      android-studio

      ## Python
      python3
      python311Packages.django
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

      ## .NET
      mono

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

  home-manager.extraSpecialArgs = {
    hostName = hostName;
    inputs = inputs;
    system = system;
  };

  nixpkgs.config = {
    allowUnfree = true;
    overlays = [
      inputs.hyprland.overlays.default
      inputs.waybar.overalys.default
    ];
  };

  system.stateVersion = "23.05";

  nix = {
    registry.p.flake = inputs.self;
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      nix-path = "nixpkgs=${inputs.nixpkgs}";
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
