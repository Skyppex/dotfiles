local M = {}

local offset_x = -1
local offset_y = 1
local prompt_width = 0

local highlights = {
	[":"] = "CmdLineColon",
	["/"] = "CmdLineSlash",
	["?"] = "CmdLineQuestion",
	["="] = "CmdLineExpr",
	[">"] = "CmdLineDebug",
	["-"] = "CmdLineText",
	["@"] = "CmdLineInput",
}

local ns = vim.api.nvim_create_namespace("skypex_cmdline")
local cmdline_win = nil
local cmdline_buf = nil

function M.show(content, pos, first_char, prompt, indent, level, hl_id)
	if cmdline_win and vim.api.nvim_win_is_valid(cmdline_win) then
		vim.api.nvim_win_close(cmdline_win, true)
	end
	cmdline_win = nil

	if not cmdline_buf or not vim.api.nvim_buf_is_valid(cmdline_buf) then
		cmdline_buf = vim.api.nvim_create_buf(false, true)
	end

	vim.api.nvim_buf_clear_namespace(cmdline_buf, ns, 0, -1)
	vim.bo[cmdline_buf].modifiable = true

	local text = {}

	for _, chunk in ipairs(content) do
		table.insert(text, chunk[2])
	end

	if first_char == "" then
		first_char = vim.fn.getcmdtype()
	end

	local content_text = table.concat(text, "")
	local line = first_char .. prompt .. string.rep(" ", indent) .. content_text
	prompt_width = #first_char + #prompt + indent

	vim.api.nvim_buf_set_lines(cmdline_buf, 0, -1, false, { line })

	if prompt_width > 0 and hl_id > 0 then
		vim.api.nvim_buf_set_extmark(cmdline_buf, ns, 0, 0, {
			end_col = prompt_width,
			hl_group = hl_id,
			invalidate = true,
			undo_restore = false,
		})
	elseif #line > 0 and line:sub(1, 1) == ":" then
		pcall(function()
			local parser = vim.treesitter.get_string_parser(line, "vim")
			parser:parse(true)
			parser:for_each_tree(function(tstree, tree)
				local query = tstree and vim.treesitter.query.get(tree:lang(), "highlights")
				if query then
					for capture, node in query:iter_captures(tstree:root(), line) do
						local _, start_col, _, end_col = node:range()
						if query.captures[capture]:sub(1, 1) ~= "_" then
							vim.api.nvim_buf_set_extmark(cmdline_buf, ns, 0, start_col, {
								end_col = end_col,
								hl_group = ("@%s.%s"):format(query.captures[capture], query.lang),
								invalidate = true,
								undo_restore = false,
							})
						end
					end
				end
			end)
		end)
	end

	local first_char_hl = highlights[first_char]
	if first_char_hl and #first_char > 0 then
		vim.api.nvim_buf_set_extmark(cmdline_buf, ns, 0, 0, {
			end_col = #first_char,
			hl_group = first_char_hl,
			invalidate = true,
			undo_restore = false,
			priority = 5000,
		})
	end

	cmdline_win = vim.api.nvim_open_win(cmdline_buf, false, {
		relative = "cursor",
		row = offset_y,
		col = offset_x,
		width = math.max(#line + 1, 2),
		height = 1,
		style = "minimal",
		border = require("skypex.style").border,
		zindex = 200,
	})

	vim.bo[cmdline_buf].modifiable = false

	do
		if vim.api.nvim__redraw then
			pcall(vim.api.nvim__redraw, { win = cmdline_win, flush = true })
		end

		local sp = vim.fn.screenpos(cmdline_win, 1, 1)

		if sp and sp.row then
			vim.g.ui_cmdline_pos = { sp.row, sp.col }
		end
	end

	M.pos(pos)
end

function M.hide()
	vim.g.ui_cmdline_pos = nil
	if cmdline_win and vim.api.nvim_win_is_valid(cmdline_win) then
		vim.api.nvim_win_close(cmdline_win, true)
	end
	cmdline_win = nil
	cmdline_buf = nil
end

function M.pos(pos)
	if cmdline_win and vim.api.nvim_win_is_valid(cmdline_win) then
		pcall(vim.api.nvim_win_set_cursor, cmdline_win, { 1, prompt_width + pos })
		if vim.api.nvim__redraw then
			pcall(vim.api.nvim__redraw, { cursor = true, win = cmdline_win, flush = true })
		end
	end
end

function M.setup()
	local ui = require("vim._core.ui2")

	ui.cmd.cmdline_show = M.show
	ui.cmd.cmdline_hide = M.hide
	ui.cmd.cmdline_pos = M.pos
end

return M
