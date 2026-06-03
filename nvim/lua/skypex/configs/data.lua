local utils = require("skypex.utils")
local map = require("skypex.utils").map

-- json
local bellows = require("bellows")
bellows.setup()

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function(args)
		local buf = args.buf
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

		if filetype ~= "json" then
			return
		end

		local path = vim.api.nvim_buf_get_name(buf)

		local stats, err, _ = vim.uv.fs_stat(path)

		if err ~= nil then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		---@diagnostic disable-next-line: need-check-nil
		if stats.size > 1048576 then
			vim.notify("json file larger than 1MiB. bellows disabled.")
			return
		end

		local function toggle(condition, false_func, true_func)
			return function()
				if condition() then
					true_func()
				else
					false_func()
				end
			end
		end

		map(
			"n",
			"<leader>z",
			toggle(bellows.is_on_closed_fold, bellows.fold_closest_block, bellows.unfold_closest_block),
			"toggle block block",
			nil,
			args.buf
		)

		map(
			"n",
			"<leader>Z",
			toggle(
				bellows.is_on_closed_fold,
				bellows.fold_closest_block_recursive,
				bellows.unfold_closest_block_recursive
			),
			"toggle recursive block fold",
			nil,
			args.buf
		)

		map("nxo", "æz", bellows.jump_next_closed_fold, "goto next fold")
		map("nxo", "åz", bellows.jump_prev_closed_fold, "goto prev fold")

		map(
			"n",
			"<leader>b",
			toggle(bellows.is_pinned, bellows.pin, bellows.unpin),
			"toggle pin on property",
			nil,
			args.buf
		)

		map("n", "<leader>B", bellows.clear_pins, "clear all pins", nil, args.buf)

		map("nxo", "æb", bellows.jump_next_pin, "goto next fold")
		map("nxo", "åb", bellows.jump_prev_pin, "goto prev fold")
	end,
})

local jq = require("jq-playground")

local jq_output_name = "jq-out"
local jq_query_name = "jq-query"

jq.setup({
	cmd = { "jq" },
	output_window = {
		split_direction = "right",
		width = nil,
		height = nil,
		scratch = true,
		filetype = "json",
		name = jq_output_name,
	},
	query_window = {
		split_direction = "below",
		width = nil,
		height = 0.3,
		scratch = true,
		filetype = "jq",
		name = jq_query_name,
	},
})

map("n", "<leader>tj", function()
	local visible = false
	local jq_output_buf = utils.bufs_by_name(jq_output_name)

	if jq_output_buf ~= nil then
		if utils.is_buf_visible(jq_output_buf) then
			visible = true
		end

		vim.api.nvim_buf_delete(jq_output_buf, { force = true })
	end

	local jq_query_buf = utils.bufs_by_name(jq_query_name)

	if jq_query_buf ~= nil then
		if utils.is_buf_visible(jq_query_buf) then
			visible = true
		end

		vim.api.nvim_buf_delete(jq_query_buf, { force = true })
	end

	if not visible then
		jq.open()
	end
end, "toggle jq playground")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if vim.b.jqplayground_inputbuf == nil then
			return
		end

		vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, { "." })
	end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	callback = function()
		if vim.b.jqplayground_inputbuf == nil then
			return
		end

		jq.run_query()
	end,
})

-- csv
local function enable_csv_view(buf)
	vim.bo[buf].textwidth = 0

	vim.api.nvim_buf_call(buf, function()
		vim.cmd("CsvViewEnable")
	end)
end

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

-- enable columnar view on the subsequently opened csv files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.csv", "*.tsv" },
	callback = function(args)
		enable_csv_view(args.buf)
	end,
})

map("n", "<leader>tv", "<cmd>CsvViewToggle<cr>", "Toggle columnar view")
