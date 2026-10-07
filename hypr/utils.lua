local M = {}

--- @return string?
function M.hostname()
	local file = io.open("/etc/hostname")

	if file == nil then
		return nil
	end

	local hostname = file:read()
	file:close()
	return hostname
end

--- @param name string executable name or path
--- @return boolean true if executable exists
function M.executable_exists(name)
	local handle = io.popen("command -v " .. name .. " 2>/dev/null")
	if handle == nil then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	return result ~= ""
end

return M
