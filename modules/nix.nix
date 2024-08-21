{
  inputs,
  pkgs,
  ...
}: {
  system.stateVersion = "23.05";

  nix = {
    channel.enable = false;
    registry.p.flake = inputs.self;
    package = pkgs.nixVersions.latest;
    settings = {
      substituters = ["https://hyprland.cachix.org" "https://ow-mods.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ow-mods.cachix.org-1:6RTOd1dSRibA2W0MpZHxzT0tw1RzyhKObTPKQJpcrZo="];
      nix-path = "nixpkgs=${inputs.nixpkgs}";
      experimental-features = [
        "nix-command"
        "flakes"
        "no-url-literals"
        "ca-derivations"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
