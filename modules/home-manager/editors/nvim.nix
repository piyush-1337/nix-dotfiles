{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos-dotfiles/modules/home-manager/editors/nvim/";
  };
}
