{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
  programs = {
    # TODO: Enable if I can declaratively set extension preferences
    # firefox = {
    #     enable = true;
    #     policies = {
    #       Extensions.Install = map (x: "https://addons.mozilla.org/firefox/downloads/latest/${x}/latest.xpi") [
    #         "adnauseam"
    #         "duckduckgo-for-firefox"
    #         "keepassxc-browser"
    #         "sponsorblock"
    #         "youtube-shorts-block"
    #         "canvasblocker"
    #         "decentraleyes"
    #         "flagfox"
    #         "firefox-color"
    #         "facebook-container"
    #         "dearrow"
    #         "languagetool"
    #         "styl-us"

    #         "material-icons-for-github"
    #         "refined-github-"

    #         "open-graph-preview-and-debug"
    #         "react-devtools"
    #       ];
    #     };
    #     profiles = {
    #         default = {
    #             id = 0;
    #             name = "default";
    #             isDefault = true;
    #             settings = {
    #                 "browser.search.defaultenginename" = "DuckDuckGo";
    #                 "browser.search.order.1" = "DuckDuckGo";
    #                 "browser.discovery.containers.enabled" = true;
    #                 "widget.use-xdg-desktop-portal.file-picker" = 1;
    #                 "browser.aboutConfig.showWarning" = false;
    #                 "extensions.autoDisableScopes" = 0;
    #             };
    #             search = {
    #                 force = true;
    #                 default = "DuckDuckGo";
    #                 order = [ "DuckDuckGo" "Google" ];
    #             };
    #         };
    #     };
    # };
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
    thunderbird = {
      enable = true;
      profiles.bean.isDefault = true;
    };
  };
}
