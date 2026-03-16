{ pkgs, ... }:

{
    home.packages = with pkgs; [
        (nerd-fonts.override { fonts = [ "FiraCode" ]; })

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
    ];
}
