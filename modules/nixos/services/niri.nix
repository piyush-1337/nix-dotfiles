{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.enable = true;
  programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;

  # niri flake doesnt set up xwayland unless xwayland-satellite is in PATH
  environment.systemPackages = [
    inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
  ];
}
