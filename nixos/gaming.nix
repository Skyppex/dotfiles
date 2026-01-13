{...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/tower/.steam/root/compatibilitytools.d";
  };

  services.xserver.videoDrivers = ["amdgpu"];
}
