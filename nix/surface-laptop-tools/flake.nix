{
  description = "skypex surface laptop tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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

    surfacePackages = with pkgs; [
      ani-cli
      ani-skip
      logmein-hamachi
      bluetuith
      cliphist
      discord
      eww
      gimp
      grim
      hyprpicker
      hypridle
      mako
      mpv
      mpvpaper
      neovim
      noto-fonts-emoji
      obsidian
      slack
      spotify
      thunderbird
      wezterm
      zen-browser
    ];
  in {
    lib.${system} = {
      packages = cliPackages ++ surfacePackages;
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
        name = "skypex-surface";
        paths = self.lib.${system}.packages;
        nativeBuildInputs = self.lib.${system}.nativeBuildInputs;
        buildInputs = self.lib.${system}.buildInputs;
        postBuild = self.lib.${system}.postBuild;
      };
    };

    devShells = cli-tools.devShells;
  };
}
