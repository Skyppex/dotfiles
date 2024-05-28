return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "dracula",
			},
			sections = {
				lualine_c = {
					require("auto-session.lib").current_session_name,
				},
			},
		},
	},
}
