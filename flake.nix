{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    gpakosz-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    allVars = import ./vars.nix;
    mkHost = name: let
      hostVars = allVars.hosts.${name};
      vars = removeAttrs allVars [ "hosts" ] // hostVars;
      hostDir = ./hosts + "/${hostVars.profile}";
    in
      nixpkgs.lib.nixosSystem {
        system = hostVars.platform;
        specialArgs = {inherit inputs vars;};
        modules = [
          (hostDir + "/configuration.nix")
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs vars;};
            home-manager.users.${vars.username} = import (hostDir + "/home.nix");
          }
        ];
      };
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs (name: _: mkHost name) allVars.hosts;
  };
}
