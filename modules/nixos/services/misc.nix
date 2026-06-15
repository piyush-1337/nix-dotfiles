{ pkgs, ... }:

{
  services.upower.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
