local home = os.getenv("HOME")
local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")

package.path = table.concat({
  xdg_config_home .. "/hypr/?.lua",
  xdg_config_home .. "/hypr/?/init.lua",
  package.path,
}, ";")

require("lua.env")
require("lua.monitors")
require("lua.look")
require("lua.input")
require("lua.binds")
require("lua.rules")
require("lua.autostart")
