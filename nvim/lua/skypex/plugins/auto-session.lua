return {
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				auto_session_enable_last_session = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = true,
				auto_restore_enabled = true,
				auto_session_suppress_dirs = {
					"~/",
					"~/Projects",
					"~/Downloads",
					"/",
				},
			})

			local sl = require("auto-session.session-lens")
			vim.keymap.set("n", "<leader>sh", function()
				sl.search_session()
			end, { noremap = true, silent = true })
		end,
	},
}
