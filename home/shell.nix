{
  pkgs,
  lib,
  ...
}: {
  programs = {
    command-not-found.enable = false;
    nix-index.enable = true;
    zoxide = {
      enable = true;
      package = pkgs.callPackage pkgs.zoxide.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "ajeetdsouza";
          repo = "zoxide";
          rev = "3022cf3686b85288e6fbecb2bd23ad113fd83f3b";
          sha256 = "sha256-ut+/F7cQ5Xamb7T45a78i0mjqnNG9/73jPNaDLxzAx8=";
        };
      };
    };
    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = fromTOML (lib.fileContents ../res/starship.toml);
    };
    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
      };
      extraPackages = with pkgs.bat-extras; [prettybat batdiff batman batgrep batwatch];
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
