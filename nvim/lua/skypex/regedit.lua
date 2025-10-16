local M = {}

M.config = {
	save_on_close = true,
	disable_scrolling = true,
	signcolumn = true,
	hooks = {
		on_win_open = function(buf, win)
			local number = vim.api.nvim_get_option_value("number", { scope = "global" })
			local relativenumber = vim.api.nvim_get_option_value("relativenumber", { scope = "global" })
			vim.api.nvim_set_option_value("number", number, { win = win })
			vim.api.nvim_set_option_value("relativenumber", relativenumber, { win = win })
		end,
	},
}

local function get_registers()
	local regs = {}
	for i = string.byte("a"), string.byte("z") do
		local name = string.char(i)
		local val = vim.fn.getreg(name)
		regs[#regs + 1] = { name = name, value = val }
	end
	return regs
end

local function reg_to_display(str)
	return vim.fn.keytrans(str)
end

local function display_to_reg(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.open()
	-- create buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_set_option_value("filetype", "registers", { buf = buf })
	vim.api.nvim_buf_set_name(buf, "registers://editor")

	-- gather all registers a–z
	local regs = get_registers()
	local lines, reg_map = {}, {}

	for i, reg in ipairs(regs) do
		lines[i] = reg.value ~= "" and reg_to_display(reg.value) or ""
		reg_map[i] = reg.name
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_var(buf, "reg_map", reg_map)

	-- floating window setup
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.min(26, math.floor(vim.o.lines * 0.6))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Register Editor ",
		title_pos = "center",
	})

	M.config.hooks.on_win_open(buf, win)

	vim.api.nvim_set_option_value("numberwidth", 2, { win = win })

	if M.config.disable_scrolling then
		vim.api.nvim_set_option_value("scrolloff", 0, { win = win })
		vim.api.nvim_set_option_value("sidescrolloff", 0, { win = win })
		vim.api.nvim_set_option_value("wrap", false, { win = win })
		vim.api.nvim_set_option_value("scroll", 0, { win = win })
	end

	-- setup sign column
	vim.fn.sign_unplace("registers")

	if M.config.signcolumn then
		vim.api.nvim_set_option_value("signcolumn", "yes:1", { win = win })

		for i, reg in ipairs(regs) do
			local sign_name = "RegisterSign_" .. reg.name
			pcall(vim.fn.sign_define, sign_name, {
				text = reg.name,
				texthl = "Comment",
				numhl = "",
			})
			vim.fn.sign_place(1000 + i, "registers", sign_name, buf, { lnum = i })
		end
	end

	-- handle :w to write back to registers
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buffer = buf,
		callback = function()
			local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local map = vim.api.nvim_buf_get_var(buf, "reg_map")
			for i, line in ipairs(new_lines) do
				local reg_name = map[i]
				if reg_name then
					vim.fn.setreg(reg_name, display_to_reg(line))
				end
			end
			vim.notify("Registers updated", vim.log.levels.INFO)
		end,
	})

	if M.config.disable_scrolling then
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
			-- prevent scrolling entirely
			vim.keymap.set({ "n", "v", "i", "x", "o" }, v, function()
				return "<nop>"
			end, { buffer = buf, noremap = true, silent = true, expr = false })
		end
	end

	-- allow closing with q
	vim.keymap.set("n", "q", function()
		if M.config.save_on_close then
			vim.cmd("write!")
		end

		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, nowait = true })

	-- allow closing with <esc>
	vim.keymap.set("n", "<esc>", function()
		if M.config.save_on_close then
			vim.cmd("write!")
		end

		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, nowait = true })
end

local nmap = require("skypex.utils").nmap
nmap("<leader>R", M.open, "Open registry editor")

return M
