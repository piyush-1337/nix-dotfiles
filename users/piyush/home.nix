{ ... }:

{
  home.username = "piyush";
  home.homeDirectory = "/home/piyush";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home-manager/shell/bash.nix
    ../../modules/home-manager/shell/fish.nix
    ../../modules/home-manager/shell/starship.nix
    ../../modules/home-manager/terminal/kitty.nix
    ../../modules/home-manager/editors/nvim.nix
    ../../modules/home-manager/browser/firefox.nix
    ../../modules/home-manager/core/packages.nix
    ../../modules/home-manager/desktop/gtk.nix
    ../../modules/home-manager/shell/direnv.nix
    ../../modules/home-manager/hypr/hyprland.nix
    ../../modules/home-manager/hypr/hypridle.nix
    ../../modules/home-manager/hypr/hyprlock.nix
    ../../modules/home-manager/browser/chromium.nix
    ../../modules/home-manager/apps/spotify.nix
    # ../../modules/home-manager/desktop/quickshell.nix
    ../../modules/home-manager/apps/obs.nix
    ../../modules/home-manager/core/screenshot.nix
    ../../modules/home-manager/apps/vesktop.nix
    ../../modules/home-manager/desktop/notification.nix
    ../../modules/home-manager/core/battery.nix
  ];
}
