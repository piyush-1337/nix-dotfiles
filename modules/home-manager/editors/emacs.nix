{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    defaultEditor = true;
    startWithUserSession = "graphical";                                                                                                                          
  };

  xdg.configFile."emacs" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos-dotfiles/modules/home-manager/editors/emacs/";
  };
}
