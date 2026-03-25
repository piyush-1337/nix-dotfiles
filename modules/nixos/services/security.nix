{ ... }:

{
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;

  programs.dconf.enable = true;
}
