{
  lib,
  pkgs,
  ...
}: {
  users.users."bean".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKb2qxNUbvdBTAntmUyPIaOXwFd1nhZO/SS00SNss0nU"
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    banner = ''
      === B-PC-TOWER ===

    '';
    listenAddresses = [
      {
        addr = "0.0.0.0";
      }
    ];
    ports = [8069];
    settings.GSSAPIAuthentication = false;
    settings.PasswordAuthentication = false;
    settings.UseDns = false;
    # settings.LogLevel = "DEBUG1";
    settings.PermitRootLogin = "no";
    settings.KbdInteractiveAuthentication = false;
  };
}
