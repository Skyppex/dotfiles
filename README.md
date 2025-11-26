# Dotfiles

These are my dotfiles :D

## initialize using nix and chezmoi

run these commands:
```bash
NIX_CONFIG=experimental-features=nix-command nix shell nixpkgs#chezmoi

### in the nix shell environment ###
chezmoi init skyppex/dotfiles
~/.local/share/chezmoi/init
```
