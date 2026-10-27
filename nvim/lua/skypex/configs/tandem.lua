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
		height = 40,
		input_height = 5,
		split = function()
			local aspect_ratio = utils.get_screen_aspect_ratio()
			local split = aspect_ratio > 1.0 and "right" or "below"
			return split
		end,
	},
	list = {
		height = 10,
	},
	mode = "manual",
	on_permission = function(request) -- { id, tool, input, summary, description?, subagent }
		vim.notify("Claude waits: " .. request.summary, vim.log.levels.WARN)
	end,
	always_write = utils.table_append(require("tandem.config").defaults, {
		function()
			return vim.fn.getcwd() .. "/.crypt"
		end,
	}),
})

local map = utils.map

-- sessions and chat
map("nx", "<leader>ta", tandem.ask, "ask ai")
map("nx", "<leader>tc", function()
	tandem.chat.toggle({ focus = "input" })
end, "toggle chat dock")
map("nx", "<leader>tq", tandem.interrupt, "interrupt claude")
map("nx", "<leader>tY", tandem.permission.permit, "permit permission request")
map("nx", "<leader>tN", tandem.permission.deny, "deny permission request")
map("nx", "<leader>ts", tandem.session.resume, "resume session")
map("nx", "<leader>tS", tandem.session.resume, "new session")
map("nx", "<leader>td", tandem.answer.dismiss, "dismiss inline answer")
map("nx", "<leader>tD", tandem.answer.clear, "dismiss all inline answers")
map("nx", "<leader>tQ", tandem.quickfix.replace, "replace quickfix list")

-- review mode and hunks
map("nx", "<leader>tr", tandem.review.toggle_global, "toggle review mode")
map("nx", "<leader>tR", tandem.review.toggle, "toggle review mode for buffer")
map("nx", "<leader>tm", tandem.mode.cycle, "cycle mode")
map("nx", "<leader>tf", tandem.hunk.toggle, "toggle old/new suggestion")
map("nx", "<leader>ty", tandem.hunk.approve, "approve suggestion")
map("nx", "<leader>tn", tandem.hunk.reject, "reject suggestion")
map("nx", "<leader>tp", tandem.hunk.peek, "peek at suggestion")
map("nx", "<leader>tl", tandem.list.toggle, "toggle change list")

-- buffers matching these are never chosen as the window to open suggestions in
local useless_filetypes = {
	"tandem-input",
	"tandem-suggestions",
	"qf",
	"help",
	"oil",
	"neo-tree",
	"NvimTree",
	"TelescopePrompt",
	"lazy",
	"mason",
}

local useless_name_patterns = {
	"^tandem://",
	"^diffview://",
	"^kulala://",
}

local function is_useful_win(win)
	if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)

	if vim.tbl_contains(useless_filetypes, vim.bo[buf].filetype) then
		return false
	end

	local name = vim.api.nvim_buf_get_name(buf)

	for _, pattern in ipairs(useless_name_patterns) do
		if name:match(pattern) then
			return false
		end
	end

	return true
end

local last_useful_win = nil

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType" }, {
	callback = function()
		local win = vim.api.nvim_get_current_win()

		if is_useful_win(win) then
			last_useful_win = win
		end
	end,
})

-- tandem opens suggestions in the current window, so move to a useful one first
local function focus_useful_win()
	local current = vim.api.nvim_get_current_win()

	if is_useful_win(current) then
		return
	end

	if last_useful_win and is_useful_win(last_useful_win) then
		vim.api.nvim_set_current_win(last_useful_win)
		return
	end

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if is_useful_win(win) then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
end

map("nx", "æt", function()
	focus_useful_win()
	tandem.list.next()
	tandem.review.set_global(true)
	vim.api.nvim_command("normal! zz")
end, "goto next change")

map("nx", "åt", function()
	focus_useful_win()
	tandem.list.prev()
	tandem.review.set_global(true)
	vim.api.nvim_command("normal! zz")
end, "goto previous change")

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "*",
	callback = function(ev)
		local buf = ev.buf
		local name = vim.api.nvim_buf_get_name(buf)

		if name ~= "tandem://chat" then
			return
		end

		map("n", "<c-s>", ":w<cr>", "write", nil, buf)
		map("n", "<c-q>", tandem.quickfix.replace, "replace quickfix list", nil, buf)
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "*",
	callback = function(ev)
		local buf = ev.buf
		local name = vim.api.nvim_buf_get_name(buf)

		if name ~= "tandem://input" then
			return
		end

		map("n", "<c-s>", ":w<cr>", "write", nil, buf)
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
		map("n", "<leader>ty", tandem.list.approve_all, "approve all suggestions", nil, buf)
		map("n", "<leader>tn", tandem.list.reject_all, "reject all suggestions", nil, buf)
	end,
})
