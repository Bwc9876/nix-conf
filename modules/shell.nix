{
  pkgs,
  inputs,
  ...
}: {
  users.users.bean.shell = pkgs.nushell;

  environment = {
    shells = with pkgs; [nushell];
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      # NuShell
      nushell

      # Tools
      neofetch
      hyfetch
      lolcat
      wget
      jq
      file
      perl536Packages.TextLorem
      cowsay
      toilet
      pipes-rs
      brightnessctl
      playerctl
      libnotify

      ## Networking
      nmap
      dig
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
    ];
  };

  programs = {
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
    ssh.startAgent = true;
  };
}
