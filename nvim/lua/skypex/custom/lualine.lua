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

--- @generic T
--- @param active T
--- @param pending T
--- @param blocked T
--- @param none? T
--- @return T?
local function get_direnv_statusline(active, pending, blocked, none)
	local status = utils.direnv_status()

	if status == "none" then
		return none
	end

	if status == "blocked" then
		return blocked
	end

	if status == "pending" then
		return pending
	end

	if status == "active" then
		return active
	end
end

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = { left = "│", right = "" },
	},
	sections = {
		lualine_b = { {
			"filename",
			path = 1,
		}, "filetype" },
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
					return get_direnv_statusline("󰌪", "󱋙", "󱋙", "")
				end,
				color = function()
					if not utils.is_linux() then
						return
					end

					local colors = require("skypex.colors")
					return get_direnv_statusline({
						fg = colors.success,
					}, {
						fg = colors.working,
					}, {
						fg = colors.error,
					})
				end,
			},
		},
	},
})
