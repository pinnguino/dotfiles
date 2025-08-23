-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Front end
front_end = "WebGpu"
webgpu_power_preference = "HighPerformance"
max_fps = 60

-- Font
config.font = wezterm.font(
	-- 'LigalexMono Nerd Font',
	-- 'IosevkaTerm Nerd Font',
	-- 'CaskaydiaCove Nerd Font',
	'Mononoki Nerd Font',
	{ weight = 'Regular' }
)
config.font_size = 13

-- Keybindings
config.keys = {
	{
		key = 'r',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.PromptInputLine {
			description = 'Enter tab name:',
			-- initial_value = 'Your tab name...',
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1), -- Move to the left tab
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1), -- Move to the right tab
	},
	{
		key = "l",
		mods = "SUPER|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "h",
		mods = "SUPER|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "SUPER|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "SUPER|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "SUPER|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentTab({confirm=true}),
	},
	{
		key = 't',
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab('CurrentPaneDomain'),
	},
}

-- Window padding
config.window_padding = {
	left = 3,
	right = 3,
	top = 3,
	bottom = 0,
}

-- Window title
config.window_decorations = "RESIZE" -- Title disabled, but is resizable.


-- Default shell
config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- Colorscheme
config.color_scheme = 'Tokyo Night'

-- Tab bar
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 50
config.tab_and_split_indices_are_zero_based = false

local RIGHT_BORDER = ""

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	-- local edge_background = "#2a2a40"
	local background = "#1a1b26"
	local foreground = "#c0caf5"
	local edge_foreground = background

	if tab.is_active then
		background = "#7aa2f7"
		foreground = "#e3e5e5"
	elseif hover then
		background = "#1b1b32"
		foreground = "#909090"
	end

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		-- Right border
		{ Background = { Color = tab.is_active and "#7aa2f7" or "#1a1b26" } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = (tab.is_active and tab.tab_index ~= 0) and RIGHT_BORDER or " " },

		-- Tab title
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. title .. " " },

		-- Right border
		{ Background = { Color = "#1a1b26" } },
		{ Foreground = { Color = tab.is_active and "#7aa2f7" or "#c0caf5" } },
		{ Text = tab.is_active and RIGHT_BORDER or " " },

		-- If you want, add more stuff to the tab bar.
	}
end)

return config
