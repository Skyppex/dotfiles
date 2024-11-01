local M = {}

M.get_home = function()
	local home_drive = os.getenv("HOMEDRIVE")
	local home_path = os.getenv("HOMEPATH")
	return home_drive .. home_path
end

M.get_config_path = function()
	return M.get_home() .. "/.config"
end

M.get_chezmoi_path = function()
	return M.get_home() .. "/.local/share/chezmoi"
end

M.is_work_computer = function()
	return M.get_home():find("brage.ingebrigtsen")
end

return M
