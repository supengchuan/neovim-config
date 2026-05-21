local wezterm = require("wezterm")

wezterm.on("toggle-tabbar", function(window, _)
	local overrides = window:get_config_overrides() or {}
	overrides.enable_tab_bar = not overrides.enable_tab_bar
	window:set_config_overrides(overrides)
end)

local edge_background = "#222130"
local background = "#282a11"
local foreground = "#F8F8F2"

-- The filled in variant of the < symbol 
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
SOLID_LEFT_ARROW = ""

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
SOLID_RIGHT_ARROW = ""

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is not explicitly set, use the title from the active pane in that tab
	if not title or #title == 0 then
		title = tab_info.active_pane.title
	end

	-- limit title length
	if #title > 27 then
		title = ".." .. string.sub(title, -23)
	end

	-- set tab index number
	if tab_info.is_active then
		title = "  " .. title
	else
		title = " " .. title .. " | " .. tab_info.tab_index + 1
	end
	return title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.is_active then
		background = "#6272A4"
		foreground = "#FFFFFF"
	elseif hover then
		background = "#808e9b"
		foreground = "#FFFFFF"
	else
		--background = edge_background
		background = "#303339"
		foreground = "#eeeeee"
	end

	local edge_foreground = background

	-- cut the title suffix if it's length more 27
	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	-- 如果只有一个 tab 就设定一个特殊的名称
	if tab.tab_index == 0 and #tabs == 1 then
		if not tab.tab_title or #tab.tab_title == 0 then
			title = "supc's Wezterm"
		end
	end

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

local config = {
	-- no gpu config
	-- prefer_egl=true,
	-- Spawn a fish shell in login mode
	--default_prog = { "c:/Users/supengchuan/scoop/apps/pwsh/current/pwsh.exe" },
--	default_prog = { "c:/Program Files/nu/bin/nu.exe" },
--	canonicalize_pasted_newlines = "LineFeed",
}

function Merge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				Merge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function SetFont()
	local M = {
		font_size = 18,
		underline_thickness = 3,
		underline_position = -4,
		font = wezterm.font_with_fallback({
			{ family = "Courier 10 Pitch", weight = 450, italic = false },
			--{ family = "FiraCode Nerd Font", weight = 450, italic = false },
			--{ family = "MesloLGL Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "UbuntuMono Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "Hack Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "Cousine Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "JetBrains Mono", weight = "Regular", italic = false },
			--{ family = "CommitMono Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "DejaVuSansM Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "Monofur Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "SauceCodePro Nerd Font Mono", weight = "Regular", italic = false },
			--{ family = "LXGW WenKai", weight = "Regular", italic = false },
		}),

		--font_rules = {
		--	{
		--		intensity = "Normal",
		--		italic = true,
		--		font = wezterm.font_with_fallback({
		--			{ family = "MesloLGS Nerd Font Mono", weight = "Regular", italic = false },
		--			{ family = "FiraCode Nerd Font Mono", weight = "Regular", italic = false },
		--			{ family = "MesloLGM Nerd Font Mono", weight = "Regular", italic = false },
		--			{ family = "JetBrains Mono", weight = "Regular", italic = false },
		--		}),
		--	},
		--},
	}

	return M
end

function SetColorTheme()
	-- code
	local color = ""
	color = "rose-pine"
	color = "Adventure"
	color = "Everforest Dark (Gogh)"
	color = "Tokyo Night Moon"
	color = "Catppuccin Frappe"
	color = "Catppuccin Mocha"
	color = "Dracula"
	color = "Dracula (Official)"
    color = 'One Dark (Gogh)'
	return {
		color_scheme = color,
	}
end

function SetTab()
	local M = {
		use_fancy_tab_bar = false,
		enable_tab_bar = true,
		hide_tab_bar_if_only_one_tab = true,
		tab_bar_at_bottom = false,
		tab_max_width = 30,
		colors = {
			tab_bar = {
				-- The color of the strip that goes along the top of the window
				-- (does not apply when fancy tab bar is in use)
				background = edge_background,
				--background = "rgb(30 31 41 / 90%)",
				new_tab = {
					bg_color = edge_background,
					fg_color = "#EEEEEE",
				},
			},
		},
	}
	return M
end

function SetWindow()
	-- code
	local M = {
		--window_decorations = "INTEGRATED_BUTTONS|RESIZE",
		--window_decorations = "RESIZE",
		integrated_title_buttons = { "Maximize", "Close" },
		window_background_opacity = 1,
		adjust_window_size_when_changing_font_size = false,
		initial_rows = 20,
		initial_cols = 80,
		window_padding = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		},
	}

	return M
end

function SetKeyMap()
	-- code
	local M = {
		keys = {
			{
				key = "+",
				mods = "CTRL|SHIFT",
				action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},
			{
				key = "_",
				mods = "CTRL|SHIFT",
				action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
			},
			{
				key = "8",
				mods = "CTRL",
				action = wezterm.action.PaneSelect,
			},
			{
				key = "h",
				mods = "ALT",
				action = wezterm.action.ActivatePaneDirection("Left"),
			},
			{
				key = "j",
				mods = "ALT",
				action = wezterm.action.ActivatePaneDirection("Down"),
			},
			{
				key = "k",
				mods = "ALT",
				action = wezterm.action.ActivatePaneDirection("Up"),
			},
			{
				key = "l",
				mods = "ALT",
				action = wezterm.action.ActivatePaneDirection("Right"),
			},
			{
				-- set tab title
				key = "O",
				mods = "CTRL|SHIFT",
				action = wezterm.action.PromptInputLine({
					description = "Enter new name for tab",
					action = wezterm.action_callback(function(window, pane, line)
						-- line will be `nil` if they hit escape without entering anything
						-- An empty string if they just hit enter
						-- Or the actual line of text they wrote
						if line then
							window:active_tab():set_title(line)
						end
					end),
				}),
			},
			{
				key = "T",
				mods = "ALT",
				action = wezterm.action.EmitEvent("toggle-tabbar"),
			},
		},
	}

	return M
end

function SetMouseMap()
	-- code
	local M = {
		mouse_bindings = {
			{
				event = { Down = { streak = 1, button = "Right" } },
				mods = "NONE",
				action = wezterm.action.PasteFrom("PrimarySelection"),
			},
		},
	}

	return M
end

config = Merge(config, SetFont())
config = Merge(config, SetWindow())
config = Merge(config, SetTab())
config = Merge(config, SetColorTheme())
config = Merge(config, SetKeyMap())
config = Merge(config, SetMouseMap())

-- 主要是需要通过一个 cell 的大小来计算有多少空余可以作为 padding
-- 然后在 top 位置上进行 padding, 如果直接使用 pane 的 get_dimensions, 
-- 拿到的直可能比实际可用的直小很多，从而padding的黑边比较大
local center = function(window, _)
	local overrides = window:get_config_overrides() or {}
	local tabsz = window:active_tab():get_size()
	if tabsz.rows == 0 or tabsz.cols == 0 then
		return
	end

	local cellheight = tabsz.pixel_height / tabsz.rows
	local cellwidth = tabsz.pixel_width / tabsz.cols
	if cellheight <= 0 or cellwidth <= 0 then
		return
	end

	local win_dim = window:get_dimensions()
	local window_height = win_dim.pixel_height
	local window_width = win_dim.pixel_width

	local pane_height = math.floor(window_height / cellheight) * cellheight
	local pand_width = math.floor(window_width / cellwidth) * cellwidth

	local new_padding = {
		left = math.floor((window_width - pand_width) / 2),
		right = 0,
		top = math.floor((window_height - pane_height) / 2),
		bottom = 0,
	}
	if overrides.window_padding and new_padding.top == overrides.window_padding.top then
		return
	end
	overrides.window_padding = new_padding
	window:set_config_overrides(overrides)
end

wezterm.on("window-config-reloaded", center)
return config
