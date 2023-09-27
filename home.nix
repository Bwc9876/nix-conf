{ config, lib, pkgs, ... }:

with lib;

{
 
  home.username = "bean";
  home.homeDirectory = "/home/bean";

  home.stateVersion = "23.05";

  programs.nushell = {
    enable = true;
    configFile.text = ''
	$env.config = { show_banner: false }
    '';
    envFile.text = ''
	alias py = python
	alias cat = bat
	alias gorp = cd /etc/nixos
    '';
  };

  programs.starship = {
    enable = true;
    settings = fromTOML (fileContents ./starship.toml);
  };

  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  programs.git = {
    enable = true;
    userName = "Ben C";
    userEmail = "bwc9876@gmail.com";
  };

  programs.gh.enable = true;
    
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  
  programs.firefox = {
    enable = true;
  };

  programs.chromium.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.bean.isDefault = true;
  };

  services.kdeconnect.enable = true;

}
