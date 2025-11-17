{...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tower = {
    isNormalUser = true;
    description = "tower";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    packages = [];
  };
}
