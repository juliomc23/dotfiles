local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.window_padding = {
	top = 0,
	right = 0,
	bottom = 0,
	left = 0,
}

config.font = wezterm.font("IosevkaTerm NF")
config.font_size = 18
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 240
config.enable_kitty_graphics = true
-- config.window_background_opacity = 0.90
config.enable_scroll_bar = false

config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false

config.leader = {
	key = "Space",
	mods = "CTRL",
}

config.keys = {
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "H", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "L", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "K", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "J", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			domain = { DomainName = "WSL:Ubuntu" },
			cwd = "~",
		}),
	},
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.default_domain = "WSL:Ubuntu"
return config
