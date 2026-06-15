{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear -x";
      nrs = "sudo nixos-rebuild switch --accept-flake-config --flake /etc/nixos-dotfiles#piyushbtw --show-trace";
    };
  };
}
