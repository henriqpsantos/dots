local wez = require'wezterm'

local launch_menu = {}

local LEFT_ARROW = '⟨ '
local RIGHT_ARROW = ' ⟩'

wez.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = "nushell"
	if tab.is_active then
		local bg_s  = "#2A2622"
		local fg_s  = "#EDE6DE"
		return {
			{Background={Color=bg_s}},
			{Foreground={Color=fg_s}},
			{Text=LEFT_ARROW .. title .. RIGHT_ARROW},
		}
	end
	local bg    = "#544D45"
	local fg    = "#EDE6DE"
	return {
		{Background={Color=bg}},
		{Foreground={Color=fg}},
		{Text='  ' .. title ..'  '},
	}
end)

local debcmd = {label="debian", args={"nu.exe", "-c", "debian"}}
local pwshcmd = {label="pwsh", args={"nu.exe", "-c", "pwsh"}}
local nucmd = {label="nushell", args={"nu.exe", "--config-file", wez.home_dir .. '/Dropbox/Dev/.config/nu/config.toml'}}

--> "--perf",
local mykeys = {
	{key="1", mods="ALT", action=wez.action{ActivateTab=0}},
	{key="2", mods="ALT", action=wez.action{ActivateTab=1}},
	{key="3", mods="ALT", action=wez.action{ActivateTab=2}},
	{key="4", mods="ALT", action=wez.action{ActivateTab=3}},
	{key="5", mods="ALT", action=wez.action{ActivateTab=4}},
	{key="d", mods="ALT", action=wez.action{SpawnCommandInNewTab=debcmd}},
	{key="m", mods="ALT", action=wez.action{SpawnCommandInNewTab=pwshcmd}},
	{key="n", mods="ALT", action=wez.action{SpawnCommandInNewTab=nucmd}},
}

local M = {
	color_scheme_dirs = {wez.config_dir .. "/colors/"},
	color_scheme = 'melange',

	font = wez.font_with_fallback({
		{family="FiraCode NF", weight="Light"}}),

	default_prog = {"nu.exe", "--config-file", wez.home_dir .. '/Dropbox/Dev/.config/nu/config.toml'},
	default_cwd = wez.home_dir .. '/Dropbox/Dev',
	disable_default_key_bindings = true,
	keys = mykeys,
	font_size = 12,

	tab_max_width = 24,
	window_close_confirmation = "NeverPrompt",
	show_tab_index_in_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	window_background_opacity = 0.95,
}

return M

