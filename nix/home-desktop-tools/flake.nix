{
  description = "skypex home desktop tools";

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
      homePackages = with pkgs; [ ani-cli ani-skip ];
    in {
      lib.${system}.packages = commonPackages ++ homePackages;

      packages.${system} = {
        default = pkgs.buildEnv {
          name = "skypex-home";
          paths = self.lib.${system}.packages;
          nativeBuildInputs = commonPackages.default.nativeBuildInputs;
          buildInputs = commonPackages.default.buildInputs;
          postBuild = commonPackages.default.postBuild;
        };
      };

      devShells = common-desktop-tools.devShells;
    };
}
