{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/piyush/nixos-dotfiles/users/piyush/.config/nvim/";
  };
}
