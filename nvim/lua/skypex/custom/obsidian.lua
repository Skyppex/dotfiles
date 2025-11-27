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

local vaults_path

local utils = require("skypex.utils")

if utils.is_home_computer_windows() then
	vaults_path = utils.get_home() .. "/OneDrive/Obsidian/Vaults/"
else
	vaults_path = utils.get_home() .. "/obsidian/Vaults/"
end

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
	legacy_commands = false,
	workspaces = workspaces,
	ui = {
		enable = false,
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
		create_new = false,
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
	disable_frontmatter = true,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "ObsidianNoteEnter",
	callback = function(ev)
		utils.map("n", "gd", "<cmd>Obsidian follow_link<cr>", "Open note under cursor", nil, ev.buf)
		utils.map("n", "<leader>tc", "<cmd>Obsidian toggle_checkbox<cr>", "Open note under cursor", nil, ev.buf)
	end,
})
