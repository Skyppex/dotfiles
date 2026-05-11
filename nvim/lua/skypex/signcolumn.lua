local M = {}

-- Keep signcolumn off by default
vim.opt.signcolumn = "no"

local toggle_state = {
	["all"] = false,
}

--- @type table<string, fun(buf: integer, win: integer): boolean>
local conditions = {}

conditions["toggle"] = function(buf, _)
	return toggle_state[buf]
end

conditions["toggle-all"] = function(_, _)
	return toggle_state["all"]
end

--- @param name string
--- @param reason fun(): boolean
function M.add_reason(name, reason)
	conditions[name] = reason
end

--- @param name string
function M.remove_reason(name)
	conditions[name] = nil
end

function M.toggle_signcolumn_buf()
	local buf = vim.api.nvim_get_current_buf()

	if toggle_state[buf] then
		toggle_state[buf] = false
		vim.notify("signcolumn disabled buf")
	else
		toggle_state[buf] = true
		vim.notify("signcolumn enabled buf")
	end

	M.update_signcolumn()
end

function M.toggle_signcolumn_all(_, _)
	if toggle_state["all"] then
		toggle_state["all"] = false
		vim.notify("signcolumn disabled")
	else
		toggle_state["all"] = true
		vim.notify("signcolumn enabled")
	end

	M.update_signcolumn()
end

function M.reason()
	local reasons = {}
	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	for name, reason in pairs(conditions) do
		if reason(buf, win) then
			table.insert(reasons, name)
		end
	end

	if #reasons == 0 then
		vim.notify("the signcolumn should be off")
	else
		local reason = "the signcolumn is on due to: "

		for i, name in ipairs(reasons) do
			reason = reason .. name

			if i ~= #reasons then
				reason = reason .. ", "
			end
		end

		vim.notify(reason)
	end
end

function M.update_signcolumn()
	local wins = vim.api.nvim_list_wins()

	for _, win in ipairs(wins) do
		local on = false
		local buf = vim.api.nvim_win_get_buf(win)

		for _, reason in pairs(conditions) do
			if reason(buf, win) then
				on = true
				break
			end
		end

		if on then
			vim.api.nvim_set_option_value("signcolumn", "yes", { win = win })
		else
			vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
		end
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
	pattern = "*",
	callback = M.update_signcolumn,
})

local map = require("skypex.utils").map
map("nx", "<leader>ts", M.toggle_signcolumn_all, "toggle signcolumn")
map("nx", "<leader>tS", M.toggle_signcolumn_buf, "toggle signcolumn for buffer")

return M
