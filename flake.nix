{
  description = "Piyush's NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.piyush = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
