{
  config,
  lib,
  pkgs,
  hostName,
  inputs,
  system,
  ...
}:
with lib; rec {
  home = {
    username = "bean";
    homeDirectory = "/home/bean";
    stateVersion = "23.05";
    file = {
      ".face".source = ./res/pictures/cow.png;
      ".gtkrc-2.0".source = ./res/gtk/.gtkrc-2.0;
    };
    activation = {
      createXDGFoldersAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p $HOME/Desktop
        mkdir -p $HOME/Documents
        mkdir -p $HOME/Pictures
        mkdir -p $HOME/Videos
        mkdir -p $HOME/Music
      '';
    };
  };

  # Enable management of known folders
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${home.homeDirectory}/Desktop";
      documents = "${home.homeDirectory}/Documents";
      pictures = "${home.homeDirectory}/Pictures";
      videos = "${home.homeDirectory}/Videos";
      music = "${home.homeDirectory}/Music";
    };
    configFile = {
      kdeglobals.text = ''
        [KDE]
        ShowDeleteCommand=false

        [General]
        TerminalApplication=footclient

        [KFileDialog Settings]
        Allow Expansion=false
        Automatically select filename extension=true
        Breadcrumb Navigation=true
        Decoration position=2
        LocationCombo Completionmode=5
        PathCombo Completionmode=5
        Show Bookmarks=false
        Show Full Path=false
        Show Inline Previews=true
        Show Preview=false
        Show Speedbar=true
        Show hidden files=false
        Sort by=Name
        Sort directories first=true
        Sort hidden files last=false
        Sort reversed=false
        Speedbar Width=196
        View Style=DetailTree

        [PreviewSettings]
        MaximumRemoteSize=0
      '';
      "qt5ct/qt5ct.conf".source = ./res/qt5ct.conf;
      waybar.source = ./res/waybar;
      "hyfetch.json".source = ./res/hyfetch.json;
      "gtk-3.0/settings.ini".source = ./res/gtk/settings.ini;
      "gtk-4.0/settings.ini".source = ./res/gtk/settings.ini;
      swaync.source = ./res/swaync;
      "swayidle/config".source = ./res/swayidle;
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Sweet-Ambar-Blue
      '';
      "gtklock/config.ini".text = ''
        [main]
        time-format=%I:%M %p
        gtk-theme=Sweet-Ambar-Blue
        background=${./res/pictures/background.jpg}
        idle-hide=true
        style=${./res/gtklock-style.css}
        start-hidden=true
        modules=/run/current-system/sw/lib/gtklock/userinfo-module.so

        [userinfo]
        vertical-layout=false
        under-clock=true
      '';
      "kdeconnect/config".text = ''
        [General]
        name=${hostName}
      '';
      "hypr/hyprpaper.conf".text = ''
        ipc = off
        preload = ${./res/pictures/background.jpg}
        wallpaper = eDP-1,${./res/pictures/background.jpg}
      '';
    };
    mimeApps = {
      enable = true;
      defaultApplications = let
        textEditors = ["code.desktop"];
        browsers = ["firefox.desktop" "chromium.desktop"];
        mailClients = ["userapp-Thunderbird-WKLTC2.desktop"];
        imageViewers = ["com.github.weclaw1.ImageRoll.desktop" "gimp.desktop"];
      in {
        "inode/directory" = ["org.kde.dolphin.desktop"];
        "text/plain" = textEditors;
        "text/markdown" = textEditors;
        "text/x-markdown" = textEditors;
        "text/x-readme" = textEditors;
        "text/x-changelog" = textEditors;
        "text/x-copying" = textEditors;
        "text/x-install" = textEditors;
        "text/html" = browsers;
        "image/png" = imageViewers;
        "image/jpeg" = imageViewers;
        "image/gif" = imageViewers;
        "image/bmp" = imageViewers;
        "image/x-portable-pixmap" = imageViewers;
        "image/x-portable-bitmap" = imageViewers;
        "image/x-portable-graymap" = imageViewers;
        "image/x-portable-anymap" = imageViewers;
        "image/svg+xml" = imageViewers;
        "x-terminal-emulator" = ["foot"];
        "x-scheme-handler/http" = browsers;
        "x-scheme-handler/https" = browsers;
        "x-scheme-handler/chrome" = browsers;
        "x-scheme-handler/vscode" = ["code-url-handler.desktop"];
        "x-scheme-handler/mailto" = mailClients;
        "x-scheme-handler/x-github-client" = ["github-desktop.desktop"];
        "x-scheme-handler/mid" = mailClients;
        "x-scheme-handler/x-github-desktop-auth" = ["github-desktop.desktop"];
        "application/x-extension-htm" = browsers;
        "application/x-extension-html" = browsers;
        "application/x-extension-shtml" = browsers;
        "application/x-extension-xht" = browsers;
        "application/x-extension-xhtml" = browsers;
        "application/xhtml+xml" = browsers;
        "application/pdf" = browsers;
        "message/rfc822" = mailClients;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    settings = let
      superAwesomeUltraMegaGayMode = false;
    in {
      autogenerated = 0;
      monitor = ",2256x1504@60,0x0,1";
      general = {
        border_size = 2;
        resize_on_border = true;
        "col.active_border" = "rgb(ff0000) rgb(ff9a00) rgb(d0de21) rgb(4fdc4a) rgb(3fdad8) rgb(2fc9e2) rgb(1c7fee) rgb(5f15f2) rgb(ba0cf8) rgb(fb07d9) 45deg";
      };
      decoration = {
        rounding = 10;
      };
      input = {
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
        };
      };
      gestures = {
        workspace_swipe = true;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      misc = {
        enable_swallow = true;
        swallow_regex = "^(footclient)$";
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };
      env = [
        "GTK_THEME,Sweet-Ambar-Blue:dark"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "IMAGE_EDITOR,/run/current-system/sw/bin/drawing"
      ];
      exec-once = [
        "hyprpaper"
        "hyprctl setcursor Sweet-cursors 24"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "foot -s"
        "waybar"
        "wl-paste -p --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swaync"
        "swayosd-server"
        "swayidle -w"
        "nm-applet"
        "playerctld"
        "[workspace 2] keepassxc /home/bean/Documents/Database.kdbx"
        "[workspace 1 silent] discord"
      ];
      windowrulev2 = [
        "workspace 1 silent,class:(.*)discord(.*),title:(.*)Discord(.*)"
      ];
      bind = [
        "SUPER,S,exec,rofi -show drun -icon-theme \"candy-icons\" -show-icons"
        "SUPER SHIFT,E,exec,rofi -modi emoji -show emoji"
        "SUPER,Delete,exec,rofi -modi 'p:rofi-power-menu' -show p --symbols-font \"FiraMono Nerd Font Mono\""
        ",XF86PowerOff,exec,rofi -modi 'p:rofi-power-menu' -show p --symbols-font \"FiraMono Nerd Font Mono\""
        "SUPER ALT,C,exec,rofi -modi calc -show calc"
        "SUPER,I,exec,rofi-pulse-select source"
        "SUPER,O,exec,rofi-pulse-select sink"
        "SUPER,B,exec,rofi-bluetooth"
        "SUPER,grave,exec,rofi-systemd"
        "SUPER,D,exec,rofi-code"
        "SUPER,Q,exec,firefox"
        "SUPER,E,exec,dolphin"
        "SUPER,T,exec,footclient"
        "SUPER,N,exec,swaync-client -t -sw"
        "SUPER,L,exec,gtklock"
        "SUPER,C,killactive,"
        "SUPER SHIFT,D,exec,code"
        "SUPER,V,exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy,"
        "SUPER,P,pseudo,"
        "SUPER,R,togglefloating,"
        "SUPER,F,fullscreen,1"
        "SUPER SHIFT,F,fullscreen,0"
        "SUPER,J,togglesplit,"
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        "SUPER,9,workspace,9"
        "SUPER,0,workspace,10"
        "SUPER SHIFT,1,movetoworkspace,1"
        "SUPER SHIFT,2,movetoworkspace,2"
        "SUPER SHIFT,3,movetoworkspace,3"
        "SUPER SHIFT,4,movetoworkspace,4"
        "SUPER SHIFT,5,movetoworkspace,5"
        "SUPER SHIFT,6,movetoworkspace,6"
        "SUPER SHIFT,7,movetoworkspace,7"
        "SUPER SHIFT,8,movetoworkspace,8"
        "SUPER SHIFT,9,movetoworkspace,9"
        "SUPER SHIFT,0,movetoworkspace,10"
        "SUPER SHIFT,S,exec,grimblast --freeze save area - | swappy -f -"
        "SUPER SHIFT,R,exec,wl-screenrec -g \"$(slurp)\""
        "SUPER SHIFT,C,exec,hyprpicker"
        "SUPER SHIFT ALT,R,exec,wl-screenrec"
      ];
      bindl = [
        ",switch:Lid Switch,exec,gtklock"
      ];
      binde = [
        ",XF86AudioRaiseVolume,exec,swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume,exec,swayosd-client --output-volume lower"
        ",XF86AudioMute,exec,swayosd-client --output-volume mute-toggle"
        ",XF86MonBrightnessUp,exec,swayosd-client --brightness raise"
        ",XF86MonBrightnessDown,exec,swayosd-client --brightness lower"
      ];
      bindr = [
        ",Caps_Lock,exec,swayosd-client --caps-lock"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
      "plugin:hyprbars" = {
        bar_height = 30;
        bar_text_size = 10;
        buttons = {
          button_size = 14;
        };
      };
      "plugin:borders-plus-plus" = lib.mkIf superAwesomeUltraMegaGayMode {
        add_borders = 9;
        "col.border_1" = "rgb(ff9a00)";
        "col.border_2" = "rgb(d0de21)";
        "col.border_3" = "rgb(4fdc4a)";
        "col.border_4" = "rgb(3fdad8)";
        "col.border_5" = "rgb(2fc9e2)";
        "col.border_6" = "rgb(1c7fee)";
        "col.border_7" = "rgb(5f15f2)";
        "col.border_8" = "rgb(ba0cf8)";
        "col.border_9" = "rgb(fb07d9)";
      };
    };
    plugins = [
      inputs.hyprland-plugins.packages.${system}.borders-plus-plus
      inputs.hyprland-plugins.packages.${system}.hyprbars
    ];
  };

  programs = {
    # Shell
    starship = {
      enable = true;
      settings = fromTOML (fileContents ./res/starship.toml);
    };

    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = { show_banner: false }
      '';
      envFile.text = ''
        alias py = python
        alias cat = bat
        alias neofetch = hyfetch
        alias screensaver = pipes-rs -k curved -p 10 --fps 30
        alias hyperctl = hyprctl
        alias hyprland = Hyprland
        alias hyperland = hyprland
      '';
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      location = "center";
      theme = ./res/rofi-style.rasi;
      plugins = with pkgs; [
        rofi-emoji
        rofi-power-menu
        rofi-bluetooth
        rofi-calc
        rofi-pulse-select
      ];
    };

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

    foot = {
      enable = true;
      settings = {
        main = {
          title = "Terminal (Foot)";
          font = "monospace:size=16";
        };
        bell = {
          visual = true;
        };
        cursor = {
          style = "beam";
          blink = true;
        };
        colors = {
          background = "101013";
          foreground = "fcfcfc";
          regular0 = "444a4c";
          bright0 = "444a4c";
          dim0 = "444a4c";
          regular1 = "ed254e";
          bright1 = "ed254e";
          dim1 = "ed254e";
          regular2 = "71f79f";
          bright2 = "71f79f";
          dim2 = "71f79f";
          regular3 = "fadd00";
          bright3 = "fadd00";
          dim3 = "fadd00";
          regular4 = "0072ff";
          bright4 = "0072ff";
          dim4 = "0072ff";
          regular5 = "d400dc";
          bright5 = "d400dc";
          dim5 = "d400dc";
          regular6 = "00c1e4";
          bright6 = "00c1e4";
          dim6 = "00c1e4";
          regular7 = "fcfcfc";
          bright7 = "fcfcfc";
          dim7 = "fcfcfc";
        };
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
  services = {
    kdeconnect.enable = true;
  };
}
