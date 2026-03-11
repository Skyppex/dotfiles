vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

local kulala = require("kulala")

kulala.setup({
	default_env = "local",
	ui = {
		winbar = false,
		show_request_summary = false,
		disable_news_popup = true,
		win_opts = {
			wo = { foldmethod = "manual" },
		},
		max_response_size = 1048576,
	},
	global_keymaps = false,
	kulala_keymaps = false,
})

local ui = require("kulala.ui")

local utils = require("skypex.utils")
local map = utils.map
local pick = require("mini.pick")

local function get_rest_client_tab()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, value = pcall(vim.api.nvim_tabpage_get_var, tab, "rest_client_workspace")

		if ok and value then
			return tab
		end
	end

	return nil
end

local function pick_rest_file_and_open()
	pick.builtin.cli({
		command = {
			"fd",
			"--no-ignore",
			"--type=file",
			"--prune",
			"(http-client(.private)?.env.json$)|(.(http|rest)$)",
		},
	}, {
		source = {
			show = function(bufnr, items, query)
				pick.default_show(bufnr, items, query, {
					show_icons = true,
				})
			end,
		},
	})
end

local function open_rest_client_tab()
	local tab = get_rest_client_tab()

	if tab and vim.api.nvim_tabpage_is_valid(tab) then
		vim.api.nvim_set_current_tabpage(tab)
		return tab
	end

	vim.api.nvim_command("tabnew")
	vim.t.rest_client_workspace = true

	pick_rest_file_and_open()

	return vim.api.nvim_get_current_tabpage()
end

local function toggle_rest_client_tab()
	local tab = get_rest_client_tab()

	if not tab or not vim.api.nvim_tabpage_is_valid(tab) then
		return open_rest_client_tab()
	end

	local current = vim.api.nvim_get_current_tabpage()

	if current == tab then
		local first = vim.api.nvim_list_tabpages()[1]

		if first and vim.api.nvim_tabpage_is_valid(first) then
			vim.api.nvim_set_current_tabpage(first)
		end
	else
		vim.api.nvim_set_current_tabpage(tab)
	end
end

map("n", {
	"<c-w><c-r>",
	"<c-w>r",
}, toggle_rest_client_tab, "toggle rest client")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*.kulala_ui",
	callback = function(args)
		vim.cmd("normal! zE")
		local filetype = args.match:gsub("%.kulala_ui$", "")
		vim.api.nvim_set_option_value("filetype", filetype, { buf = args.buf })
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = args.buf })
		vim.api.nvim_set_option_value("bufhidden", "hide", { buf = args.buf })
		vim.api.nvim_set_option_value("swapfile", false, { buf = args.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function(args)
		local buf = args.buf
		map("n", "<c-r>", kulala.run, "Run http request", nil, buf)
		map("n", "ær", kulala.jump_next, "Goto the next request", nil, buf)
		map("n", "år", kulala.jump_prev, "Goto the previous request", nil, buf)
		map("n", "<leader>rb", ui.show_body, "Show response body", nil, buf)
		map("n", "<leader>rv", ui.show_verbose, "Show verbose response body", nil, buf)
		map("n", "<leader>rh", ui.show_headers_body, "Show headers", nil, buf)
		map("n", "<leader>rj", ui.show_next, "Show next request", nil, buf)
		map("n", "<leader>rk", ui.show_previous, "Show previous request", nil, buf)
		map("n", "<leader>ri", ui.inspect, "Inspect request", nil, buf)
		map("n", "<leader>rs", ui.show_stats, "Show stats for last request", nil, buf)
		map("n", "<leader>re", kulala.set_selected_env, "Set selected environment", nil, buf)

		map("n", "<leader>sf", function()
			pick.builtin.cli({
				command = {
					"fd",
					"--no-ignore",
					"--type=file",
					"--prune",
					"(http-client(.private)?.env.json$)|(.(http|rest)$)",
				},
			}, {
				source = {
					show = function(bufnr, items, query)
						pick.default_show(bufnr, items, query, {
							show_icons = true,
						})
					end,
				},
			})
		end, "search http files", nil, buf)
	end,
})
