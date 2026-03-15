{}: let
  version = "1.21.1";
  dir = "/var/lib/containers/minecraft/fabric";
  profile = "the-new-world";
in {
  systemd.tmpfiles.rules = [
    "d ${dir}/${profile} 0755 1000 1000 -"
  ];

  virtualisation.oci-containers.containers.minecraft-server = {
    image = "itzg/minecraft-server";
    autoStart = false;

    environment = {
      EULA = "true";
      TYPE = "NEOFORGE";
      VERSION = version;
      MODE = "survival";
      DIFFICULTY = "hard";
      SPAWN_PROTECTION = "0";
      VIEW_DISTANCE = "16";

      INIT_MEMORY = "1G";
      MAX_MEMORY = "8G";
    };

    volumes = [
      "${dir}/${profile}:/data"
    ];

    ports = [
      "25565:25565"
      "24455:24455"
    ];

    autoRemoveOnStop = false;
  };
}
