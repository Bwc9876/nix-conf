{
  lib,
  hostName,
}: {
  kdeglobals.source = ../res/kdeglobals;
  dolphinrc.source = ../res/dolphinrc;
  waybar.source = ../res/waybar;
  swaync.source = ../res/swaync;
  "qt5ct/qt5ct.conf".source = ../res/qt5ct.conf;
  "hyfetch.json".source = ../res/hyfetch.json;
  "gtk-3.0/settings.ini".source = ../res/gtk/settings.ini;
  "gtk-4.0/settings.ini".source = ../res/gtk/settings.ini;
  "swayidle/config".source = ../res/swayidle;
  "keepassxc/keepassxc.ini".source = ../res/keepassxc.ini;
  "discord/settings.json".text = "{ \"SKIP_HOST_UPDATE\": true }";
  "gtklock/config.ini".text = ''
    [main]
    time-format=%I:%M %p
    gtk-theme=Sweet-Ambar-Blue
    background=${../res/pictures/background.jpg}
    idle-hide=true
    style=${../res/gtklock-style.css}
    start-hidden=true
    modules=/run/current-system/sw/lib/gtklock/userinfo-module.so

    [userinfo]
    vertical-layout=false
    under-clock=true
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
    wallpaper = eDP-1,${../res/pictures/background.jpg}
  '';
}
