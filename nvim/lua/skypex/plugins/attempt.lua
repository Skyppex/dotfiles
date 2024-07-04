return {
	"m-demare/attempt.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = "nvim-telescope/telescope.nvim",
	config = function()
		local attempt = require("attempt")

		attempt.setup({
			ext_options = { "lua", "py", "cs", "rs", "ar", "" },
			run = {
				cs = { "w", "!dotnet script %" },
				py = { "w !python" }, -- Either table of strings or lua functions
				js = { "w !node" },
				lua = { "w", "luafile %" },
				rs = { "w", "!rustc % && nu -c 'let ex = (echo %' | str replace '.rs' ''); exec $ex" },
				ar = { "w", "!mage %" },
			},
		})

		require("telescope").load_extension("attempt")

		vim.keymap.set("n", "<leader>AN", attempt.new_select, {
			desc = "New Attempt",
			noremap = true,
			silent = true,
		}) -- new attempt, selecting extension
		vim.keymap.set("n", "<leader>AI", attempt.new_input_ext, {
			desc = "New Attempt By Extension",
			noremap = true,
			silent = true,
		}) -- new attempt, inputing extension
		vim.keymap.set("n", "<leader>AR", attempt.run, {
			desc = "Run Attempt",
			noremap = true,
			silent = true,
		}) -- run attempt
		vim.keymap.set("n", "<leader>AD", attempt.delete_buf, {
			desc = "Delete Attempt",
			noremap = true,
			silent = true,
		}) -- delete attempt from current buffer
		vim.keymap.set("n", "<leader>AC", attempt.rename_buf, {
			desc = "Rename Attempt",
			noremap = true,
			silent = true,
		}) -- rename attempt from current buffer
		vim.keymap.set("n", "<leader>AS", "<cmd>Telescope attempt<CR>", {
			desc = "Search Attempts",
			noremap = true,
			silent = true,
		}) -- search through attempts
	end,
}
