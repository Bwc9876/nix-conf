{
  inputs,
  lib,
  system,
  pkgs,
  hostName,
  ...
}: {
  imports = [
    ../modules/networking.nix
    ../modules/audio.nix
    ../modules/nix.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
    initrd.supportedFilesystems = ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

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

  services.kmscon = {
    enable = true;
    autologinUser = "nixos";
    fonts = [
      {
        name = "FiraMono Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["FiraMono"];};
      }
    ];
  };

  networking.wireless.enable = false;

  time.timeZone = "America/New_York";

  # virtualisation.virtualbox.guest.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nixos = {
      imports = [./home.nix];
      home = {
        file.nix-conf.source = inputs.self;
        username = "nixos";
        homeDirectory = "/home/nixos";
        stateVersion = "23.05";
      };
    };
    users.root = {
      imports = [./home.nix];
      home = {
        username = "root";
        homeDirectory = "/root";
        stateVersion = "23.05";
      };
    };
    extraSpecialArgs = {
      inherit hostName inputs system;
    };
  };

  users.users.nixos = {
    shell = pkgs.nushell;
    extraGroups = ["networkmanager" "video"];
  };

  users.users.root = {
    shell = pkgs.nushell;
  };

  environment = {
    shells = with pkgs; [nushell fish];
    variables = {
      EDITOR = "nvim";
      COMMA_NIXPKGS_FLAKE = "p";
    };
    systemPackages = with pkgs; [
      inputs.nix-index-database.packages.${system}.comma-with-db
      neofetch
      hyfetch
      lolcat
      wget
      cowsay
      toilet
      gay
      pipes-rs
      htop
      nomino
      nmap
      dig
      inetutils
      speedtest-cli
      just
      nix-output-monitor
      python3
      mprocs
      libqalculate
      cage
      gptfdisk
      util-linux
      (writeScriptBin "installer-check" (lib.readFile ../res/installer/banner.nu))
      (writeScriptBin "installer-disks" (lib.readFile ../res/installer/disks.nu))
    ];
  };

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          email = "bwc9876@gmail.com";
          name = "Ben C";
        };
        advice = {
          addIgnoredFile = false;
        };
      };
    };
  };
}
