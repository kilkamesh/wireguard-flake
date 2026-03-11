{
  description = "WireGuard + SOPS NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }: {
    nixosModules.default = {
      imports =[
        sops-nix.nixosModules.sops
        ./wireguard.nix
      ];
    };
  };
}