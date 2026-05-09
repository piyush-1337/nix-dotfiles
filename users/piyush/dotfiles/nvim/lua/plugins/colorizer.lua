return {
  'brenoprata10/nvim-highlight-colors',
  event = 'BufReadPost',
  opts = {
    render = 'virtual', -- or "foreground" / "virtual" / "background"
    enable_named_colors = true,
    enable_tailwind = true,
  },
}
