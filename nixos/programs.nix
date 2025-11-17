{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    chezmoi
    rofi
    playerctl
    pavucontrol
    pamixer
    bluez
    bluez-tools
    hyprlock
    swww
    protonup-ng
    mangohud
    wl-clipboard
  ];

  programs.firefox = {
    enable = true;
    preferences = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "devtools.chrome.enabled" = true;
      "devtools.debugger.remote-enabled" = true;
      "layout.css.has-selector.enabled" = true;
    };
  };

  programs.hyprland.enable = true;
}
