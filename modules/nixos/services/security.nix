{ ... }:

{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;
  programs.dconf.enable = true;
}
