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

return {
	get_home = get_home,
	get_code_path = get_code_path,
	table_to_string = table_to_string,
}
