{
  pkgs,
  lib,
  ...
}: {
  programs = {
    command-not-found.enable = false;
    nix-index.enable = true;
    zoxide.enable = true;
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
