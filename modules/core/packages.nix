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
        tree
        tmux
        nautilus
        fastfetch
        mpvpaper
        hyprpaper
        swww
        nerd-fonts.geist-mono
        btop
    ];
}
