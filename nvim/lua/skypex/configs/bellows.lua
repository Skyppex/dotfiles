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

		local stats, err, err_name = vim.uv.fs_stat(path)

		if err ~= nil then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

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

		local map = require("skypex.utils").map

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
