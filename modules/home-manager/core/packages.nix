{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # nvtopPackages.nvidia  # pulling massive cuda libs
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
    ncdu
    nerd-fonts.iosevka
    nixd
    nixfmt
    nodejs
    perf
    playerctl
    poppler-utils
    pulseaudio
    ripgrep
    rofi
    signal-desktop
    tdf
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
