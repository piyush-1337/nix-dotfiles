{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos-dotfiles/users/piyush/.config/quickshell/";
  };
}
