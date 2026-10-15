local tandem = require("tandem")

tandem.setup({
	cmd = { "nix", "shell", "--impure", "nixpkgs#claude-code", "--command", "claude" },
	env = { NIXPKGS_ALLOW_UNFREE = "1" },
	-- Claude must never write to disk on its own; tandem's MCP tools replace
	-- these, and Read is replaced so Claude sees its own pending edits.
	disallowed_tools = { "Read", "Edit", "Write", "MultiEdit", "NotebookEdit" },
	chat = {
		width = 80,
	},
	list = {
		height = 10,
	},
})

local map = require("skypex.utils").map

map("n", "<leader>ta", tandem.ask, "ask ai") -- prompt, opens chat split (focus stays)
map("n", "<leader>tc", tandem.chat.toggle, "toggle chat")
map("n", "<leader>ts", tandem.interrupt, "interrupt claude")
map("n", "<leader>tr", tandem.review.toggle_global, "toggle review mode")
map("n", "<leader>tR", tandem.review.toggle, "toggle review mode for buffer") -- buffer-local review mode
map("n", "<leader>th", tandem.hunk.toggle, "toggle old/new suggestion") -- old/new for nearest suggestion
map("n", "<leader>ty", tandem.hunk.approve, "approve suggestion")
map("n", "<leader>tn", tandem.hunk.reject, "reject suggestion")
map("n", "<leader>tp", tandem.hunk.peek, "peek at suggestion") -- float, handy for outdated ones
map("n", "<leader>tl", tandem.list.toggle, "toggle change list") -- suggestion panel (<CR> jumps, q closes)
map("n", "æt", tandem.list.next, "goto next change")
map("n", "åt", tandem.list.prev, "goto previous change")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(ev)
		local buf = ev.buf

		local name = vim.api.nvim_buf_get_name(buf)

		if name ~= "tandem://suggestions" then
			return
		end

		map("n", "<CR>", tandem.list.jump, nil, nil, buf)
	end,
})
