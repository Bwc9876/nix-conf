{config, ...}: {
  xdg = {
    enable = true;
    userDirs = with config.home; {
      enable = true;
      createDirectories = true;
      desktop = "${homeDirectory}/Desktop";
      documents = "${homeDirectory}/Documents";
      pictures = "${homeDirectory}/Pictures";
      videos = "${homeDirectory}/Videos";
      music = "${homeDirectory}/Music";
      extraConfig = {
        "XDG_SCREENSHOTS_DIR" = "${homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
