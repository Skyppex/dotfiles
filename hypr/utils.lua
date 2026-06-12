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

return M
