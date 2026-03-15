{ config, pkgs, ... }:

{
    home.username = "piyush";
    home.homeDirectory = "/home/piyush";
    home.stateVersion = "25.11";


    imports = [
        ./modules/shell/bash.nix
        ./modules/shell/fish.nix
        ./modules/shell/starship.nix
        ./modules/terminal/kitty.nix
        ./modules/editors/nvim.nix
        ./modules/browser/firefox.nix
        ./modules/wm/hyprland.nix
        ./modules/core/packages.nix
        ./modules/desktop/gtk.nix
    ];


}
