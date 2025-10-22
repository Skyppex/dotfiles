local M = {}

--- @return string, integer
function M.get_home()
	local home_drive = os.getenv("HOMEDRIVE")
	local home

	if home_drive ~= nil then
		home = home_drive .. os.getenv("HOMEPATH")
	else
		home = os.getenv("HOME")
	end

	if home == nil then
		return "", 0
	end

	return string.gsub(home, "\\", "/")
end

--- @return string
function M.get_config_path()
	return M.get_home() .. "/.config"
end

--- @return string
function M.get_chezmoi_path()
	return M.get_home() .. "/.local/share/chezmoi"
end

--- @return boolean
function M.is_home_computer_windows()
	return M.get_home():find("C:/Users/Brage") ~= nil
end

--- @return boolean
function M.is_home_computer_linux()
	return M.get_home():find("/home/skypex") ~= nil
end

--- @return boolean
function M.is_home_laptop_linux()
	return M.get_home():find("/home/pod-042", 1, true) ~= nil
end

--- @return boolean
function M.is_work_computer()
	return M.get_home():find("brage.ingebrigtsen") ~= nil
end

--- @return boolean
function M.is_work_computer_linux()
	return M.get_home():find("/home/brage") ~= nil
end

--- @return boolean
function M.is_linux()
	return M.is_home_computer_linux() or M.is_work_computer_linux() or M.is_home_laptop_linux()
end

--- @return string
function M.get_code_path()
	local home = M.get_home()
	if M.is_work_computer() then
		return home .. "/dev/code"
	elseif M.is_home_computer_windows() then
		return "D:/code"
	else
		return home .. "/dev/code"
	end
end

--- @return string?
function M.get_game_dev_path()
	if M.is_home_computer_windows() then
		return "D:/Game Dev/Unity Projects"
	end

	return nil
end

--- @return string
function M.table_to_string(tbl)
	local result = "{"
	for k, v in pairs(tbl) do
		if type(k) == "number" then
			result = result .. "[" .. k .. "] = "
		else
			result = result .. k .. " = "
		end
		if type(v) == "table" then
			result = result .. M.table_to_string(v)
		else
			result = result .. tostring(v)
		end
		result = result .. ", "
	end
	return result:sub(1, -3) .. "}"
end

--- @param mode string
--- @param lhs string
--- @return boolean, string?
function M.keymap_exists(mode, lhs)
	local keymaps = vim.api.nvim_get_keymap(mode)

	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true, keymap.rhs
		end
	end

	return false, nil
end

--- @param bufnr integer
--- @param mode string
--- @param lhs string
--- @return boolean, string?
function M.local_keymap_exists(bufnr, mode, lhs)
	local keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)

	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true, keymap.rhs
		end
	end

	return false, nil
end

--- @class Separated
--- @field M.keys string[]
--- @field M.values string[]
---
--- @param tbl table
--- @return Separated
function M.separate(tbl)
	local keys = {}
	local values = {}

	for key, _ in pairs(tbl) do
		table.insert(keys, key)
	end
	return {
		keys = keys,
		values = values,
	}
end

--- @param command string
--- @param args string[]?
--- @param should_block boolean
--- @param on_exit function? (data: string, exit_code: number)
function M.run_command(command, args, should_block, on_exit)
	local Job = require("plenary.job")

	local job = Job:new({
		command = command,
		args = args,
		on_stdout = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify(data, vim.log.levels.OFF)
				end)
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify(data, vim.log.levels.ERROR)
				end)
			end
		end,
		on_exit = function(data, exit_code)
			if on_exit then
				vim.schedule(function()
					on_exit(data, exit_code)
				end)
			end
		end,
	})

	if should_block then
		job:sync() -- This will block until the job completes
	else
		job:start() -- This will run the job asynchronously
	end
end

--- @param command string
--- @param args string[]?
--- @param on_exit function? (data: string, exit_code: number)
--- @return table|nil, number (stdout, exit_code)
function M.run_command_ret(command, args, on_exit)
	local Job = require("plenary.job")
	local stdout_lines = {}

	local job = Job:new({
		command = command,
		args = args,
		enable_recording = true, -- Enable recording to capture output
		on_stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify(data, vim.log.levels.ERROR)
				end)
			end
		end,
		on_exit = function(_, exit_code)
			if on_exit then
				vim.schedule(function()
					on_exit(table.concat(stdout_lines, "\n"), exit_code)
				end)
			end
		end,
	})

	return job:sync() -- Blocks until done
end

function M.local_plugin(name, config, else_config)
	local local_dir = M.get_code_path() .. "/" .. name

	local Path = require("plenary.path")
	local path = Path:new(local_dir)

	if path:is_dir() then
		return {
			name = name,
			dir = local_dir,
			config = config,
		}
	else
		return else_config()
	end
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nmap = function(left, right, desc, expr, buf)
	vim.keymap.set("n", left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.xmap = function(left, right, desc, expr, buf)
	vim.keymap.set("x", left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.imap = function(left, right, desc, expr, buf)
	vim.keymap.set("i", left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.smap = function(left, right, desc, expr, buf)
	vim.keymap.set("s", left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.omap = function(left, right, desc, expr, buf)
	vim.keymap.set("o", left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxmap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nimap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "i" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nsmap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.ximap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "x", "i" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.xsmap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "x", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.xomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "x", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nximap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "i" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxsmap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nismap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "i", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.niomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "i", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.xismap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "x", "i", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.xiomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "x", "i", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxismap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "i", "s" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxiomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "i", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
--- @param expr boolean?
--- @param buf integer?
M.nxisomap = function(left, right, desc, expr, buf)
	vim.keymap.set({ "n", "x", "i", "s", "o" }, left, right, {
		desc = desc,
		expr = expr,
		buffer = buf,
		noremap = true,
		silent = true,
	})
end

return M
