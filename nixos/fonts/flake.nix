{
  description = "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
        };
      };

      # function to get a font from www.1001fonts.com
      thousand-one = {
        name,
        hash ? "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        meta ? {},
      }:
        pkgs.stdenvNoCC.mkDerivation {
          name = "${name}-font";

          src = pkgs.fetchzip {
            url = "https://www.1001fonts.com/download/${name}.zip";
            hash = hash;
            stripRoot = false;
          };

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            mkdir -p $out/share/fonts/opentype

            for f in *.ttf; do
                cp "$f" $out/share/fonts/truetype/
            done

            for f in *.otf; do
                cp "$f" $out/share/fonts/opentype/
            done
          '';

          meta = meta;
        };

      # function to get a font from www.dafont.com
      dafont = {
        name,
        hash ? "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        meta ? {},
      }:
        pkgs.stdenvNoCC.mkDerivation {
          name = "${name}-font";
          nativeBuildInputs = with pkgs; [unzip];

          src = pkgs.fetchurl {
            url = "https://dl.dafont.com/dl/?f=${name}";
            name = "${name}.zip";
            hash = hash;
          };

          unpackPhase = ''
            unzip $src -d $PWD
          '';

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            mkdir -p $out/share/fonts/opentype

            for f in *.ttf; do
                cp "$f" $out/share/fonts/truetype/
            done

            for f in *.otf; do
                cp "$f" $out/share/fonts/opentype/
            done
          '';

          meta = meta;
        };
    in {
      defaultPackage = pkgs.symlinkJoin {
        name = "fonts";
        paths =
          builtins.attrValues
          self.packages.${system}; # Add font derivation names here
      };

      packages.japan-daisuki = thousand-one {
        name = "japan-daisuki";
        hash = "sha256-psOKtHHAUwQNYoBQ0/3iDlI4pz6pW1bqjYUmO3+L8kU=";
        meta = {
          description = "Japan Daisuki font, free for personal use only,
          commercial use requires paid license";
          license = pkgs.lib.licenses.unfree;
        };
      };

      # https://www.1001fonts.com/download/the-last-shuriken.zip
      packages.the-last-shuriken = thousand-one {
        name = "the-last-shuriken";
        hash = "sha256-RnsYUMgvmgM58+wg6w2XjLorSAlHQtN+Qb99RbmU4Xk=";
        meta = {
          description = "The Last Shuriken font, free for personal use only,
          commercial use required paid license";
          license = pkgs.lib.licenses.unfree;
        };
      };

      #### dafont example ####
      # packages.the-last-shuriken = dafont {
      #   name = "the-last-shuriken";
      #   hash = "sha256-RnsYUMgvmgM58+wg6w2XjLorSAlHQtN+Qb99RbmU4Xk=";
      #   meta = {
      #     description = "The Last Shuriken font, free for personal use only,
      #     commercial use required paid license";
      #     license = pkgs.lib.licenses.unfree;
      #   };
      # };
    })
    // {
      nixosModules.default = {pkgs, ...}: {
        fonts = {
          enableDefaultPackages = true;

          packages = with pkgs; [
            nerd-fonts.jetbrains-mono
            self.defaultPackage.${pkgs.stdenv.hostPlatform.system}
          ];

          fontconfig.useEmbeddedBitmaps = true;
        };
      };
    };
}
