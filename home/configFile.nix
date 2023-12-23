{
  lib,
  hostName,
  pkgs,
  ...
}: {
  xdg.configFile = {
    kdeglobals.source = ../res/kdeglobals;
    dolphinrc.source = ../res/dolphinrc;
    waybar.source = ../res/waybar;
    swaync.source = ../res/swaync;
    Vencord.source = ../res/vencord;
    "VencordDesktop/VencordDesktop/settings".source = ../res/vencord/settings;
    "VencordDesktop/VencordDesktop/themes".source = ../res/vencord/themes;
    "qt5ct/qt5ct.conf".source = ../res/qt5ct.conf;
    "hyfetch.json".source = ../res/hyfetch.json;
    "swappy/config".source = ../res/swappy;
    "gtk-3.0/settings.ini".source = ../res/gtk/settings.ini;
    "gtk-4.0/settings.ini".source = ../res/gtk/settings.ini;
    "keepassxc/keepassxc.ini".source = ../res/keepassxc.ini;
    "swaylock/config".text = let
      ringColor = "0072FF";
      insideColor = "00000088";
      textColor = "6DED99";
      lineColor = "00000000";
      wrongColor = "ED254E";
      verColor = "0FDBFF";
    in ''
      show-failed-attempts
      image=${../res/pictures/background.jpg}
      clock
      timestr=%-I:%M %p
      indicator
      indicator-radius=100
      indicator-thickness=5
      ring-color=${ringColor}
      inside-color=${insideColor}
      inside-ver-color=${insideColor}
      inside-wrong-color=${insideColor}
      text-color=${textColor}
      key-hl-color=${textColor}
      separator-color=${textColor}
      line-color=${lineColor}
      line-ver-color=${lineColor}
      line-wrong-color=${lineColor}
      ring-ver-color=${verColor}
      text-ver-color=${verColor}
      ring-wrong-color=${wrongColor}
      text-wrong-color=${wrongColor}
      effect-compose=50%,50%;425x425;center;${../res/pictures/cow.png}
    '';
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet-Ambar-Blue
    '';
    "kdeconnect/config".text = ''
      [General]
      name=${lib.toUpper hostName}
    '';
    "hypr/hyprpaper.conf".text = ''
      ipc = off
      preload = ${../res/pictures/background.jpg}
      wallpaper = ,${../res/pictures/background.jpg}
    '';
  };
}
