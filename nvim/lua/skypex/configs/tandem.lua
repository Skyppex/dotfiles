local tandem = require("tandem")
local utils = require("skypex.utils")

tandem.setup({
	provider = function()
		if utils.is_home_computer_linux() then
			return "codex"
		end

		return "claude"
	end,
	providers = {
		claude = {
			cmd = { "nix", "shell", "--impure", "nixpkgs#claude-code", "--command", "claude" },
			env = { NIXPKGS_ALLOW_UNFREE = "1" },
			args = {},
			-- Claude must never write to disk on its own; tandem's MCP tools replace
			-- these, and Read is replaced so Claude sees its own pending edits.
			disallowed_tools = { "Read", "Edit", "Write", "MultiEdit", "NotebookEdit" },
		},
		codex = {
			cmd = "codex",
			args = {},
			env = {},
			sandbox = "read-only",
			approval_policy = "on-request",
		},
	},
	chat = {
		width = 80,
	},
	list = {
		height = 10,
	},
	mode = "manual",
	on_permission = function(request) -- { id, tool, input, summary, description?, subagent }
		vim.notify("Claude waits: " .. request.summary, vim.log.levels.WARN)
	end,
})

local tandem_ws = require("skypex.workspaces").register({
	name = "tandem",
	on_init = function()
		tandem.chat.focus({ layout = "current" })
	end,
})

local map = utils.map

map("n", { "<c-w><c-t>", "<c-w>t" }, function()
	tandem_ws:activate()
end, "activate ai chat")

map("n", "<leader>ta", tandem.ask, "ask ai")
map("n", "<leader>tc", tandem.chat.toggle, "toggle chat dock")
map("n", "<leader>tq", tandem.interrupt, "interrupt claude")
map("n", "<leader>tY", tandem.permission.permit, "permit permission request")
map("n", "<leader>tN", tandem.permission.deny, "deny permission request")
map("n", "<leader>tS", tandem.session.resume, "resume session")
map("n", "<leader>tN", tandem.session.resume, "new session")
map("n", "<leader>td", tandem.answer.dismiss, "dismiss inline answer")
map("n", "<leader>tD", tandem.answer.clear, "dismiss all inline answers")
map("n", "<leader>tQ", tandem.quickfix.replace, "replace quickfix list")

map("n", "<leader>tr", tandem.review.toggle_global, "toggle review mode")
map("n", "<leader>tR", tandem.review.toggle, "toggle review mode for buffer")
map("n", "<leader>tm", tandem.mode.toggle, "toggle mode")
map("n", "<leader>ts", tandem.hunk.toggle, "toggle old/new suggestion")
map("n", "<leader>ty", tandem.hunk.approve, "approve suggestion")
map("n", "<leader>tn", tandem.hunk.reject, "reject suggestion")
map("n", "<leader>tp", tandem.hunk.peek, "peek at suggestion")
map("n", "<leader>tl", tandem.list.toggle, "toggle change list")
map("n", "æt", tandem.list.next, "goto next change")
map("n", "åt", tandem.list.prev, "goto previous change")

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "*",
	callback = function(ev)
		local buf = ev.buf
		local name = vim.api.nvim_buf_get_name(buf)

		if name ~= "tandem://chat" then
			return
		end

		map("n", "<c-s>", tandem.chat.send, "send message", nil, buf)
		map("n", "<c-q>", tandem.quickfix.replace, "replace quickfix list", nil, buf)
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "*",
	callback = function(ev)
		local buf = ev.buf

		local name = vim.api.nvim_buf_get_name(buf)

		if name ~= "tandem://suggestions" then
			return
		end

		map("n", "<CR>", tandem.list.jump, "jump to suggestion", nil, buf)
		map("n", "<leader>ty", tandem.list.accept_all, "accept all suggestions", nil, buf)
		map("n", "<leader>tn", tandem.list.reject_all, "reject all suggestions", nil, buf)
	end,
})
