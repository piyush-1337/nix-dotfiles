hl.window_rule({ match = { title = "^Microsoft-edge$" }, tile = true })
hl.window_rule({ match = { title = "^Brave-browser$" }, tile = true })
hl.window_rule({ match = { title = "^Chromium$" }, tile = true })

hl.window_rule({
  name = "blueman-manager",
  match = {
    initial_class = ".blueman-manager-wrapped",
    initial_title = "Bluetooth Devices",
  },
  float = true,
  size = "800 600",
  center = true,
})

hl.window_rule({
  name = "waypaper-float",
  match = {
    initial_class = "^waypaper$",
  },
  float = true,
  size = "800 600",
  center = true,
})

hl.window_rule({
  name = "python-float",
  match = {
    initial_class = "^python3$",
  },
  float = true,
  size = "800 600",
  center = true,
})

hl.window_rule({ match = { title = "^pavucontrol$" }, float = true })
hl.window_rule({ match = { title = "^nm-connection-editor$" }, float = true })
hl.window_rule({ match = { title = "^qalculate-gtk$" }, float = true })

hl.window_rule({ match = { title = "^Picture-in-Picture$" }, float = true })
hl.window_rule({ match = { title = "^Picture-in-Picture$" }, pin = true })

hl.window_rule({ match = { class = "^mpv$" }, workspace = "5" })
hl.window_rule({ match = { class = "^kitty$", title = "^RMPC$" }, workspace = "5" })
hl.window_rule({ match = { class = "^org.gnome.Nautilus$" }, opacity = "0.8 0.8" })
hl.window_rule({ match = { class = "^kitty$" }, opacity = "0.8 0.8" })
