local db = require("dbee")

db.setup({
	drawer = {
		candies = {
			history = {
				icon = "",
				icon_highlight = "@constant",
				text_highlight = "",
			},
			note = {
				icon = "",
				icon_highlight = "@character",
				text_highlight = "",
			},
			connection = {
				icon = "󱘖",
				icon_highlight = "@field",
				text_highlight = "",
			},
			database_switch = {
				icon = "",
				icon_highlight = "@keyword",
				text_highlight = "",
			},
			schema = {
				icon = "",
				icon_highlight = "@type",
				text_highlight = "",
			},
			table = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			streaming_table = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			managed = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			view = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			materialized_view = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			sink = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			column = {
				icon = "󰠵",
				icon_highlight = "@constant",
				text_highlight = "",
			},
			add = {
				icon = "",
				icon_highlight = "@string",
				text_highlight = "@string",
			},
			edit = {
				icon = "󰏫",
				icon_highlight = "@macro",
				text_highlight = "@macro",
			},
			remove = {
				icon = "󰆴",
				icon_highlight = "DiagnosticError",
				text_highlight = "DiagnosticError",
			},
			help = {
				icon = "󰋖",
				icon_highlight = "DiagnosticWarn",
				text_highlight = "DiagnosticWarn",
			},
			source = {
				icon = "󰃖",
				icon_highlight = "@type",
				text_highlight = "Directory",
			},

			-- if there is no type
			-- use this for normal nodes...
			none = {
				icon = " ",
				icon_highlight = "",
				text_highlight = "",
			},
			-- ...and use this for nodes with children
			none_dir = {
				icon = "",
				icon_highlight = "Type",
				text_highlight = "",
			},

			-- chevron icons for expanded/closed nodes
			node_expanded = {
				icon = "",
				icon_highlight = "@punctuation",
				text_highlight = "",
			},
			node_closed = {
				icon = "",
				icon_highlight = "@punctuation",
				text_highlight = "",
			},
		},
	},
	editor = {
		mappings = {
			-- run what's currently selected on the active connection
			{ key = "<c-r>", mode = "v", action = "run_selection" },
			-- run the whole file on the active connection
			{ key = "<c-r>", mode = "n", action = "run_file" },
			-- run what's under the cursor to the next newline
			{ key = "<s-r>", mode = "n", action = "run_under_cursor" },
		},
	},
	result = {
		focus_result = false,
	},
})

local function get_db_client_tab()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, value = pcall(vim.api.nvim_tabpage_get_var, tab, "db_client_workspace")

		if ok and value then
			return tab
		end
	end

	return nil
end

local function open_db_client_tab()
	local tab = get_db_client_tab()

	if tab and vim.api.nvim_tabpage_is_valid(tab) then
		vim.api.nvim_set_current_tabpage(tab)
		return tab
	end

	vim.api.nvim_command("tabnew")
	vim.t.db_client_workspace = true

	db.open()

	return vim.api.nvim_get_current_tabpage()
end

local function toggle_db_client_tab()
	local tab = get_db_client_tab()

	if not tab or not vim.api.nvim_tabpage_is_valid(tab) then
		return open_db_client_tab()
	end

	local current_tab = vim.api.nvim_get_current_tabpage()

	if current_tab == tab then
		local first = vim.api.nvim_list_tabpages()[1]

		if first and vim.api.nvim_tabpage_is_valid(first) then
			vim.api.nvim_set_current_tabpage(first)
		end
	else
		vim.api.nvim_set_current_tabpage(tab)
	end
end

local map = require("skypex.utils").map

map("n", {
	"<c-w><c-b>",
	"<c-w>b",
}, function()
	toggle_db_client_tab()
end, "toggle db client")

map("n", "<leader>bl", db.api.ui.next_result_set, "next result set")
map("n", "<leader>bh", db.api.ui.prev_result_set, "previous result set")
