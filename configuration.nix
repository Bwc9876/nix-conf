{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable firmware updating
  services.fwupd.enable = true;

  # Use the systemd-boot EFI boot loader with Plymouth for a fancy boot screen.
  boot = {
    loader.systemd-boot.enable = true;
    plymouth = {
      enable = true;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["angular"];
        })
      ];
      theme = "angular";
    };
  };

  # Bc I like pretty colors
  systemd.services.plymouth-quit = {
    preStart = "${pkgs.coreutils}/bin/sleep 3";
    # preStart = "${builtins.trace "evaluated!" pkgs.coreutils}/bin/sleep 3";
    # preStart = "${builtins.throw "aghhhhhhh"}/bin/sleep 3";
  };

  networking.hostName = "b-pc-laptop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set the time zone.
  time.timeZone = "America/New_York";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment with SDDM as the login manager.
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "Sweet-Ambar-Blue";
  };
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Setup some power saving features
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Enable fingerprint reader
  services.fprintd.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Use Nushell
  environment.shells = with pkgs; [nushell];
  users.defaultUserShell = pkgs.nushell;

  # Use FiraMono Nerd Font
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["FiraMono"];})];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bean = {
    isNormalUser = true;
    description = "Benjamin Crocker";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # Shell Stuff
    nushell

    # Useful CLI Tools
    neofetch
    wget
    just
    nix-output-monitor
    xorg.xkill

    # Apps
    firefox-devedition
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

    ## LibsForQt5
    libsForQt5.kdenlive
    libsForQt5.gwenview
    libsForQt5.kruler
    libsForQt5.kate
    libsForQt5.yakuake
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

    ## Python
    python3
    poetry
    pipenv
    black

    ## Rust
    cargo
    cargo-tauri
    mprocs
    vscode.fhs

    ## JavaScript
    nodejs
    nodePackages.pnpm
    yarn

    ## JetBrains
    jetbrains.rider
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm-professional

    # Custom
    (callPackage ./pkgs/kde-theming.nix {})
  ];

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
