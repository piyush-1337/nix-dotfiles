{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      nrs = "sudo nixos-rebuild switch --accept-flake-config --flake ~/nixos-dotfiles#piyushbtw";
    };
  };
}
