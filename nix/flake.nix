{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
  };

  outputs = {
    self,
    cli-tools,
    work-desktop-tools,
    home-desktop-tools,
    ...
  }: let
    system = "x86_64-linux";
  in {
    packages.${system} = {
      default = self.packages.${system}.shell;
      shell = cli-tools.packages.${system}.default;
      work = work-desktop-tools.packages.${system}.default;
      home = home-desktop-tools.packages.${system}.default;
    };

    devShells.${system} = {
      default = cli-tools.devShells.${system}.default;
      lite = cli-tools.devShells.${system}.lite;
    };
  };
}
