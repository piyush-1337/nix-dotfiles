{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    (mpvpaper.override { mpv = pkgs.mpv-unwrapped; })
    android-tools
    aria2
    awww
    bat
    bluetuith
    brightnessctl
    btop
    fastfetch
    ffmpeg
    fzf
    gcc
    gh
    go-mtpfs
    hyprpaper
    inputs.qylock.packages.${pkgs.stdenv.hostPlatform.system}.qylock-quickshell
    libnotify
    man-pages
    man-pages-posix
    matugen
    mosh
    mpv-unwrapped
    mutagen
    nautilus
    nerd-fonts.iosevka
    nixd
    nixfmt
    nodejs
    # nvtopPackages.nvidia  # pulling massive cuda libs
    playerctl
    poppler-utils
    pulseaudio
    ripgrep
    rofi
    signal-desktop
    telegram-desktop
    tmux
    tmuxinator
    tree
    tree-sitter
    unzip
    waypaper
    wireplumber
    wl-clipboard
  ];
}
