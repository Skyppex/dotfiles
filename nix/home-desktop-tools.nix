{
  pkgsUnfree,
  system,
  zen-browser,
}:
with pkgsUnfree; [
  ani-cli
  ani-skip
  bitwarden-desktop
  blender
  catt
  logmein-hamachi
  prismlauncher
  r2modman
  zen-browser.packages.${system}.default
]
