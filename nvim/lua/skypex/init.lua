require("skypex.config")
require("skypex.remap")
skate = require("skypex.skate")

local kite = require("skypex.kite")
kite.setup()

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.json",
	callback = function(args)
		local function toggle(fold, unfold)
			return function()
				if kite.is_on_closed_fold() then
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
			toggle(kite.fold_closest_block, kite.unfold_closest_block),
			"toggle block block",
			nil,
			args.buf
		)

		map(
			"n",
			"<leader>Z",
			toggle(kite.fold_closest_block_recursive, kite.unfold_closest_block_recursive),
			"toggle recursive block fold",
			nil,
			args.buf
		)
	end,
})
