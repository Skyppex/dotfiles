local M = {}

--- @return table<string>
function M.hosts()
	local config_path = os.getenv("HOME") .. "/.ssh/config"
	local hosts = {}

	local file = io.open(config_path, "r")

	if not file then
		return hosts
	end

	for line in file:lines() do
		local trimmed = line:match("^%s*(.-)%s*$")

		if trimmed ~= "" and not trimmed:match("^#") then
			local rest = trimmed:match("^Host%s+(.+)$")

			if rest then
				for host in rest:gmatch("%S+") do
					table.insert(hosts, host)
				end
			end
		end
	end

	file:close()
	return hosts
end

--- @param server string server address
--- @param remote_cwd string|nil cwd to enter on the remote server
--- @return table<string>
function M.ssh_args(server, remote_cwd)
	if remote_cwd then
		return {
			"ssh",
			"-t",
			server,
			"cd " .. remote_cwd .. " && bash -l",
		}
	end

	return {
		"ssh",
		"-t",
		server,
		"bash -l",
	}
end

--- @param server string server address
--- @param remote_cwd string cwd to enter on the remote server
--- @return table<string>
function M.nvim_ssh_args(server, remote_cwd)
	return {
		"ssh",
		"-t",
		server,
		"cd " .. remote_cwd .. " && bash -l -c nvim",
	}
end

--- @param server string server address
--- @param remote_cwd string|nil cwd to enter on the remote server
--- @return table<string>
function M.nu_ssh_args(server, remote_cwd)
	if remote_cwd then
		return {
			"ssh",
			"-t",
			server,
			"cd " .. remote_cwd .. " && bash -l -c nu",
		}
	end

	return {
		"ssh",
		"-t",
		server,
		"bash -l -c nu",
	}
end

return M
