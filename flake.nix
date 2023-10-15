{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    nixos-hardware,
    lanzaboote,
  }: rec {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    globalModules = [
      # Load lanzaboote for Secure Boot
      lanzaboote.nixosModules.lanzaboote
      # Load the main configuration
      ./configuration.nix
      # Load home manager
      home-manager.nixosModules.home-manager
      # Configure home manager
      {
        home-manager.sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.bean = import ./home.nix;
      }
    ];
    nixosConfigurations.b-pc-tower = nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = "b-pc-tower";
      };
      system = "x86_64-linux";
      modules = globalModules ++ [];
    };
    nixosConfigurations.b-pc-laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        hostName = "b-pc-laptop";
      };
      system = "x86_64-linux";
      modules =
        globalModules
        ++ [
          # Load framework laptop configuration
          nixos-hardware.nixosModules.framework-13th-gen-intel
        ];
    };
  };
}
