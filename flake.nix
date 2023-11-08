{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote";
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    xdg-desktop-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    xdg-desktop-portal-hyprland.inputs.nixpkgs.follows = "nixpkgs";
    waybar.url = "github:Alexays/Waybar";
    waybar.inputs.nixpkgs.follows = "nixpkgs";
    ow-mod-man.url = "github:ow-mods/ow-mod-man/dev";
    ow-mod-man.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    lanzaboote,
    hyprland,
    xdg-desktop-portal-hyprland,
    hyprland-plugins,
    waybar,
    ow-mod-man,
  }: let
    globalModules = [
      # Load lanzaboote for Secure Boot
      lanzaboote.nixosModules.lanzaboote
      # Load the main configuration
      ./configuration.nix
      # Load home manager
      home-manager.nixosModules.home-manager
      # Configure home manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.bean = import ./home/home.nix;
      }
    ];
    system = "x86_64-linux";
  in {
    legacyPackages.${system} = self.nixosConfigurations.b-pc-laptop._module.args.pkgs;
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations.b-pc-tower = nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = "b-pc-tower";
        inputs = inputs;
        system = system;
      };
      system = system;
      modules = globalModules ++ [];
    };
    nixosConfigurations.b-pc-laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = "b-pc-laptop";
        inputs = inputs;
        system = system;
      };
      system = system;
      modules =
        globalModules
        ++ [
          # Load framework laptop configuration
          nixos-hardware.nixosModules.framework-13th-gen-intel
        ];
    };
  };
}
