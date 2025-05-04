-- Function to list all immediate directories
local function list_directories(path)
	local directories = {}
	local command = string.format('fd --type d --max-depth 1 --base-directory "%s"', path)
	local handle = io.popen(command)

	if handle == nil then
		vim.notify("Failed to call fd from lua", vim.log.levels.ERROR)
		return directories
	end

	local result = handle:read("*a")
	handle:close()

	for dir in result:gmatch("[^\r\n]+") do
		table.insert(directories, dir)
	end

	return directories
end

local vaults_path = vim.fn.expand("~") .. "/OneDrive/Obsidian/Vaults/"

-- Replace '/your/directory/path' with the path you want to list directories from
local vaults = list_directories(vaults_path)

local workspaces = {}
for _, vault in ipairs(vaults) do
	table.insert(workspaces, {
		name = vault,
		path = vaults_path .. vault,
	})
end

local obsidian = require("obsidian")
obsidian.setup({
	workspaces = workspaces,
	ui = {
		enable = false,
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	mappings = {
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = true, silent = true },
		},
		-- Toggle check-boxes.
		["<leader>ch"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { noremap = true, silent = true, buffer = true },
		},
		-- Smart action depending on context, either follow link or toggle checkbox.
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { noremap = true, silent = true, buffer = true, expr = true },
		},
	},
	picker = {
		name = "telescope.nvim",
		note_mappings = {
			insert_link = "<leader>il",
		},
		tag_mappings = {
			tag_note = "<leader>ot",
			insert_tag = "<leader>it",
		},
	},
})
