{ pkgs, ... }:

{
    home.packages = with pkgs; [
        bat
        ripgrep
        nodejs
        gcc
        gemini-cli-bin
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
        nerd-fonts.fira-code
    ];
}
