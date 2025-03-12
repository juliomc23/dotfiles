local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("IosevkaTerm NF")
config.font_size = 16

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.95
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.default_domain = "WSL:Ubuntu"
-- config.front_end = "WebGpu"
config.enable_scroll_bar = false
config.enable_kitty_graphics = true
return config
