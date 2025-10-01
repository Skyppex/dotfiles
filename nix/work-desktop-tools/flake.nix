{
  description = "skypex work desktop tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    common-desktop-tools = {
      url = ../common-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    common-desktop-tools,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config = {allowUnfree = true;};
    };
    common = common-desktop-tools.lib.${system};
    workPackages = with pkgs; [dbeaver-bin];
  in {
    lib.${system}.packages = common.packages ++ workPackages;

    packages.${system} = {
      default = pkgs.buildEnv {
        name = "skypex-work";
        paths = self.lib.${system}.packages;
        nativeBuildInputs = common.nativeBuildInputs;
        buildInputs = common.buildInputs;
        postBuild = common.postBuild;
      };
    };

    devShells = common-desktop-tools.devShells;
  };
}
