{
  description = "flake for developing my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          lua-language-server
          stylua
          yamlfmt
          yamllint
          tombi
          jq
          jsonlint
          xmlformat
          markdownlint
          shellcheck
          kdePackages.qtdeclarative
          ruff
          pyright
          beautysh
          nil
          alejandra
        ];
      };
    });
}
