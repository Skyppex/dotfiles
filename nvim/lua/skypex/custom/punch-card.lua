local nmap = require("skypex.utils").nmap

--- @type PunchCard
local punch_card = require("punch-card")

--- @type PunchCardOpts
local opts = {
	hooks = {
		after_win_open = function(buf, win)
			-- disable scrolling
			vim.api.nvim_set_option_value("scrolloff", 0, { win = win })
			vim.api.nvim_set_option_value("sidescrolloff", 0, { win = win })
			vim.api.nvim_set_option_value("wrap", false, { win = win })
			vim.api.nvim_set_option_value("scroll", 0, { win = win })

			local scrolling_inputs = {
				"<C-f>",
				"<C-b>",
				"zz",
				"zt",
				"zb",
				"<ScrollWheelUp>",
				"<ScrollWheelDown>",
				"<ScrollWheelLeft>",
				"<ScrollWheelRight>",
				"<S-ScrollWheelUp>",
				"<S-ScrollWheelDown>",
				"<S-ScrollWheelLeft>",
				"<S-ScrollWheelRight>",
				"<C-ScrollWheelUp>",
				"<C-ScrollWheelDown>",
				"<C-ScrollWheelLeft>",
				"<C-ScrollWheelRight>",
			}

			for _, v in ipairs(scrolling_inputs) do
				vim.keymap.set({ "n", "v", "i", "x", "o" }, v, function()
					return "<nop>"
				end, { buffer = buf, noremap = true, silent = true, expr = false })
			end

			-- add buf-local binds to save and close
			nmap("q", punch_card.save_and_close, "Save and close punch-card editor", nil, buf)
			nmap("<esc>", punch_card.save_and_close, "Save and close punch-card editor", nil, buf)
		end,
	},
}

punch_card.setup(opts)

nmap("<leader>R", punch_card.open, "Open punch-card editor")
