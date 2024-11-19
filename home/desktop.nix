{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.dataFile."applications/htop.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Htop
    Exec=foot --title="Htop" --app-id="htop" htop
    Icon=htop
  '';

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        plugins = with pkgs; [
          rofi-emoji-wayland
          rofi-power-menu
          rofi-bluetooth
          (rofi-calc.override {
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
