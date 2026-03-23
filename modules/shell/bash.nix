{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#piyushbtw";
    };

    profileExtra = ''
      if [ -z $DISPLAY ] && [ -z "$WAYLAND_DISPLAY"] && [ "$(tty)" = "/dev/tty1" ]; then
          exec start-hyprland
      fi
    '';
  };
}
