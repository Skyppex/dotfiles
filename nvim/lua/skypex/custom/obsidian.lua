local utils = require("skypex.utils")
local Path = require("plenary.path")

utils.run_command(
	"fd",
	{
		"--type=dir",
		"--hidden",
		"--no-ignore",
		"--absolute-path",
		"--max-depth=4",
		"\\.obsidian",
		utils.get_home(),
		utils.get_code_path(),
	},
	false,
	function(data, exit_code)
		if exit_code ~= 0 then
			return
		end

		local workspaces = {}

		local dedupe = utils.deduplicate(data)

		if not dedupe then
			return
		end

		for _, dir in ipairs(dedupe) do
			local path = Path:new(dir)

			local parent = path:parent().filename
			local dirname = utils.basename(parent)

			table.insert(workspaces, {
				name = dirname,
				path = parent,
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
				name = "mini.pick",
				note_mappings = {
					insert_link = "<leader>il",
				},
				tag_mappings = {
					tag_note = "<leader>ot",
					insert_tag = "<leader>it",
				},
			},
			frontmatter = {
				enabled = false,
			},
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "ObsidianNoteEnter",
			callback = function(ev)
				utils.map("n", "gd", "<cmd>Obsidian follow_link<cr>", "Open note under cursor", nil, ev.buf)
				utils.map("n", "<leader>tc", "<cmd>Obsidian toggle_checkbox<cr>", "Open note under cursor", nil, ev.buf)
			end,
		})
	end
)
