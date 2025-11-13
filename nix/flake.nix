{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cli-tools = {
      url = ./cli-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    common-desktop-tools = {
      url = ./common-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cli-tools.follows = "cli-tools";
    };

    work-desktop-tools = {
      url = ./work-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.common-desktop-tools.follows = "common-desktop-tools";
    };

    home-desktop-tools = {
      url = ./home-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.common-desktop-tools.follows = "common-desktop-tools";
    };

    surface-laptop-tools = {
      url = ./surface-laptop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cli-tools.follows = "cli-tools";
    };
  };

  outputs = {
    self,
    cli-tools,
    work-desktop-tools,
    home-desktop-tools,
    surface-laptop-tools,
    ...
  }: let
    system = "x86_64-linux";
  in {
    lib.${system}.packages = {
      default = self.lib.${system}.packages.shell;
      shell = cli-tools.lib.${system}.packages;
      work = work-desktop-tools.lib.${system}.packages;
      home = home-desktop-tools.lib.${system}.packages;
      surface = surface-laptop-tools.lib.${system}.packages;
    };

    packages.${system} = {
      default = self.packages.${system}.shell;
      shell = cli-tools.packages.${system}.default;
      work = work-desktop-tools.packages.${system}.default;
      home = home-desktop-tools.packages.${system}.default;
      surface = surface-laptop-tools.packages.${system}.default;
    };

    devShells.${system} = {
      default = cli-tools.devShells.${system}.default;
      lite = cli-tools.devShells.${system}.lite;
    };
  };
}
