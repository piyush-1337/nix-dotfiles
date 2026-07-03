{ ... }:

{
  programs.man.generateCaches = false;

  imports = [
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/tmux.nix
    ./shell/starship.nix
    ./editors/nvim.nix
    ./browser/firefox.nix
    ./core/packages.nix
    ./desktop/gtk.nix
    ./shell/direnv.nix
    ./browser/chromium.nix
    ./apps/spotify.nix
    ./apps/obs.nix
    ./core/screenshot.nix
    ./apps/vesktop.nix
    ./desktop/notification.nix
    ./core/battery.nix
    ./apps/git.nix
    ./terminal/kitty.nix
  ];
}
