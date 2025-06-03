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

---@return string?
function M.pick()
	local value = M.list_dbs()

	if not value or #value == 0 then
		vim.notify("100")
		return nil
	end

	local dbs = vim.split(value, "\n", { plain = true })

	local ids = {}

	for _, db in ipairs(dbs) do
		local list = M.list(db)

		if not list or #list == 0 then
			return nil
		end

		local keys = vim.split(list, "\n", { plain = true })

		local kvps = {}

		for i, key in ipairs(keys) do
			kvps[i] = key .. db
		end

		vim.list_extend(ids, kvps)
	end

	local selected = nil

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Skate Keys",
			finder = require("telescope.finders").new_table({
				results = ids,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
					}
				end,
			}),
			sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<CR>", function()
					local selection = require("telescope.actions.state").get_selected_entry()
					selected = selection.value
					require("telescope.actions").close(prompt_bufnr)
					return selection.value
				end)
				return true
			end,
		})
		:find()

	if not selected then
		return nil
	end

	local key, db = selected:match("^(.-)@(.*)$")

	return M.get(key, db)
end

return M
