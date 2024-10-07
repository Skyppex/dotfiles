require("harpoon").setup({
	global_settings = {
		-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
		save_on_toggle = false,

		-- saves the harpoon file upon every change. disabling is unrecommended.
		save_on_change = true,

		-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
		enter_on_sendcmd = false,

		-- filetypes that you want to prevent from adding to the harpoon list menu.
		excluded_filetypes = {},

		-- set marks specific to each git branch inside git repository
		mark_branch = false,

		-- enable tabline with harpoon marks
		tabline = false,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
})

require("telescope").load_extension("harpoon")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local nmap = require("skypex.utils").nmap

nmap("<leader>a", mark.add_file, "Add File to Harpoon")
nmap("<leader>e", ui.toggle_quick_menu, "Toggle Harpoon Menu")

nmap("<A-h>", function()
	ui.nav_file(1)
end, "Navigate to Harpoon File 1")

nmap("<A-j>", function()
	ui.nav_file(2)
end, "Navigate to Harpoon File 2")

nmap("<A-k>", function()
	ui.nav_file(3)
end, "Navigate to Harpoon File 3")

nmap("<A-l>", function()
	ui.nav_file(4)
end, "Navigate to Harpoon File 4")

nmap("<A-n>", function()
	ui.nav_file(5)
end, "Navigate to Harpoon File 5")

nmap("<A-m>", function()
	ui.nav_file(6)
end, "Navigate to Harpoon File 6")

nmap("<A-,>", function()
	ui.nav_file(7)
end, "Navigate to Harpoon File 7")

nmap("<A-.>", function()
	ui.nav_file(8)
end, "Navigate to Harpoon File 8")
