local utils = require("skypex.utils")
local colors = require("skypex.colors")

local theme = {
	normal = {
		a = { bg = colors.background2, fg = colors.pink, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	insert = {
		a = { bg = colors.background2, fg = colors.green, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	visual = {
		a = { bg = colors.background2, fg = colors.yellow, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	replace = {
		a = { bg = colors.background2, fg = colors.blue, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	command = {
		a = { bg = colors.background2, fg = colors.orange, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	inactive = {
		a = { bg = colors.background2, fg = colors.gray, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
}

---| "not_loaded" # load() has not been called yet.
---| "loading"    # A load is in progress.
---| "loaded"     # The devenv environment is applied.
---| "none"       # No devenv project was found for the root.
---| "blocked"    # The project exists but has not been trusted with `devenv allow`.
---| "failed"     # devenv ran but failed; see `err`.
---
--- @generic T
--- @param not_loaded T
--- @param loading T
--- @param loaded T
--- @param blocked T
--- @param failed T
--- @param none? T
--- @return T?
local function get_devenv_statusline(not_loaded, loading, loaded, blocked, failed)
	local status = require("devenv").status()

	if status == "not_loaded" then
		return not_loaded
	end

	if status == "loading" then
		return loading
	end

	if status == "loaded" then
		return loaded
	end

	if status == "blocked" then
		return blocked
	end

	if status == "failed" then
		return failed
	end

	if status == "none" then
		return none
	end
end

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = { left = "│", right = "" },
		globalstatus = true,
		disabled_filetypes = {
			winbar = { "help" },
		},
	},
	sections = {
		lualine_b = {
			{ "filename", path = 1 },
			"filetype",
			{
				"diagnostics",

				-- Table of diagnostic sources, available sources are:
				--   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
				-- or a function that returns a table as such:
				--   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
				sources = { "nvim_diagnostic" },

				-- Displays diagnostics for the defined severity types
				sections = { "error", "warn" },

				diagnostics_color = {
					-- Same values as the general color option can be used here.
					error = require("colorbuddy").colors.error,
					warn = require("colorbuddy").colors.warn,
				},

				symbols = {
					error = " ",
					warn = " ",
				},
				colored = true, -- Displays diagnostics status in color if set to true.
				update_in_insert = true, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.
			},
		},
		lualine_c = {
			{
				function()
					local filetype = vim.bo.filetype

					if filetype == "http" or filetype == "rest" then
						return require("kulala").get_selected_env()
					end

					return ""
				end,
			},
		},
		lualine_x = {
			{
				function()
					return get_devenv_statusline("󱋙", "󱋙", "󰌪", "󰂭", "󱋙", "")
				end,
				color = function()
					if not utils.is_linux() then
						return
					end

					local colors = require("skypex.colors")
					return get_devenv_statusline({
						fg = colors.inactive,
					}, {
						fg = colors.working,
					}, {
						fg = colors.success,
					}, {
						fg = colors.error,
					}, {
						fg = colors.error,
					})
				end,
			},
		},
	},
})
