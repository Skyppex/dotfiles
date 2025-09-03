local utils = require("skypex.utils")

local theme

if utils.is_linux() then
	local colors = require("skypex.colors")

	theme = {
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
else
	local andromeda_colors = require("skypex.utils").andromeda

	theme = {
		normal = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.pink, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
		insert = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.green, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
		visual = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.yellow, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
		replace = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.blue, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
		command = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.orange, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
		inactive = {
			a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.gray, gui = "bold" },
			b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
			c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
		},
	}
end

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
		lualine_x = {},
	},
})
