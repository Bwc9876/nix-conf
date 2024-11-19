{
  hostName,
  inputs,
  system,
  ...
}: {
  # Set the time zone.
  time.timeZone = "America/New_York";

  system.switch = {
    enable = false;
    enableNg = true;
  };

  # Define a user account.
  users = {
    users.bean = {
      isNormalUser = true;
      description = "Benjamin Crocker";
      autoSubUidGidRange = true;
      extraGroups = ["libvirtd" "networkmanager" "wheel" "video" "lpadmin" "wireshark"];
    };
  };

  # Pass extra arguments to home-manager.
  home-manager.extraSpecialArgs = {
    inherit hostName inputs system;
  };
}
