{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    fenix-flake = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix-flake,
    zen-browser,
    ...
  }: let
    system = "x86_64-linux";

    pkgsFree = import nixpkgs {
      config.allowUnfree = false;
      inherit system;
    };

    pkgsUnfree = import nixpkgs {
      config.allowUnfree = true;
      inherit system;
    };

    fenix = fenix-flake.packages.${system};

    cli-tools = import ./cli-tools.nix {
      inherit pkgsFree;
      inherit pkgsUnfree;
      inherit fenix;
    };

    common-desktop-tools = import ./common-desktop-tools.nix {
      inherit pkgsUnfree;
    };

    work-desktop-tools = import ./work-desktop-tools.nix {
      inherit pkgsUnfree;
    };

    home-desktop-tools = import ./home-desktop-tools.nix {
      inherit pkgsUnfree;
      inherit system;
      inherit zen-browser;
    };

    surface-laptop-tools = import ./home-desktop-tools.nix {
      inherit pkgsUnfree;
    };
  in {
    lib.${system}.packages = {
      default = self.lib.${system}.packages.shell;
      shell = cli-tools.packages;
      work = cli-tools.packages ++ common-desktop-tools ++ work-desktop-tools;
      home = cli-tools.packages ++ common-desktop-tools ++ home-desktop-tools;
      surface = cli-tools.packages ++ surface-laptop-tools;
    };

    packages.${system} = {
      default = self.packages.${system}.shell;
      shell = pkgsUnfree.buildEnv {
        name = "cli-tools";
        paths =
          cli-tools.packages;
      };
      work = pkgsUnfree.buildEnv {
        name = "work-tools";
        paths =
          cli-tools.packages
          ++ common-desktop-tools ++ work-desktop-tools;
        nativeBuildInputs = [pkgsUnfree.makeWrapper];
        buildInputs = [pkgsUnfree.libglvnd pkgsUnfree.mesa];
        postBuild = ''
          wrapProgram $out/bin/wezterm \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.libglvnd}/lib \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.mesa}/lib
        '';
      };
      home = pkgsUnfree.buildEnv {
        name = "home-tools";
        paths =
          cli-tools.packages
          ++ common-desktop-tools ++ home-desktop-tools;
        nativeBuildInputs = [pkgsUnfree.makeWrapper];
        buildInputs = [pkgsUnfree.libglvnd pkgsUnfree.mesa];
        postBuild = ''
          wrapProgram $out/bin/wezterm \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.libglvnd}/lib \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.mesa}/lib
        '';
      };
      surface = pkgsUnfree.buildEnv {
        name = "surface-tools";
        paths =
          cli-tools.packages
          ++ surface-laptop-tools;
        nativeBuildInputs = [pkgsUnfree.makeWrapper];
        buildInputs = [pkgsUnfree.libglvnd pkgsUnfree.mesa];
        postBuild = ''
          wrapProgram $out/bin/wezterm \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.libglvnd}/lib \
              --prefix LD_LIBRARY_PATH : ${pkgsUnfree.mesa}/lib
        '';
      };
    };

    devShells.${system} = {
      default = cli-tools.devShells.default;
      lite = cli-tools.devShells.lite;
      free = cli-tools.devShells.free;
    };
  };
}
