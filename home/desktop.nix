{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "qtct";
  };
  programs = {
    chromium.enable = true;

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      location = "center";
      theme = ../res/rofi-style.rasi;
      plugins = with pkgs; [
        rofi-emoji
        rofi-power-menu
        rofi-bluetooth
        rofi-calc
        rofi-pulse-select
      ];
    };
    thunderbird = {
      enable = true;
      profiles.bean.isDefault = true;
    };
  };
}
