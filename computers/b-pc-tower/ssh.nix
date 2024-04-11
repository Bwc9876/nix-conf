{
    ...
}: {

    users.users."bean".openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKb2qxNUbvdBTAntmUyPIaOXwFd1nhZO/SS00SNss0nU bean@B-PC-LAPTOP"
    ];

    services.openssh = {
        enable = true;
        ports = [ 8022 ];
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
    };
}