vim.cmd.colorscheme('zenbones')

local function set_transparency()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "NonText",
    "SignColumn",
    "EndOfBuffer",
    "TabLine",
    "TabLineFill",
    "TabLineSel",

    "StatusLine",
    "StatusLineNC",

    "lualine_c_normal",
    "lualine_c_insert",
    "lualine_c_visual",
    "lualine_c_replace",
    "lualine_c_command",
    "lualine_c_inactive",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end
end

-- Apply transparency immediately
set_transparency()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "zenbones",
  callback = set_transparency,
})
