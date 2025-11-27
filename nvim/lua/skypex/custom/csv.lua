local csvview = require("csvview")
csvview.setup({
	parser = { comments = { "#", "//" } },
	keymaps = {
		-- Text objects for selecting fields
		textobject_field_inner = { "if", mode = { "o", "x" } },
		textobject_field_outer = { "af", mode = { "o", "x" } },
		-- Excel-like navigation:
		-- Use <Tab> and <S-Tab> to move horizontally between fields.
		-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
		-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
		jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
		jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
		jump_next_row = { "<Enter>", mode = { "n", "v" } },
		jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
	},
	view = {
		display_mode = "border",
	},
})

local function enable_csv_view(buf)
	vim.bo[buf].textwidth = 0

	vim.api.nvim_buf_call(buf, function()
		vim.cmd("CsvViewEnable")
	end)
end

-- enable columnar view on the initially opened csv file
enable_csv_view(vim.api.nvim_get_current_buf())

-- enable columnar view on the subsequently opened csv files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.csv", "*.tsv" },
	callback = function(args)
		enable_csv_view(args.buf)
	end,
})

local map = require("skypex.utils").map

map("n", "<leader>tv", "<cmd>CsvViewToggle<cr>", "Toggle columnar view")
