{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  xdg.configFile."emacs" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos-dotfiles/modules/home-manager/editors/emacs/";
  };
}
