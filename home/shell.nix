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
        # src = pkgs.fetchFromGitHub {
        #   owner = "Zuruuh";
        #   repo = "zoxide";
        #   rev = "1809333be652be474d132da235cf9aad9a998b3d";
        #   sha256 = "sha256-itcGtLUVa60WSqerUNPHLK60D53cQRoLptpRg61rkxM=";
        # };
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
    # TODO: Fix colors
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
