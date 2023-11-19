{
  pkgs,
  lib,
  hostName,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        greeting = ''--greeting "Authenticate into ${lib.toUpper hostName}"'';
        wlr_setting =
          if hostName == "b-pc-tower"
          then "WLR_NO_HARDWARE_CURSORS=1"
          else "WLR_NO_HARDWARE_CURSORS=0";
        cmd = ''--cmd "systemd-inhibit --what=handle-power-key:handle-lid-switch sh -c \"${wlr_setting} Hyprland\""'';
      in {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time ${greeting} ${cmd}";
      };
    };
  };
}
