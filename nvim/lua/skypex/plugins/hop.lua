return {
	{
		"smoka7/hop.nvim",
		event = { "BufReadPre", "BufNewFile" },
		version = "v2",
		config = function()
			local function trigger_hop_command(cmd, opts, cmdname)
				vim.notify("trigger_hop_command: " .. cmdname)
				vim.api.nvim_command("doautocmd User " .. cmdname)
				cmd(opts)
			end
			local hop = require("hop")
			local hint = require("hop.hint")

			hop.setup({
				keys = "qweasdzxcyuiohjklnm,.",
				quit_key = "<C-c>",
				multi_windows = true,
			})

			vim.keymap.set({ "n", "v" }, "<leader>hh", function()
				trigger_hop_command(hop.hint_char1, {}, "HopChar1")
			end, { desc = "Hop to character 1" })

			vim.keymap.set({ "n", "v" }, "<leader>hj", function()
				trigger_hop_command(hop.hint_char2, {}, "HopChar2")
			end, { desc = "Hop to character 2" })

			vim.keymap.set({ "n", "v" }, "<leader>hk", function()
				trigger_hop_command(hop.hint_patterns, {}, "HopPattern")
			end, { desc = "Hop to pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hep", function()
				trigger_hop_command(hop.hint_patterns, { hint_position = hint.HintPosition.END }, "HopPattern")
			end, { desc = "Hop to end of pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hmp", function()
				trigger_hop_command(hop.hint_patterns, { hint_position = hint.HintPosition.MIDDLE }, "HopPattern")
			end, { desc = "Hop to middle of pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hw", function()
				trigger_hop_command(hop.hint_words, {}, "HopWord")
			end, { desc = "Hop to word" })

			vim.keymap.set({ "n", "v" }, "<leader>hew", function()
				trigger_hop_command(hop.hint_words, { hint_position = hint.HintPosition.END }, "HopWord")
			end, { desc = "Hop to end of word" })

			vim.keymap.set({ "n", "v" }, "<leader>hmw", function()
				trigger_hop_command(hop.hint_words, { hint_position = hint.HintPosition.MIDDLE }, "HopWord")
			end, { desc = "Hop to middle of word" })

			vim.keymap.set({ "n", "v" }, "<leader>hl", function()
				trigger_hop_command(hop.hint_lines_skip_whitespace, {}, "HopLineStart")
			end, { desc = "Hop to line start" })
		end,
	},
}
