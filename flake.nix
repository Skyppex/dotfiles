{
  description = "skypex' flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cli-tools = {
      url = ./nix/cli-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    common-desktop-tools = {
      url = ./nix/common-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cli-tools.follows = "cli-tools";
    };

    work-desktop-tools = {
      url = ./nix/work-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.common-desktop-tools.follows = "common-desktop-tools";
    };

    home-desktop-tools = {
      url = ./nix/home-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.common-desktop-tools.follows = "common-desktop-tools";
    };

    surface-laptop-tools = {
      url = ./surface-laptop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cli-tools.follows = "cli-tools";
    };

    inner = {
      url = ./nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cli-tools.follows = "cli-tools";
      inputs.common-desktop-tools.follows = "common-desktop-tools";
      inputs.work-desktop-tools.follows = "work-desktop-tools";
      inputs.home-desktop-tools.follows = "home-desktop-tools";
      inputs.surface-laptop-tools.follows = "surface-laptop-tools";
    };
  };
  outputs = {inner, ...}: inner.outputs;
}
