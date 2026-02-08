local bellows = require("bellows")
bellows.setup()

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.json",
	callback = function(args)
		local function toggle(fold, unfold)
			return function()
				if bellows.is_on_closed_fold() then
					unfold()
				else
					fold()
				end
			end
		end

		local map = require("skypex.utils").map

		map(
			"n",
			"<leader>z",
			toggle(bellows.fold_closest_block, bellows.unfold_closest_block),
			"toggle block block",
			nil,
			args.buf
		)

		map(
			"n",
			"<leader>Z",
			toggle(bellows.fold_closest_block_recursive, bellows.unfold_closest_block_recursive),
			"toggle recursive block fold",
			nil,
			args.buf
		)

		map("nxo", "æz", bellows.jump_next_closed_fold, "goto next fold")
		map("nxo", "åz", bellows.jump_prev_closed_fold, "goto prev fold")
	end,
})
