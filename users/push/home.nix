{ ... }:

{
  home.username = "push";
  home.homeDirectory = "/home/push";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/niri/niri.nix
  ];
}
