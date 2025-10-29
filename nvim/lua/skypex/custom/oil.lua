local M = {}

--- @param path string
--- @return string
local function find_csproj_file(path)
	local csproj_file = vim.fn.glob(path .. "/*.csproj")
	if csproj_file ~= "" then
		return csproj_file
	end

	local parent_path = vim.fn.fnamemodify(path, ":h")

	if parent_path == path then
		return ""
	end

	return find_csproj_file(parent_path)
end

--- @return string
local function get_root_namespace(filename)
	local path = vim.fn.fnamemodify(filename, ":h"):gsub("\\", "/")
	local csproj_file = find_csproj_file(path):gsub("\\", "/")

	if csproj_file ~= "" then
		local prefix = vim.fn.fnamemodify(csproj_file, ":h")

		local root = path:gsub(prefix, ""):gsub("/src", ""):gsub("/tests", ""):gsub("/test", "")

		for line in io.lines(csproj_file) do
			local namespace = line:match("<RootNamespace>(.-)</RootNamespace>")

			if namespace then
				return namespace .. root
			end
		end

		local name = vim.fn.fnamemodify(csproj_file, ":t:r")
		return name .. root
	else
		return ""
	end
end

local function insert_namespace_in_cs_file(filename)
	local namespace = get_root_namespace(filename)

	if namespace == "" then
		return
	end

	local file = io.open(filename, "w")

	if file then
		file:write("namespace " .. namespace:gsub("/", ".") .. ";\n\n")
		file:close()
	end
end

M.oil = function()
	require("oil").setup({
		default_file_explorer = true,
		delete_to_trash = false,
		skip_confirm_for_simple_edits = true,
		win_options = {
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = false,
			is_hidden_file = function(name, _)
				return vim.startswith(name, "..")
			end,
		},
		case_insensitive = true,
		use_default_keymaps = false,
		float = {
			-- Padding around the floating window
			padding = 10,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- This is the config that will be passed to nvim_open_win.
			-- Change values here to customize the layout
			override = function(conf)
				return conf
			end,
		},
		keymaps = {
			["L"] = "actions.select",
			["<leader>"] = "actions.preview",
			["H"] = "actions.parent",
			["<C-r>"] = "actions.refresh",
		},
	})

	local utils = require("skypex.utils")
	utils.nmap("<leader>v", "<cmd>Oil<CR>", "Toggle file explorer")

	vim.api.nvim_create_autocmd("User", {
		pattern = "OilActionsPost",
		callback = function(args)
			if args.data.err ~= nil then
				return
			end

			for _, action in ipairs(args.data.actions) do
				if action.type ~= "create" then
					goto continue
				end

				local path = action.url
				if utils.is_linux() then
					path = path:gsub("oil://", "")
				else
					path = path:gsub("oil:///", "")
					path = path:sub(1, 1) .. ":" .. path:sub(2)
				end

				if not path:match("%.cs$") then
					goto continue
				end

				insert_namespace_in_cs_file(path)
				::continue::
			end
		end,
	})
end

M.oil_vcs = function()
	local status_const = require("oil-vcs-status.constant.status")
	local StatusType = status_const.StatusType

	require("oil-vcs-status").setup({
		status_symbol = {

			[StatusType.Added] = "+",
			[StatusType.Copied] = "c",
			[StatusType.Deleted] = "✘",
			[StatusType.Ignored] = "i",
			[StatusType.Modified] = "!",
			[StatusType.Renamed] = "m",
			[StatusType.TypeChanged] = "t",
			[StatusType.Unmodified] = " ",
			[StatusType.Unmerged] = "",
			[StatusType.Untracked] = "?",
			[StatusType.External] = "e",

			[StatusType.UpstreamAdded] = "󰈞",
			[StatusType.UpstreamCopied] = "󰈢",
			[StatusType.UpstreamDeleted] = "",
			[StatusType.UpstreamIgnored] = " ",
			[StatusType.UpstreamModified] = "󰏫",
			[StatusType.UpstreamRenamed] = "",
			[StatusType.UpstreamTypeChanged] = "󱧶",
			[StatusType.UpstreamUnmodified] = " ",
			[StatusType.UpstreamUnmerged] = "",
			[StatusType.UpstreamUntracked] = "",
			[StatusType.UpstreamExternal] = "",
		},
		status_priority = {
			[StatusType.UpstreamIgnored] = 0,
			[StatusType.UpstreamUntracked] = 1,
			[StatusType.UpstreamUnmodified] = 2,

			[StatusType.UpstreamCopied] = 3,
			[StatusType.UpstreamRenamed] = 3,
			[StatusType.UpstreamTypeChanged] = 3,

			[StatusType.UpstreamDeleted] = 4,
			[StatusType.UpstreamModified] = 4,
			[StatusType.UpstreamAdded] = 4,

			[StatusType.UpstreamUnmerged] = 5,

			[StatusType.Ignored] = 10,
			[StatusType.Untracked] = 11,
			[StatusType.Unmodified] = 12,

			[StatusType.Copied] = 13,
			[StatusType.Renamed] = 13,
			[StatusType.TypeChanged] = 13,

			[StatusType.Deleted] = 14,
			[StatusType.Modified] = 14,
			[StatusType.Added] = 14,

			[StatusType.Unmerged] = 15,
		},
	})
end

M.all = function()
	M.oil()
	M.oil_vcs()
end

M.all()

return M
