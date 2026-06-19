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
    awww
    vim
    wakeonlan
    wget
    wl-clipboard
    ffmpeg
    openssl_3 # <-- pulls in libssl.so.3
    libX11 # if you need X11
    wayland # if you build for Wayland
    vulkan-loader # if you use Vulkan shaders
    vulkan-headers
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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      openssl_3
      zlib
      stdenv.cc.cc
      curl
    ];
  };
}
