{ inputs, pkgs, ... }:

let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.piyush = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker" # no need to sudo to run docker things
      "dialout"
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
      hyprlandPkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };
}
