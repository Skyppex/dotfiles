{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    chezmoi
    kdePackages.dolphin
    hyprlock
    mangohud
    pamixer
    pavucontrol
    playerctl
    protonup-ng
    rofi
    swww
    vim
    wakeonlan
    wget
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
