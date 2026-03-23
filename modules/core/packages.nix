{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    ripgrep
    nodejs
    gcc
    brightnessctl
    playerctl
    wireplumber
    unzip
    nixd
    nixfmt
    tree
    tmux
    nautilus
    fastfetch
    mpvpaper
    hyprpaper
    swww
    nerd-fonts.geist-mono
    btop
    matugen
    waypaper
    ffmpeg
    # nvtopPackages.nvidia  # pulling massive cuda libs
  ];
}
