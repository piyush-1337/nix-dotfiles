{ pkgs, ... }:

let
  nautilusTransparentCss = ''
    window {
      background-color: rgba(0,0,10,.25) !important;
      border-radius: 12px !important;
      background-size: cover !important;
      background-repeat: no-repeat !important;
    }

    box, revealer, widget, statuspage, placessidebar, scrolledwindow, stack, firstcell, columnview {
      background-color: rgba(0,0,0,0) !important;
    }
    textview {
      background-color: rgba(0,0,0,0.35) !important;
    }

    widget.sidebar-pane {
      background-color: rgba(0,0,0,0.35) !important;
    }

    window, window * {
      color: #ffffff !important;
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
            extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };
            extraCss = nautilusTransparentCss;
        };

        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
            size = 16;
        };
    };
}
