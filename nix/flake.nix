{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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
    flake-utils,
    fenix-flake,
    zen-browser,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
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

      cli-tools-work = import ./cli-tools.nix {
        inherit pkgsFree;
        inherit pkgsUnfree;
        inherit fenix;
        dotnetSdks = with pkgsFree.dotnetCorePackages; [sdk_8_0 sdk_9_0];
      };

      common-desktop-tools = import ./common-desktop-tools.nix {
        inherit pkgsUnfree;
      };

      work-desktop-tools = import ./work-desktop-tools.nix {
        inherit pkgsFree;
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

      profiles = {
        shell = cli-tools.packages;
        work = cli-tools-work.packages ++ common-desktop-tools ++ work-desktop-tools;
        home = cli-tools.packages ++ common-desktop-tools ++ home-desktop-tools;
        surface = cli-tools.packages ++ surface-laptop-tools;
      };

      mkEnv = name: paths:
        pkgsUnfree.buildEnv {
          inherit name paths;
          nativeBuildInputs = [pkgsUnfree.makeWrapper];
          buildInputs = [pkgsUnfree.libglvnd pkgsUnfree.mesa];
          postBuild = ''
            if [ -e "$out/bin/wezterm" ]; then
                wrapProgram "$out/bin/wezterm" \
                    --prefix LD_LIBRARY_PATH : ${pkgsUnfree.libglvnd}/lib \
                    --prefix LD_LIBRARY_PATH : ${pkgsUnfree.mesa}/lib
            fi
          '';
        };
    in {
      profiles = profiles;

      packages = {
        default = mkEnv "cli-tools" profiles.shell;
        shell = mkEnv "cli-tools" profiles.shell;
        work = mkEnv "work-tools" profiles.work;
        home = mkEnv "home-tools" profiles.home;
        surface = mkEnv "surface-tools" profiles.surface;
      };

      devShells = {
        default = cli-tools.devShells.default;
        lite = cli-tools.devShells.lite;
        free = cli-tools.devShells.free;
      };
    });
}
