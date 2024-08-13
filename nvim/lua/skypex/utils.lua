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

return {
	get_home = get_home,
	get_code_path = get_code_path,
}
