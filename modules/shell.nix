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
      links2
      w3m
      rdrview
      htop
      nomino
      ventoy
      inputs.gh-grader-preview.packages.${system}.default

      ## Networking
      nmap
      dig
      dogdns
      inetutils
      speedtest-cli

      ## Mod Manager
      inputs.ow-mod-man.packages.${system}.owmods-cli

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
      (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      cargo-tauri
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
      dotnet-sdk
      dotnet-runtime
      dotnetPackages.Nuget
      mono

      ## Man Pages
      man-pages

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
