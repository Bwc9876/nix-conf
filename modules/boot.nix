{
  lib,
  pkgs,
  ...
}: {
  # For firmware updates (not boot stuff but im putting it here anyway)
  services.fwupd.enable = true;

  boot = {
    # Use bootspec instead of systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;

    # LanzaBoote is a bootloader that supports Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Use latest kernel with module signing and lockdown enabled
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [
      {
        name = "kernel-lockdown";
        patch = null;
        extraConfig = ''
          SECURITY_LOCKDOWN_LSM y
          MODULE_SIG y
        '';
      }
    ];
    kernelParams = ["lockdown=confidentiality"];
  };
}
