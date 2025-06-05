local M = {}

local utils = require("skypex.utils")

local function create_id(key, db)
	if not db or #db == 0 then
		return key
	else
		return key .. "@" .. db
	end
end

local function skate(args)
	local stdout, _ = utils.run_command_ret("skate", args)

	if not stdout or #stdout == 0 then
		return nil
	end

	return table.concat(stdout, "\n")
end

---@param key string
---@param db string?
---@return string?
function M.get(key, db)
	return skate({ "get", create_id(key, db) })
end

---@return string?
function M.list_dbs()
	return skate({ "list-dbs" })
end

---@param db string?
---@return string?
function M.list(db)
	if not db or #db == 0 then
		return skate({ "list", "--keys-only" })
	end

	return skate({ "list", "--keys-only", db })
end

return M
