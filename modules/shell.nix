{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  users.users.bean.shell = pkgs.nushell;

  programs = {
    command-not-found.enable = false; # Replaced with my own nushell script (../res/command_not_found.nu)
    fish.enable = true; # For completions
  };

  environment = {
    shells = with pkgs; [nushell fish];
    variables = {
      EDITOR = "nvim";
      COMMA_NIXPKGS_FLAKE = "p";
    };
    systemPackages = with pkgs; [
      # NuShell
      nushell

      # Tools
      inputs.nix-index-database.packages.${system}.comma-with-db
      neofetch
      hyfetch
      lolcat
      wget
      jq
      file
      perl536Packages.TextLorem
      cowsay
      toilet
      gay
      pipes-rs
      brightnessctl
      playerctl
      libnotify
      gh
      nomino
      inputs.gh-grader-preview.packages.${system}.default

      ## Networking
      nmap
      dig
      inetutils
      speedtest-cli

      ## Mod Manager
      owmods-cli

      ## Build Tools
      pkg-config
      just
      nix-output-monitor
      gnumake

      ## Android
      android-tools

      ## Python
      python3
      python311Packages.django
      # poetry
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
      evcxr

      ## Java
      jdk

      ## JavaScript
      nodejs
      nodePackages.pnpm
      yarn

      ## C/C++
      gcc

      ## .NET
      mono

      ## Math
      libqalculate
    ];
  };

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        commit.gpgSign = true;
        user = {
          email = "bwc9876@gmail.com";
          name = "Ben C";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsVzdJra+x5aEuwTjL1FBOiMh9bftvs8QwsM1xyEbdd bean@b-pc-laptop";
        };
        advice = {
          addIgnoredFile = false;
        };
        gpg.format = "ssh";
      };
    };
    ssh.startAgent = true;
    starship = {
      enable = true;
      settings = fromTOML (lib.fileContents ../res/starship.toml);
    };
  };
}
