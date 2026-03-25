{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.piyush = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker" # no need to sudo to run docker things
    ]; # Enable ‘sudo’ for the user.
  };

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };
}
