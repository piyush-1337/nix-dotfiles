{ pkgs, ... }:

let
  nautilusTransparentCss = ''
    .nautilus-window {
      background-color: rgba(0,0,10,.25);
      border-radius: 12px;
      background-size: cover;
      background-repeat: no-repeat;
    }

    .nautilus-window box,
    .nautilus-window revealer,
    .nautilus-window widget,
    .nautilus-window statuspage,
    .nautilus-window placessidebar,
    .nautilus-window scrolledwindow,
    .nautilus-window stack,
    .nautilus-window firstcell,
    .nautilus-window columnview {
      background-color: rgba(0,0,0,0);
    }

    .nautilus-window textview {
      background-color: rgba(0,0,0,0.35);
    }

    .nautilus-window widget.sidebar-pane {
      background-color: rgba(0,0,0,0.35);
    }

    .nautilus-window,
    .nautilus-window * {
      color: #ffffff;
    }
  '';
in
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      extraCss = nautilusTransparentCss;
    };
    gtk4 = {
      extraCss = nautilusTransparentCss;
      theme = null;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 16;
    };
  };
}
