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

--- @return string?
local function get_game_dev_path()
	if is_home_computer_windows() then
		return "D:/Game Dev/Unity Projects"
	end

	return nil
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
local function get_temp_path()
	local home = get_home()
	if is_work_computer() then
		return home .. "/dev/temp"
	elseif is_home_computer_linux() then
		return home .. "/dev/temp"
	else
		return "D:/code/temp"
	end
end

return {
	get_home = get_home,
	get_config_path = get_config_path,
	get_chezmoi_path = get_chezmoi_path,
	is_home_computer_windows = is_home_computer_windows,
	is_home_computer_linux = is_home_computer_linux,
	is_work_computer = is_work_computer,
	get_code_path = get_code_path,
	get_temp_path = get_temp_path,
	get_game_dev_path = get_game_dev_path,
}
