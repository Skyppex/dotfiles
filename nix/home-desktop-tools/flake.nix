{
  description = "skypex home desktop tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    common-desktop-tools = {
      url = ../common-desktop-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
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

    homePackages = with pkgs; [
      ani-cli
      ani-skip
      blender
      logmein-hamachi
      r2modman
      quickshell
    ];
  in {
    lib.${system}.packages = common.packages ++ homePackages;

    packages.${system} = {
      default = pkgs.buildEnv {
        name = "skypex-home";
        paths = self.lib.${system}.packages;
        nativeBuildInputs = common.nativeBuildInputs;
        buildInputs = common.buildInputs;
        postBuild = common.postBuild;
      };
    };

    devShells = common-desktop-tools.devShells;
  };
}
