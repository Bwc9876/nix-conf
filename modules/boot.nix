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

  security = {
    audit = {
      enable = true;
      backlogLimit = 128;
    };
    auditd.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    bootspec.enable = true;

    initrd.systemd = {
      enable = true;
    };

    # LanzaBoote is a bootloader that supports Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Use latest kernel with sysrqs and lockdown enabled
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["lockdown=confidentiality"];
    kernel.sysctl."kernel.sysrq" = 1;
  };
}
