return {
	"skyppex/nvim-http",
	dir = "d:/code/nvim-http",
	dev = true,
	ft = { "http" },
	config = function()
		vim.keymap.set(
			{ "n", "v" },
			"<leader>rr",
			"<cmd>Http<cr>",
			{ desc = "Run http request", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>rs",
			"<cmd>HttpStop<cr>",
			{ desc = "Stop http request", noremap = true, silent = true }
		)
	end,
	-- {
	-- 	"diepm/vim-rest-console",
	-- 	config = function()
	-- 		vim.g.vrc_set_default_mapping = 0
	-- 		vim.g.vrc_respone_default_content_type = "application/json"
	-- 		vim.g.vrc_output_buffer_name = "respone"
	-- 		vim.g.vrc_auto_format_response_patterns = {
	-- 			json = "jq",
	-- 		}
	--
	-- 		vim.keymap.set(
	-- 			{ "n", "v" },
	-- 			"<leader>rr",
	-- 			"<cmd>call VrcQuery()<cr>",
	-- 			{ desc = "Run http request", noremap = true, silent = true }
	-- 		)
	-- 	end,
	-- },
}
