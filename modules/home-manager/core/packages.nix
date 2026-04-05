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
    awww
    nerd-fonts.geist-mono
    btop
    matugen
    waypaper
    ffmpeg
    # nvtopPackages.nvidia  # pulling massive cuda libs
    rofi
    libnotify
    signal-desktop
    tree-sitter
    telegram-desktop
    wl-clipboard
    gh
  ];
}
