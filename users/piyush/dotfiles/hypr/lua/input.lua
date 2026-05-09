hl.config({
  input = {
    kb_layout = "us",
    numlock_by_default = true,
    mouse_refocus = false,
    follow_mouse = 1,
    sensitivity = 1.0,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 1.0,
    },
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
