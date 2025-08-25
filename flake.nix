{
  description = "skypex' flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    inner = {
      url = ./nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { inner, ... }: inner.outputs;
}
