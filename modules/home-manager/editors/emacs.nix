{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      epkgs.vterm
    ];
  };

  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    defaultEditor = true;
    startWithUserSession = "graphical";                                                                                                                          
  };

  xdg.configFile."emacs" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos-dotfiles/modules/home-manager/editors/emacs/";
  };
}
