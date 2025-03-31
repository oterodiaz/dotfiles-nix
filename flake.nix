{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # For macOS system config
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # For user-specific config
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs,  ... }: let globals = {
    # TODO
  }; in rec {
    # NixOS system-wide config + home-manager
    nixosConfigurations = {
      lambda = import ./hosts/lambda;
    };
    
    # macOS system-wide config + home-manager
    darwinConfigurations = {
      sigma = import ./hosts/sigma { inherit inputs; };
    };
    
    # home-manager configs
    homeConfigurations = {
      lambda = nixosConfigurations.lambda.config.home-manager.users.diego.home;
      sigma = darwinConfigurations.sigma.config.home-manager.users.diego.home;
    };
  };
}
