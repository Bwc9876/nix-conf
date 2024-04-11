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
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.xdph.follows = "xdph";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.nixpkgs.follows = "nixpkgs";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    xdph.inputs.nixpkgs.follows = "nixpkgs";
    xdph.inputs.hyprland-protocols.follows = "hyprland";
    waybar.url = "github:Alexays/Waybar";
    waybar.inputs.nixpkgs.follows = "nixpkgs";
    ow-mod-man.url = "github:ow-mods/ow-mod-man/dev";
    ow-mod-man.inputs.nixpkgs.follows = "nixpkgs";
    gh-grader-preview.url = "github:Bwc9876/gh-grader-preview";
    gh-grader-preview.inputs.nixpkgs.follows = "nixpkgs";
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
    hyprlock,
    hypridle,
    waybar,
    ow-mod-man,
    xdph,
    gh-grader-preview,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
          # "electron-25.9.0"
        ];
      };
      overlays = [
        hyprland.overlays.default
        # waybar.overlays.default
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
      modules = globalModules ++ [ ./computers/b-pc-tower/ssh.nix ];
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
    nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        hostName = "install-media";
        inherit inputs system;
      };
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        nix-index-database.nixosModules.nix-index
        ./iso/iso.nix
        home-manager.nixosModules.home-manager
      ];
    };
    repl = with nixpkgs.lib;
    with builtins;
      foldl' attrsets.unionOfDisjoint {} [
        (removeAttrs nixpkgs.lib ["meta" "options"])
        (mapAttrs (_: v: v // v.config) self.nixosConfigurations)
        (let
          hn = getEnv "HOSTNAME";
        in
          if hn == ""
          then {}
          else (x: removeAttrs (x // x.config) ["lib" "pkgs" "passthru"]) (self.nixosConfigurations.${hn}))
        {
          inherit (self) inputs sourceInfo outputs;
          inherit (nixpkgs) lib;
          inherit self;
          pkgs = self.nixosConfigurations.${getEnv "HOSTNAME"}.pkgs;
          o.k = foldr seq 0 (attrValues self.repl);
        }
      ];
  };
}
