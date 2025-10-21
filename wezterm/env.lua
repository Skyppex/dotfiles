local function load_local_env(file)
	local vars = {}
	local f = io.open(file, "r")
	if not f then
		return vars
	end

	for line in f:lines() do
		-- Ignore comments and empty lines
		if not line:match("^%s*#") and line:match("%S") then
			-- Match export VAR=VALUE or VAR=VALUE
			local key, value = line:match("^%s*export%s+([%w_]+)%s*=%s*(.*)")
			if not key then
				key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)")
			end
			if key and value then
				-- Remove optional quotes around the value
				value = value:gsub([["(.*)"]], "%1")
				vars[key] = value
			end
		end
	end
	f:close()
	return vars
end

local utils = require("utils")

local env_file = utils.get_home() .. "/.local.env"
local local_env_vars = load_local_env(env_file)

return local_env_vars
