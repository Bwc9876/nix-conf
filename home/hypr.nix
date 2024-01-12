{
  lib,
  hostName,
  system,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = hostName == "b-pc-tower";
    package = pkgs.hyprland;
    settings = let
      lockSuspend = "systemctl suspend";
    in {
      autogenerated = 0;
      monitor = [
        "HDMI-A-1,1920x1080,0x0,1"
        "DVI-D-1,1920x1080,1920x0,1"
        "eDP-1,2256x1504,0x0,1"
        ",preferred,auto,1"
      ];
      general = {
        border_size = 2;
        resize_on_border = true;
        "col.active_border" = "rgb(ff0000) rgb(ff9a00) rgb(d0de21) rgb(4fdc4a) rgb(3fdad8) rgb(2fc9e2) rgb(1c7fee) rgb(5f15f2) rgb(ba0cf8) rgb(fb07d9) 45deg";
      };
      decoration = {
        rounding = 10;
        drop_shadow = false;
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
      env = let
        hardwareCursors =
          if hostName == "b-pc-tower"
          then "1"
          else "0";
      in [
        "GTK_THEME,Sweet-Ambar-Blue:dark"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "GRIMBLAST_EDITOR,swappy -f "
        "WLR_NO_HARDWARE_CURSORS,${hardwareCursors}"
        "TERMINAL,footclient"
      ];
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "hyprctl setcursor Sweet-cursors 24"
        ''dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland && systemctl --user start wireplumber''
        "foot -s"
        "dolphin --daemon"
        "waybar"
        "wl-paste --watch bash ${../res/clipboard_middleman.sh}"
        "swaync"
        "swayosd-server"
        "${pkgs.swayidle}/bin/swayidle -w -C ${../computers/${hostName}/idleconfig}"
        "nm-applet"
        "${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 22:00"
        "playerctld"
        "[workspace 3] keepassxc /home/bean/Documents/Database.kdbx"
        "[workspace 1 silent] sleep 10; vencorddesktop"
        "sleep 20; syncthingtray"
      ];
      windowrulev2 = [
        "workspace 1 silent,class:(.*)vencorddesktop(.*),title:(.*)Vencord(.*)"
        "idleinhibit fullscreen,class:(.*),title:(.*)"
      ];
      bind = let
        powerMenu = "rofi -modi 'p:${pkgs.rofi-power-menu}/bin/rofi-power-menu' -show p --symbols-font \"FiraMono Nerd Font Mono\"";
        openTerminal = "footclient";
        screenshot = "nu ${../res/screenshot.nu}";
        forEachWorkspace = {
          mod,
          dispatch,
        }:
          builtins.genList (i: let
            num = builtins.toString i;
          in "${mod},${num},${dispatch},${
            if num == "0"
            then "10"
            else num
          }")
          10;
      in
        [
          "SUPER,S,exec,rofi -show drun -icon-theme \"candy-icons\" -show-icons"
          "SUPER SHIFT,E,exec,rofi -modi emoji -show emoji"
          "SUPER,Delete,exec,${powerMenu}"
          ",XF86PowerOff,exec,${powerMenu}"
          "SUPER ALT,C,exec,rofi -modi calc -show calc"
          "SUPER,I,exec,${pkgs.rofi-pulse-select}/bin/rofi-pulse-select source"
          "SUPER,O,exec,${pkgs.rofi-pulse-select}/bin/rofi-pulse-select sink"
          "SUPER,B,exec,${pkgs.rofi-bluetooth}/bin/rofi-bluetooth"
          "SUPER,grave,exec,${pkgs.callPackage ../pkgs/rofi-systemd.nix {}}/bin/rofi-systemd"
          "SUPER,D,exec,${pkgs.callPackage ../pkgs/rofi-code.nix {}}/bin/rofi-code"
          "SUPER,Tab,exec,rofi -show window -show-icons"
          "SUPER,Q,exec,firefox-devedition"
          "SUPER,E,exec,nu ${../res/rofi-places.nu}"
          "SUPER,Z,exec,${lockSuspend}"
          ",XF86AudioMedia,exec,${openTerminal}"
          "SUPER,T,exec,${openTerminal}"
          "SUPER,N,exec,swaync-client -t -sw"
          "SUPER,L,exec,swaylock"
          "SUPER,C,killactive,"
          "SUPER SHIFT,D,exec,code"
          "SUPER,V,exec,cliphist list | sed -r \"s|binary data image/(.*)|󰋩 Image (\\1)|g\" | rofi -dmenu -display-columns 2 -p Clipboard | cliphist decode | wl-copy"
          "SUPER ALT,V,exec,echo -e \"Yes\\nNo\" | [[ $(rofi -dmenu -mesg \"Clear Clipboard History?\" -p Clear) == \"Yes\" ]] && cliphist wipe"
          "SUPER,P,pseudo,"
          "SUPER,R,togglefloating,"
          "SUPER,F,fullscreen,1"
          "SUPER SHIFT,F,fullscreen,0"
          "SUPER ALT,F,fakefullscreen"
          "SUPER,J,togglesplit,"
          "SUPER,left,movefocus,l"
          "SUPER,right,movefocus,r"
          "SUPER,up,movefocus,u"
          "SUPER,down,movefocus,d"
          ",Print,exec,${screenshot}"
          "SUPER SHIFT,S,exec,${screenshot}"
          "SUPER SHIFT,C,exec,hyprpicker -a"
          ",XF86RFKill,exec,rfkill toggle wifi"
          ",Caps_Lock,exec,swayosd-client --caps-lock"
        ]
        ++ forEachWorkspace {
          mod = "SUPER";
          dispatch = "workspace";
        }
        ++ forEachWorkspace {
          mod = "SUPER SHIFT";
          dispatch = "movetoworkspace";
        };
      bindl = [
        ",switch:on:Lid Switch,exec,${lockSuspend}"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl pause"
        ",XF86AudioStop,exec,playerctl stop"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"
      ];
      bindr = [
        "SUPER SHIFT,R,exec,pkill wf-recorder --signal SIGINT || nu ${../res/screenrec.nu}"
      ];
      binde = [
        ",XF86AudioRaiseVolume,exec,swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume,exec,swayosd-client --output-volume lower"
        ",XF86AudioMute,exec,swayosd-client --output-volume mute-toggle"
        ",XF86MonBrightnessUp,exec,swayosd-client --brightness raise"
        ",XF86MonBrightnessDown,exec,swayosd-client --brightness lower"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
    };
  };
}
