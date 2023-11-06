{
  lib,
  system,
  inputs,
  pkgs,
}: {
  enable = true;
  package = inputs.hyprland.packages.${system}.hyprland;
  settings = let
    superAwesomeUltraMegaGayMode = false;
  in {
    autogenerated = 0;
    monitor = [
      ",2256x1504@60,0x0,1"
      ",preferred,auto,1"
    ];
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
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
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
      "kdeconnect-indicator"
      "[workspace 2] keepassxc /home/bean/Documents/Database.kdbx"
      "[workspace 1 silent] discord"
    ];
    windowrulev2 = [
      "workspace 1 silent,class:(.*)discord(.*),title:(.*)Discord(.*)"
      "idleinhibit fullscreen,class:(.*),title:(.*)"
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
      "SUPER,Tab,exec,rofi -show window -show-icons"
      "SUPER,Q,exec,firefox"
      "SUPER,E,exec,dolphin"
      ",XF86AudioMedia,exec,footclient"
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
      ",Print,exec,grimblast --freeze save area - | swappy -f -"
      "SUPER SHIFT,S,exec,grimblast --freeze save area - | swappy -f -"
      "SUPER SHIFT,R,exec,wl-screenrec -g \"$(slurp)\""
      "SUPER SHIFT,C,exec,hyprpicker"
      "SUPER SHIFT ALT,R,exec,wl-screenrec"
    ];
    bindl = [
      ",switch:Lid Switch,exec,gtklock"
      ",XF86AudioPlay,exec,playerctl play-pause"
      ",XF86AudioPause,exec,playerctl pause"
      ",XF86AudioStop,exec,playerctl stop"
      ",XF86AudioNext,exec,playerctl next"
      ",XF86AudioPrev,exec,playerctl previous"
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
      hyprbars-button = [
        "rgb(ff4040), 14, 󰅖, hyprctl dispatch killactive"
        "rgb(eeee11), 14, 󰖯, hyprctl dispatch fullscreen 1"
        "rgb(05bf9d), 14, 󰨦, hyprctl dispatch togglefloating"
        "rgba(00000000), 14, |,"
        "rgb(3374d6), 14, 󰁔, hyprctl dispatch swapnext"
        "rgb(3374d6), 14, , hyprctl dispatch swapnext prev"
        "rgba(00000000), 14, |,"
        "rgb(775e93), 14, 󱞤, hyprctl dispatch movetoworkspace e+1"
        "rgb(775e93), 14, 󱞢, hyprctl dispatch movetoworkspace e-1"
      ];
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
}
