{ pkgs, ... }:

{
  services.upower.enable = true;
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
}
