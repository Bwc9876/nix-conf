{
  lib,
  hostName,
  pkgs,
  ...
}: {
  # IP
  networking = {
    hostName = lib.toUpper hostName;
    networkmanager.enable = true;
  };
  environment.variables.HOSTNAME = hostName; # To make repl work

  # services.geoclue2 = {
  #   enable = true;
  #   enableWifi = false; # Mozilla location service is no longer available
  # };

  # environment.etc."geoclue/conf.d/.keep" = {
  #   text = "created the directory.";
  # };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  # TODO: Remove this eventually
  # Use legacy renegotiation for wpa_supplicant because some things are silly geese
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
  '';
}
