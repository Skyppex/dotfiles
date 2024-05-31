return {
	{
		"smoka7/hop.nvim",
		version = "v2",
		config = function()
			local hop = require("hop")
			local hint = require("hop.hint")

			hop.setup({
				keys = "qweasdzxcyuiohjklnm",
				quit_key = "<C-c>",
				multi_windows = true,
			})

			vim.keymap.set({ "n", "v" }, "<leader>hh", function()
				hop.hint_char1()
			end, { desc = "Hop to character 1" })

			vim.keymap.set({ "n", "v" }, "<leader>hj", function()
				hop.hint_char2()
			end, { desc = "Hop to character 2" })

			vim.keymap.set({ "n", "v" }, "<leader>hp", function()
				hop.hint_patterns()
			end, { desc = "Hop to pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hep", function()
				hop.hint_patterns({ hint_position = hint.HintPosition.END })
			end, { desc = "Hop to end of pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hmp", function()
				hop.hint_patterns({ hint_position = hint.HintPosition.MIDDLE })
			end, { desc = "Hop to middle of pattern" })

			vim.keymap.set({ "n", "v" }, "<leader>hw", function()
				hop.hint_words()
			end, { desc = "Hop to word" })

			vim.keymap.set({ "n", "v" }, "<leader>hew", function()
				hop.hint_words({ hint_position = hint.HintPosition.END })
			end, { desc = "Hop to end of word" })

			vim.keymap.set({ "n", "v" }, "<leader>hmw", function()
				hop.hint_words({ hint_position = hint.HintPosition.MIDDLE })
			end, { desc = "Hop to middle of word" })

			vim.keymap.set({ "n", "v" }, "<leader>hl", function()
				hop.hint_lines_skip_whitespace()
			end, { desc = "Hop to line start" })

			--vim.keymap.set({ "n", "v" }, "<leader>hl", ":HopLineStart<CR>", { desc = "Hop to line start" })
		end,
	},
}
