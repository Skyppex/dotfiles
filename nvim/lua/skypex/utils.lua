--- @return string, integer
local function get_home()
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
local function get_config_path()
	return get_home() .. "/.config"
end

--- @return string
local function get_chezmoi_path()
	return get_home() .. "/.local/share/chezmoi"
end

--- @return boolean
local function is_home_computer_windows()
	return get_home():find("C:/Users/Brage") ~= nil
end

--- @return boolean
local function is_home_computer_linux()
	return get_home():find("/home/brage") ~= nil
end

--- @return boolean
local function is_work_computer()
	return get_home():find("brage.ingebrigtsen") ~= nil
end

--- @return string
local function get_code_path()
	local home = get_home()
	if is_work_computer() then
		return home .. "/dev/code"
	elseif is_home_computer_windows() then
		return "D:/code"
	else
		return home .. "/dev/code"
	end
end

--- @return string
local function table_to_string(tbl)
	local result = "{"
	for k, v in pairs(tbl) do
		if type(k) == "number" then
			result = result .. "[" .. k .. "] = "
		else
			result = result .. k .. " = "
		end
		if type(v) == "table" then
			result = result .. table_to_string(v)
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
local function keymap_exists(mode, lhs)
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
local function local_keymap_exists(bufnr, mode, lhs)
	local keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)

	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true, keymap.rhs
		end
	end

	return false, nil
end

--- @class Separated
--- @field keys string[]
--- @field values string[]
---
--- @param tbl table
--- @return Separated
local function separate(tbl)
	local keys = {}
	local values = {}

	for key, value in pairs(tbl) do
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
local function run_command(command, args, should_block)
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
	})

	if should_block then
		job:sync() -- This will block until the job completes
	else
		job:start() -- This will run the job asynchronously
	end
end

local andromeda = {
	gray = "#23262e",
	light_gray = "#373941",
	lighter_gray = "#857e89", -- Custom addition
	orange = "#f39c12",
	pink = "#ff00aa",
	blue = "#7cb7ff",
	cyan = "#00e8c6",
	yellow = "#ffe66d",
	green = "#96e072",
	white = "#d5ced9",
	black = "#181a16",
	purple = "#c74ded",
}

--- @param left string
--- @param right string|function
--- @param desc string?
local nmap = function(left, right, desc)
	vim.keymap.set("n", left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local xmap = function(left, right, desc)
	vim.keymap.set("x", left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local imap = function(left, right, desc)
	vim.keymap.set("i", left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local smap = function(left, right, desc)
	vim.keymap.set("s", left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local omap = function(left, right, desc)
	vim.keymap.set("o", left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nxmap = function(left, right, desc)
	vim.keymap.set({ "n", "x" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nimap = function(left, right, desc)
	vim.keymap.set({ "n", "i" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nsmap = function(left, right, desc)
	vim.keymap.set({ "n", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local ximap = function(left, right, desc)
	vim.keymap.set({ "x", "i" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local xsmap = function(left, right, desc)
	vim.keymap.set({ "x", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nximap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "i" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nxsmap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nismap = function(left, right, desc)
	vim.keymap.set({ "n", "i", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local xismap = function(left, right, desc)
	vim.keymap.set({ "x", "i", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

--- @param left string
--- @param right string|function
--- @param desc string?
local nxismap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "i", "s" }, left, right, {
		desc = desc,
		noremap = true,
		silent = true,
	})
end

return {
	get_home = get_home,
	get_code_path = get_code_path,
	get_config_path = get_config_path,
	get_chezmoi_path = get_chezmoi_path,
	is_home_computer_windows = is_home_computer_windows,
	is_home_computer_linux = is_home_computer_linux,
	is_work_computer = is_work_computer,
	table_to_string = table_to_string,
	keymap_exists = keymap_exists,
	local_keymap_exists = local_keymap_exists,
	separate = separate,
	run_command = run_command,
	andromeda = andromeda,
	nmap = nmap,
	xmap = xmap,
	imap = imap,
	smap = smap,
	omap = omap,
	nxmap = nxmap,
	nimap = nimap,
	nsmap = nsmap,
	ximap = ximap,
	xsmap = xsmap,
	nximap = nximap,
	nxsmap = nxsmap,
	nismap = nismap,
	xismap = xismap,
	nxismap = nxismap,
}
