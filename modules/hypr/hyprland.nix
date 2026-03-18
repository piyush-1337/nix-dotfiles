{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprland
  ];

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/piyush/nixos-dotfiles/.config/hypr/";
  };
}
