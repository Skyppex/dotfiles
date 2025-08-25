{
  description = "skypex work desktop tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    common-desktop-tools = {
      url = ../common-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, common-desktop-tools, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = { allowUnfree = true; };
      };
      commonPackages = common-desktop-tools.lib.${system}.packages;
      workPackages = with pkgs; [ dbeaver-bin ];
    in {
      lib.${system}.packages = commonPackages ++ workPackages;

      packages.${system} = {
        default = pkgs.buildEnv {
          name = "skypex-work";
          paths = self.lib.${system}.packages;
          nativeBuildInputs = common-desktop-tools.packages.${system}.default.nativeBuildInputs;
          buildInputs = common-desktop-tools.packages.${system}.default.buildInputs;
          postBuild = common-desktop-tools.packages.${system}.default.postBuild;
        };
      };

      devShells = common-desktop-tools.devShells;
    };
}
