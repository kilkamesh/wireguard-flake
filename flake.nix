{
  description = "WireGuard + SOPS NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, ... }: {
    nixosConfigurations = {
      vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =[
          sops-nix.nixosModules.sops
          ./wireguard.nix
        ];
      };
    };
  };
}