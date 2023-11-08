{
  pkgs,
  lib,
  hostName,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting \"Authenticate into ${lib.toUpper hostName}\" --time --cmd Hyprland";
      };
    };
  };
}
