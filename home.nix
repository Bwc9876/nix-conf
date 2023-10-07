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

  programs.chromium.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.bean.isDefault = true;
  };

  home.file.".face.icon".source = ./cow.png;

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
      konsolerc = {
        "Desktop Entry".DefaultProfile = "Main.profile";
      };
    };
  };

  xdg.dataFile."konsole/Main.profile".text = ''
    [Appearance]
    AntiAliasFonts=true
    BoldIntense=true
    ColorScheme=Sweet-Ambar-Blue
    Font=FiraMono Nerd Font Mono,12,-1,5,50,0,0,0,0,0
    LineSpacing=0
    UseFontLineChararacters=false

    [General]
    Command=nu
    DimWhenInactive=false
    Environment=TERM=konsole-256color,COLORTERM=truecolor
    InvertSelectionColors=false
    Name=Main
    Parent=FALLBACK/
  '';

  services.kdeconnect.enable = true;

  home.file.".gtkrc-2.0".text = ''
    gtk-theme-name="Sweet-Ambar-Blue"
    gtk-enable-animations=1
    gtk-primary-button-warps-slider=0
    gtk-toolbar-style=3
    gtk-menu-images=1
    gtk-button-images=1
    gtk-cursor-theme-size=24
    gtk-cursor-theme-name="Sweet-cursors"
    gtk-icon-theme-name="candy-icons"
    gtk-font-name="FiraMono Nerd Font Mono 12"

    gtk-modules=appmenu-gtk-module
  '';

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=true
    gtk-button-images=true
    gtk-cursor-theme-name=Sweet-cursors
    gtk-cursor-theme-size=24
    gtk-decoration-layout=icon:minimize,maximize,close
    gtk-enable-animations=true
    gtk-font-name=FiraMono Nerd Font Mono,  10
    gtk-icon-theme-name=candy-icons
    gtk-menu-images=true
    gtk-modules=colorreload-gtk-module:window-decorations-gtk-module:appmenu-gtk-module
    gtk-primary-button-warps-slider=false
    gtk-shell-shows-menubar=1
    gtk-theme-name=Sweet-Ambar-Blue
    gtk-toolbar-style=3
    gtk-xft-dpi=98304
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = '' 
    [Settings]
    gtk-application-prefer-dark-theme=true
    gtk-cursor-theme-name=Sweet-cursors
    gtk-cursor-theme-size=24
    gtk-decoration-layout=icon:minimize,maximize,close
    gtk-enable-animations=true
    gtk-font-name=FiraMono Nerd Font Mono,  10
    gtk-icon-theme-name=candy-icons
    gtk-primary-button-warps-slider=false
    gtk-xft-dpi=98304
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
        "text/html" = ["firefox.desktop" "chromium.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop" "chromium.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop" "chromium.desktop"];
        "x-scheme-handler/chrome" = ["firefox.desktop" "chromium.desktop"];
        "application/x-extension-htm" = ["firefox.desktop" "chromium.desktop"];
        "application/x-extension-html" = ["firefox.desktop" "chromium.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop" "chromium.desktop"];
        "application/x-extension-xht" = ["firefox.desktop" "chromium.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop" "chromium.desktop"];
        "application/xhtml+xml" = ["firefox.desktop" "chromium.desktop"];
        "application/pdf" = ["firefox.desktop" "chromium.desktop"];
        "inode/directory" = ["org.kde.dolphin.desktop"];
        "text/plain" = "org.kde.kate.desktop";
    };
  };

}
