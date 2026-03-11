
for create secret on windowslop:
    docker run --rm -it -v "${PWD}:/workspace" -w /workspace nixos/nix nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#sops nixpkgs#nano -c sops secrets.yaml