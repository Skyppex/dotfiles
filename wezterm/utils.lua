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
	return M.get_home():find("/home/tower") ~= nil
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
function M.is_work_computer_wsl()
	return M.get_home():find("/home/brage") ~= nil
end

--- @return boolean
function M.is_work_computer_linux()
	return M.get_home():find("/home/brage") ~= nil
end

--- @return boolean
function M.is_linux()
	return package.config:sub(1, 1) == "/"
end

--- @return string?
function M.get_game_dev_path()
	if M.is_home_computer_windows() then
		return "D:/Game Dev/Unity Projects"
	end

	return nil
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

--- @return string
function M.get_temp_path()
	local home = M.get_home()
	if M.is_work_computer() then
		return home .. "/dev/temp"
	elseif M.is_home_computer_linux() then
		return home .. "/dev/temp"
	else
		return "D:/code/temp"
	end
end

--- @param a table
--- @param b table
--- @return table
function M.merge_tables(a, b)
	local result = {}

	for k, v in pairs(a) do
		result[k] = v
	end

	for k, v in pairs(b) do
		result[k] = v
	end

	return result
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
--- @param path string
--- @return string
function M.basename(path)
	path = path:gsub("[/\\]+$", "")
	return path:match("([^/]+)$")
end

--- @param str string
--- @param suffix string
--- @return boolean
function M.ends_with(str, suffix)
	if suffix == "" then
		return true
	end

	return str:sub(-#suffix) == suffix
end

--- @param str string
--- @param suffix string
--- @return string
function M.strip_suffix(str, suffix)
	if suffix == "" then
		return str
	end

	if str:sub(-#suffix) == suffix then
		return str:sub(1, #str - #suffix)
	end

	return str
end

return M
