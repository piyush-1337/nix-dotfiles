{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/piyush/nixos-dotfiles/.config/quickshell/";
  };
}
