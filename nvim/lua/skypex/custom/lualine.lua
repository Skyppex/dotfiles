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
local function direnv_status(active, pending, blocked, none)
	local lines = utils.run_command_ret("direnv", { "status", "--json" })

	if not lines then
		return none
	end

	local json = ""

	for _, line in ipairs(lines) do
		json = json .. line
	end

	local ok, result = pcall(vim.json.decode, json)

	if not ok then
		return none
	end

	local foundRC = result.state.foundRC

	if not foundRC or foundRC == vim.NIL then
		return none
	end

	local status = foundRC.allowed

	if status == 0 then
		return active
	end

	if status == 1 then
		return pending
	end

	if status == 2 then
		return blocked
	end

	return none
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
					return direnv_status("󰌪", "󱋙", "󱋙", "")
				end,
				color = function()
					if not utils.is_linux() then
						return
					end

					local colors = require("skypex.colors")
					return direnv_status({
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
