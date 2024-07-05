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
    "swayosd/style.css".source = ../res/swayosd.css;
    "qt5ct/qt5ct.conf".source = ../res/qt5ct.conf;
    "qt6ct/qt6ct.conf".source = ../res/qt6ct.conf;
    "hyfetch.json".source = ../res/hyfetch.json;
    "swappy/config".source = ../res/swappy;
    "gtk-3.0/settings.ini".source = ../res/gtk/settings.ini;
    "gtk-4.0/settings.ini".source = ../res/gtk/settings.ini;
    "keepassxc/keepassxc.ini".source = ../res/keepassxc.ini;
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
      splash = off
      preload = ${../res/pictures/background.jpg}
      wallpaper = ,${../res/pictures/background.jpg}
    '';
  };
}
