return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>c_", hidden = true },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>d_", hidden = true },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>g_", hidden = true },
				{ "<leader>gh", group = "[G]it [H]unk" },
				{ "<leader>gh", desc = "[G]it [H]unk", mode = "v" },
				{ "<leader>gh_", hidden = true },
				{ "<leader>h", group = "[H]op" },
				{ "<leader>h_", hidden = true },
				{ "<leader>m", group = "[M]isc" },
				{ "<leader>m_", hidden = true },
				{ "<leader>p", group = "[P]roject" },
				{ "<leader>p_", hidden = true },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>r_", hidden = true },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>s_", hidden = true },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>t_", hidden = true },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>w_", hidden = true },
				{ "<leader>A", group = "[A]ttempt" },
				{ "<leader>A_", hidden = true },
			})
		end,
	},
}
