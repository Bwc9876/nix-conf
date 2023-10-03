# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
    loader.grub2-theme = {
      enable = true;
      theme = "whitesur";
      icon = "color";
    };
    plymouth = { 
      enable = true; 
      themePackages = with pkgs; [ (adi1090x-plymouth-themes.override {selected_themes = [ "angular" ]; }) ];
      theme = "angular";
    };
  };

  systemd.services.plymouth-quit = {
    preStart = "${pkgs.coreutils}/bin/sleep 3";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
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

  services.fwupd.enable = true;

  powerManagement.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.shells = with pkgs; [ nushell ];
  users.defaultUserShell = pkgs.nushell;

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraMono" ]; }) ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bean = {
    isNormalUser = true;
    description = "Benjamin Crocker";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.nushell;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    nushell
    wget
    obsidian
    keepassxc
    discord
    spotify
    libsForQt5.kdenlive
    libsForQt5.gwenview
    libsForQt5.kruler
    libsForQt5.kate
    libsForQt5.yakuake
    libsForQt5.filelight
    partition-manager
    qmplay2
    gimp
    inkscape
    libreoffice-qt
    peek
    just
    nix-output-monitor
    git
    github-desktop
    python3
    cargo
    nodejs
    nodePackages.pnpm
    yarn
    cargo-tauri
    vscode.fhs
    jetbrains.rider
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm-professional
    (callPackage ./pkgs/kde-theming.nix {})
  ];



  system.stateVersion = "23.05"; # Did you read the comment?


  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" "no-url-literals" "ca-derivations" "auto-allocate-uids" "cgroups" ];
      # TODO: Move url-literals, ca-derivations, & duplicate repl-flake in per-project flakes?

      # These need to be enable both in experimantal-options, and here
      auto-allocate-uids = true;
      use-cgroups = true;

      # Optimise the store when writing
      auto-optimise-store = true;

      # Disable global registry
      #flake-registry = ""; # TODO: pin? no impurity as long as I don't reference it in projects (probably)
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

}

