{ config, pkgs, ... }:

let
  niriConfigDir = "/etc/nixos-dotfiles/users/push/dotfiles/niri";
in
{
  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink niriConfigDir;
  };
}
