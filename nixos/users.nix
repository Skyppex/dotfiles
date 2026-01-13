{...}: {
  users.users.tower = {
    isNormalUser = true;
    description = "tower";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    packages = [];
  };
}
