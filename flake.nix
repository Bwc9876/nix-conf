{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
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
    nix-index-database,
    lanzaboote,
    hyprland,
    hyprland-contrib,
    waybar,
    ow-mod-man,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
      };
      overlays = [
        hyprland.overlays.default
        waybar.overlays.default
        hyprland-contrib.overlays.default
        ow-mod-man.overlays.default
      ];
      lib = nixpkgs.lib;
    };
    globalModules = [
      # For nix-index
      nix-index-database.nixosModules.nix-index
      # Load lanzaboote for Secure Boot
      lanzaboote.nixosModules.lanzaboote
      # Load Hyprland Stuff
      hyprland.nixosModules.default
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
  in {
    legacyPackages.${system} = pkgs;
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations.b-pc-tower = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        hostName = "b-pc-tower";
        inherit inputs system;
      };
      modules = globalModules ++ [];
    };
    nixosConfigurations.b-pc-laptop = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        hostName = "b-pc-laptop";
        inherit inputs system;
      };
      modules =
        globalModules
        ++ [
          # Load framework laptop configuration
          nixos-hardware.nixosModules.framework-13th-gen-intel
        ];
    };
  };
}
