{
  lib,
  pkgs,
  ...
}: {
  # For firmware updates (not boot stuff but im putting it here anyway)
  services.fwupd.enable = true;

  services.upower = {
    enable = true;
  };

  boot = {
    # Use bootspec instead of systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;

    # LanzaBoote is a bootloader that supports Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Plymouth puts a theme on boot
    # plymouth = {
    #     enable = true;
    #     theme = "bgrt";
    # };

    # Use latest kernel with module signing and lockdown enabled
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["lockdown=confidentiality"];
    kernel.sysctl."kernel.sysrq" = 1;
  };
}
