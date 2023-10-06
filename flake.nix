{
  description = "GORP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager"; home-manager.inputs.nixpkgs.follows = "nixpkgs";
    grub2-themes.url = "github:vinceliuice/grub2-themes"; grub2-themes.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, grub2-themes, plasma-manager }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	    grub2-themes.nixosModules.default
        home-manager.nixosModules.home-manager
        {
	      home-manager.sharedModules = [
	        inputs.plasma-manager.homeManagerModules.plasma-manager
	      ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bean = import ./home.nix;
        }
        # {
        #     nixpkgs.overlays = [
        #         nixpkgs-mozilla.overlays.firefox
        #     ];
        # }
      ];
    };
  };
}
