local telescope = require("telescope")
-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
telescope.setup({
	-- You can put your default mappings / updates / etc. in here
	--  All the info you're looking for is in `:help telescope.setup()`
	--
	defaults = {
		path_display = { "tail" },
		-- mappings = {
		--   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
		-- },
	},
	-- pickers = {}
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
		fzf = {},
	},
})

-- Enable Telescope extensions if they are installed
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "fzf")

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")

local nmap = require("skypex.utils").nmap

nmap("<leader>sh", builtin.help_tags, "Search Help")
nmap("<leader>sk", builtin.keymaps, "Search Keymaps")
nmap("<leader>sf", builtin.git_files, "Search Git Files")
nmap("<leader>sc", builtin.git_commits, "Search Commits")
nmap("<leader>st", builtin.builtin, "Search Telescope builtin")
nmap("<leader>sd", builtin.diagnostics, "Search Diagnostics")
nmap("<leader>sr", builtin.resume, "Search Resume")
nmap("<leader>sb", builtin.buffers, "Search existing Buffers")

nmap("<C-p>", function()
	builtin.find_files({ path_display = { "absolute" } })
end, "Search Files")

nmap("<leader>sg", function()
	local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
	git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir

	local opts = {
		cwd = git_dir,
	}

	builtin.live_grep(opts)
end, "Search Git files by grep")

-- Slightly advanced example of overriding default behavior and theme
nmap("<leader>/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, "[/] Fuzzily search in current buffer")

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
nmap("<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, "Search [/] in Open Files")
