{ config, lib, pkgs, ... }:

with lib;

{
  home.username = "bean";
  home.homeDirectory = "/home/bean";

  home.stateVersion = "23.05";

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
    };
  };

  programs.nushell = {
    enable = true;
    configFile.text = ''
	$env.config = { show_banner: false }
    '';
    envFile.text = ''
	alias py = python
	alias cat = bat
    '';
  };

  programs.starship = {
    enable = true;
    settings = fromTOML (fileContents ./starship.toml);
  };

  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
    
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

  home.file.".face.icon".source = ./cow.png;
  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source = ./plasma-org.kde.plasma.desktop-appletsrc;

  programs.plasma = {
    enable = true;

    configFile = {
      kdeglobals = {
        KDE.LookAndFeelPackage = "Sweet-Ambar-Blue";
      };
      kscreenlockerrc = {
#         Greeter.Wallpaper."org\.kde\.image".General = {
#           configGroupNesting = ""
#           Image = "${./background.jpg}";
#           PreviewImage = "${./background.jpg}";
#         };
      };
      kwinrc = {
        Plugins = {
          kwin4_effect_dimscreenEnabled = true;
          kwin4_effect_squashEnabled = false;
          magiclampEnabled = true;
          mouseclickEnabled = true;
          sheetEnabled = true;
          wobblywindowsEnabled = true;
        };
        Effect-wobblywindows = {
          Drag = 85;
          Stiffness = 10;
          WobblynessLevel = 1;
        };
        NightColor = {
          Active = true;
          NightTemperature = 3500;
        };
      };
      plasmarc = {
        Wallpapers.usersWallpapers = "${./background.jpg}";
      };
      kcminputrc = {
        Keyboard.NumLock = 1;
      };
    };
  };


  services.kdeconnect.enable = true;

}
