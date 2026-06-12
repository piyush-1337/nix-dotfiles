{ ... }:

{
  home.username = "piyush";
  home.homeDirectory = "/home/piyush";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/terminal/kitty.nix
    ../../modules/home-manager/hypr/hyprland.nix
    ../../modules/home-manager/hypr/hypridle.nix
    ../../modules/home-manager/hypr/hyprlock.nix
    # ../../modules/home-manager/desktop/quickshell.nix
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };
}
