{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # Setup the user account.
  home.username = "bean";
  home.homeDirectory = "/home/bean";

  home.stateVersion = "23.05";

  # Enable management of known folders
  xdg = {
    enable = true;
    userDirs = {enable = true;};
  };

  # Enable NuShell and setup some aliases
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

  # Enable starship for prompts
  programs.starship = {
    enable = true;
    settings = fromTOML (fileContents ./res/starship.toml);
  };

  programs = {
    # CLI Tools
    bat.enable = true;
    ripgrep.enable = true;
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    # Plasma
    plasma = {
      enable = true;

      configFile = {
        kdeglobals = {
            KDE = {
                LookAndFeelPackage = "Sweet-Ambar-Blue";
                Single-Click = false;
            };
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
        plasmarc = {Wallpapers.usersWallpapers = "${./res/pictures/background.jpg}";};
        kcminputrc = {Keyboard.NumLock = 1;};
        konsolerc = {"Desktop Entry".DefaultProfile = "Main.profile";};
        spectaclerc = {General.clipboardGroup="PostScreenshotCopyImage";};
      };
    };

    # GUI Apps
    chromium.enable = true;
    thunderbird = {
      enable = true;
      profiles.bean.isDefault = true;
    };
  };

  # Enable KDE Connect
  services.kdeconnect.enable = true;

  # Set the user profile picture to my cow
  home.file.".face.icon".source = ./res/pictures/cow.png;

  # Set my applet layouts and pictures
  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".text = replaceStrings ["~~BACKGROUND~~"] ["${./res/pictures/background.jpg}"] (fileContents ./res/plasma-org.kde.plasma.desktop-appletsrc);
  xdg.configFile."kscreenlockerrc".text = replaceStrings ["~~BACKGROUND~~"] ["${./res/pictures/background.jpg}"] (fileContents ./res/kscreenlockerrc);

  # Set Konsole profile
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

  xdg.configFile."kdeconnect/config".text = ''
    [General]
    name=b-pc-laptop
  '';

  # Set the default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["firefox.desktop" "chromium.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop" "chromium.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop" "chromium.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop" "chromium.desktop"];
      "x-scheme-handler/vscode" = ["code-url-handler.desktop"];
      "application/x-extension-htm" = ["firefox.desktop" "chromium.desktop"];
      "application/x-extension-html" = ["firefox.desktop" "chromium.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop" "chromium.desktop"];
      "application/x-extension-xht" = ["firefox.desktop" "chromium.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop" "chromium.desktop"];
      "application/xhtml+xml" = ["firefox.desktop" "chromium.desktop"];
      "application/pdf" = ["firefox.desktop" "chromium.desktop"];
      "inode/directory" = ["org.kde.dolphin.desktop"];
      "x-scheme-handler/mailto" = ["userapp-Thunderbird-WKLTC2.desktop"];
      "message/rfc822" = ["userapp-Thunderbird-WKLTC2.desktop"];
      "x-scheme-handler/mid" = ["userapp-Thunderbird-WKLTC2.desktop"];
      "text/plain" = ["org.kde.kate.desktop"];
      "x-scheme-handler/x-github-client" = ["github-desktop.desktop"];
      "x-scheme-handler/x-github-desktop-auth" = ["github-desktop.desktop"];
    };
  };
}
