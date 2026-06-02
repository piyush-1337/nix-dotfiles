{ config, inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hyprPkgs = inputs.hyprland.packages.${system};
  hyprConfigDir = "/etc/nixos-dotfiles/users/piyush/dotfiles/hypr";
in
{
  home.packages = [
    hyprPkgs.hyprland
  ];

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink hyprConfigDir;
  };
  
  xdg.configFile."hypr-stubs" = {
    source = "${hyprPkgs.hyprland}/share/hypr/stubs";
  };
}
