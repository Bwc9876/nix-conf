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
    ow-mod-man.url = "github:ow-mods/ow-mod-man";
    ow-mod-man.inputs.nixpkgs.follows = "nixpkgs";
    gh-grader-preview.url = "github:Bwc9876/gh-grader-preview";
    gh-grader-preview.inputs.nixpkgs.follows = "nixpkgs";
    wayland-mpris-idle-inhibit.url = "github:Bwc9876/wayland-mpris-idle-inhibit";
    wayland-mpris-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nix-index-database,
    lanzaboote,
    ow-mod-man,
    gh-grader-preview,
    wayland-mpris-idle-inhibit,
    rust-overlay,
    catppuccin,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        #(final: prev: {wayland-protocols-good = prev.wayland-protocols;})
        #hyprland.overlays.default
        #(final: prev: {wayland-protocols = prev.wayland-protocols-good;})
        ow-mod-man.overlays.default
        rust-overlay.overlays.default
        nix-index-database.overlays.nix-index
        #(final: prev: {utillinux = final.util-linux;}) # FIXME: remove when node-env fixes
      ];
    };
    globalModules = [
      # For nix-index
      nix-index-database.nixosModules.nix-index
      # Load lanzaboote for Secure Boot
      lanzaboote.nixosModules.lanzaboote
      # Load the main configuration
      ./configuration.nix
      # Load home manager
      home-manager.nixosModules.home-manager
      catppuccin.nixosModules.catppuccin
      # Configure home manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.bean = import ./home/home.nix;
      }
    ];
  in {
    legacyPackages.${system} = pkgs;
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations.b-pc-tower = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        hostName = "b-pc-tower";
        inherit inputs system;
      };
      modules = globalModules ++ [./computers/b-pc-tower/ssh.nix];
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
