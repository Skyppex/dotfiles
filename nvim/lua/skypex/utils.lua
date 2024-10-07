local function get_home()
	local home_drive = os.getenv("HOMEDRIVE")
	local home_path = os.getenv("HOMEPATH")
	return string.gsub(home_drive .. home_path, "\\", "/")
end

local function get_code_path()
	local home = get_home()
	if home:find("brage.ingebrigtsen") then
		return home .. "/dev/code/"
	else
		return "D:/code/"
	end
end

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

local nmap = function(left, right, desc)
	vim.keymap.set("n", left, right, { desc = desc, noremap = true, silent = true })
end

local xmap = function(left, right, desc)
	vim.keymap.set("x", left, right, { desc = desc, noremap = true, silent = true })
end

local imap = function(left, right, desc)
	vim.keymap.set("i", left, right, { desc = desc, noremap = true, silent = true })
end

local smap = function(left, right, desc)
	vim.keymap.set("s", left, right, { desc = desc, noremap = true, silent = true })
end

local omap = function(left, right, desc)
	vim.keymap.set("o", left, right, { desc = desc, noremap = true, silent = true })
end

local nxmap = function(left, right, desc)
	vim.keymap.set({ "n", "x" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nimap = function(left, right, desc)
	vim.keymap.set({ "n", "i" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nsmap = function(left, right, desc)
	vim.keymap.set({ "n", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

local ximap = function(left, right, desc)
	vim.keymap.set({ "x", "i" }, left, right, { desc = desc, noremap = true, silent = true })
end

local xsmap = function(left, right, desc)
	vim.keymap.set({ "x", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nximap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "i" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nxsmap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nismap = function(left, right, desc)
	vim.keymap.set({ "n", "i", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

local xismap = function(left, right, desc)
	vim.keymap.set({ "x", "i", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

local nxismap = function(left, right, desc)
	vim.keymap.set({ "n", "x", "i", "s" }, left, right, { desc = desc, noremap = true, silent = true })
end

return {
	get_home = get_home,
	get_code_path = get_code_path,
	table_to_string = table_to_string,
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
