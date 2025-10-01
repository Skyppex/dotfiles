{
  description = "skypex common desktop tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cli-tools = {
      url = ../cli-tools;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    zen-browser,
    cli-tools,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config = {allowUnfree = true;};
    };
    cliPackages = cli-tools.lib.${system}.packages;

    commonPackages = with pkgs; [
      bluetuith
      cliphist
      dbeaver-bin
      discord
      eww
      gimp
      grim
      hyprpicker
      hypridle
      inkscape
      jetbrains-toolbox
      lens
      mako
      mpv
      mpvpaper
      neovim
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      obsidian
      slack
      spotify
      wezterm
      zen-browser
    ];
  in {
    lib.${system} = {
      packages = cliPackages ++ commonPackages;
      nativeBuildInputs = [pkgs.makeWrapper];
      buildInputs = [pkgs.libglvnd pkgs.mesa];
      postBuild = ''
        wrapProgram $out/bin/wezterm \
            --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
            --prefix LD_LIBRARY_PATH : ${pkgs.mesa}/lib
      '';
    };

    packages.${system} = {
      default = pkgs.buildEnv {
        name = "skypex-desktop-common";
        paths = self.lib.${system}.packages;
        nativeBuildInputs = self.lib.${system}.nativeBuildInputs;
        buildInputs = self.lib.${system}.buildInputs;
        postBuild = self.lib.${system}.postBuild;
      };
    };

    devShells = cli-tools.devShells;
  };
}
