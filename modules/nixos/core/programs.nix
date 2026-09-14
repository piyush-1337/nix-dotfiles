{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.kdeconnect.enable = true;

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
  };
}
