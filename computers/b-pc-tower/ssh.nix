{
    ...
}: {
    services.openssh = {
        enable = true;
        ports = [ 8022 ];
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
    };
}