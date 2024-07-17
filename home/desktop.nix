{pkgs, ...}: {
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";
  };
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        plugins = with pkgs; [
          (pkgs.rofi-emoji.override {
            rofi-unwrapped = rofi-wayland-unwrapped;
          })
          rofi-power-menu
          rofi-bluetooth
          (pkgs.rofi-calc.override {
            rofi-unwrapped = rofi-wayland-unwrapped;
          })
          rofi-pulse-select
        ];
      };
      location = "center";
      theme = ../res/rofi-style.rasi;
    };
  };
}
