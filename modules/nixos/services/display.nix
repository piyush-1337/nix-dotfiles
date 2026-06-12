{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkg = inputs.hyprland.packages.${system}.hyprland;
  
  waylandSessions = pkgs.symlinkJoin {
    name = "wayland-sessions";
    paths = [ hyprlandPkg config.programs.niri.package ];
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = builtins.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-user-session"
          "--user-menu"
          "--sessions ${waylandSessions}/share/wayland-sessions"
        ];
      };
    };
  };
}
