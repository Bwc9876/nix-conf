{
  lib,
  hostName,
  system,
  inputs,
  pkgs,
  ...
}: let
  sunsetCmd = "${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 22:00";
  screenOffCmd = "hyprctl dispatch dpms off; swaync-client --inhibitor-add \"timeout\"; pkill wlsunset;";
  screenOnCmd = "hyprctl dispatch dpms on; swaync-client --inhibitor-remove \"timeout\"; ${sunsetCmd};";
in {
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        unlock_cmd = pkill hyprlock --signal SIGUSR1
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 120
        on-timeout = loginctl lock-session
    }

    listener {
        timeout = 300
        on-timeout = ${screenOffCmd}
        on-resume = ${screenOnCmd}
    }

    listener {
        timeout = 600
        on-timeout = systemctl suspend
    }
  '';
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        grace = 5
    }

    background {
        monitor =
        path = ${../res/pictures/background.png}
        blur_passes = 1
    }

    image {
        monitor =
        path = ${../res/pictures/cow.png}
        size = 150
        rounding = -1
        border_size = 2
        border_color = rgb(109, 237, 153)
        rotate = 0
        position = 0, 120
        halign = center
        valign = center

        shadow_passes = 1
        shadow_size = 5
        shadow_boost = 1.6
    }

    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 2
        dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = false
        dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
        outer_color = rgb(150, 150, 150)
        inner_color = rgb(16, 16, 19)
        font_color = rgb(255, 255, 255)
        fade_on_empty = false
        fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
        placeholder_text = <span foreground="##dddddd" style="italic">Password</span>
        hide_input = false
        rounding = -1 # -1 means complete rounding (circle/oval)
        check_color = rgb(15, 219, 255)
        fail_color = rgb(237, 37, 78) # if authentication failed, changes outer_color and fail message color
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
        fail_transition = 300 # transition time in ms between normal outer_color and fail_color
        capslock_color = -1
        numlock_color = -1
        bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false # change color if numlock is off
        swap_font_color = false # see below

        position = 0, -80
        halign = center
        valign = center
    }

    label {
        monitor =
        text = $DESC
        color = rgba(255, 255, 255, 1.0)
        font_size = 25
        font_family = sans-serif
        rotate = 0 # degrees, counter-clockwise

        position = 0, 0
        halign = center
        valign = center

        shadow_passes = 1
        shadow_size = 5
        shadow_boost = 1.6
    }

    label {
        monitor =
        text = cmd[update:30000] echo "$(date +"%A, %B %-d | %I:%M %p") | $(nu ${../res/bat_display.nu})"
        color = rgba(255, 255, 255, 1.0)
        font_size = 20
        font_family = sans-serif
        rotate = 0 # degrees, counter-clockwise

        position = 0, -40
        halign = center
        valign = top

        shadow_passes = 1
        shadow_size = 5
        shadow_boost = 1.6
    }
  '';
  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = hostName == "b-pc-tower";
    package = pkgs.hyprland;
    systemd.variables = ["--all"];
    extraConfig = ''
      bind = SUPER,M,submap,passthru
      submap = passthru
      bind = SUPER,ESCAPE,submap,reset
      submap = reset
    '';
    settings = {
      autogenerated = 0;
      monitor = [
        "HDMI-A-1,1920x1080,0x0,1"
        "DVI-D-1,1920x1080,1920x0,1"
        "eDP-1,2256x1504,0x0,1,bitdepth,10"
        ",highres,auto,1"
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
      #   debug = {
      #     disable_logs = false;
      #   };
      misc = {
        enable_swallow = true;
        # swallow_regex = "^(foot)$";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      env = let
        cursorSize = "24";
        hardwareCursors =
          if hostName == "b-pc-tower"
          then "1"
          else "0";
      in [
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "HYPRCURSOR_THEME,Sweet-cursors-hypr"
        "HYPRCURSOR_SIZE,${cursorSize}"
        "XCURSOR_THEME,Sweet-cursors"
        "XCURSOR_SIZE,${cursorSize}"
        "GRIMBLAST_EDITOR,swappy -f "
        "WLR_NO_HARDWARE_CURSORS,${hardwareCursors}"
        "TERMINAL,foot"
      ];
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.hypridle}/bin/hypridle"
        ''dconf write /org/gnome/desktop/interface/cursor-theme "Sweet-cursors"''
        ''dconf write /org/gnome/desktop/interface/icon-theme "candy-icons"''
        ''dconf write /org/gnome/desktop/interface/gtk-theme "Sweet-Ambar-Blue:dark"''
        "dolphin --daemon"
        "waybar"
        "wl-paste --watch bash ${../res/clipboard_middleman.sh}"
        "swaync"
        "swayosd-server"
        "nm-applet"
        sunsetCmd
        "udiskie -A -f dolphin"
        ''wayland-mpris-idle-inhibit --ignore "kdeconnect" --ignore "playerctld"''
        "playerctld"
        "[workspace 3] keepassxc /home/bean/Documents/Database.kdbx"
        "[workspace 1 silent] sleep 10; vesktop"
      ];
      windowrulev2 = [
        "workspace 1 silent,class:(.*)vesktop(.*),title:(.*)[Vv]esktop(.*)"
        "idleinhibit fullscreen,class:(.*),title:(.*)"
      ];
      submap = "reset";
      bind = let
        powerMenu = "rofi -modi 'p:${pkgs.rofi-power-menu}/bin/rofi-power-menu' -show p --symbols-font \"FiraMono Nerd Font Mono\"";
        openTerminal = "foot";
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
          "SUPER,M,submap,passthru"
          "SUPER,S,exec,rofi -show drun -icon-theme \"candy-icons\" -show-icons"
          "SUPER SHIFT,E,exec,rofi -modi emoji -show emoji"
          "SUPER,Delete,exec,${powerMenu}"
          ",XF86PowerOff,exec,${powerMenu}"
          "SUPER ALT,C,exec,rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\""
          "SUPER,I,exec,${pkgs.rofi-pulse-select}/bin/rofi-pulse-select source"
          "SUPER,O,exec,${pkgs.rofi-pulse-select}/bin/rofi-pulse-select sink"
          "SUPER,B,exec,${pkgs.rofi-bluetooth}/bin/rofi-bluetooth"
          "SUPER,grave,exec,${pkgs.callPackage ../pkgs/rofi-systemd.nix {}}/bin/rofi-systemd"
          "SUPER,D,exec,${pkgs.callPackage ../pkgs/rofi-code.nix {}}/bin/rofi-code"
          "SUPER,Tab,exec,rofi -show window -show-icons"
          "SUPER,Q,exec,firefox-devedition"
          "SUPER,E,exec,nu ${../res/rofi-places.nu}"
          "SUPER SHIFT,T,exec,nu ${../res/rofi-zoxide.nu}"
          "SUPER,Z,exec,systemctl suspend"
          ",XF86AudioMedia,exec,${openTerminal}"
          "SUPER,T,exec,${openTerminal}"
          "SUPER,N,exec,swaync-client -t -sw"
          "SUPER,A,exec,pavucontrol --tab 5"
          "SUPER,L,exec,pidof hyprlock || hyprlock --immediate"
          "SUPER ALT CTRL SHIFT,L,exec,xdg-open https://linkedin.com"
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
          "SUPER,G,togglegroup"
          "SUPER SHIFT,G,lockactivegroup, toggle"
          "SUPER,TAB,changegroupactive"
          "SUPER SHIFT,TAB,changegroupactive,b"
          ",Print,exec,${screenshot}"
          "SUPER SHIFT,S,exec,${screenshot}"
          "SUPER SHIFT,C,exec,${pkgs.hyprpicker}/bin/hyprpicker -a"
          ",XF86RFKill,exec,rfkill toggle wifi"
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
        ",switch:on:Lid Switch,exec,${screenOffCmd}"
        ",switch:off:Lid Switch,exec,${screenOnCmd}"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl pause"
        ",XF86AudioStop,exec,playerctl stop"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"
      ];
      bindr = [
        "SUPER SHIFT,R,exec,pkill wf-recorder --signal SIGINT || nu ${../res/screenrec.nu}"
        "CAPS,Caps_Lock,exec,swayosd-client --caps-lock"
        ",Scroll_Lock,exec,swayosd-client --scroll-lock"
        ",Num_Lock,exec,swayosd-client --num-lock"
      ];
      bindel = [
        ",XF86MonBrightnessUp,exec,swayosd-client --brightness raise"
        ",XF86MonBrightnessDown,exec,swayosd-client --brightness lower"
      ];
      binde = [
        ",XF86AudioRaiseVolume,exec,swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume,exec,swayosd-client --output-volume lower"
        ",XF86AudioMute,exec,swayosd-client --output-volume mute-toggle"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
    };
  };
}
