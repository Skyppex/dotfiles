local M = {}

---@class WorkspaceConfig
---@field name string
---@field on_init fun(ws: Workspace)

---@class Workspace
---@field name string
---@field tab number|nil
---@field toggle fun()
---@field activate fun()
---@field open fun(callback: fun()?)
M.Workspace = {}
M.Workspace.__index = M.Workspace

M.workspaces = {}
M.configs = {}

---@private
---@param name string
---@return number|nil
function M.get_workspace_tab(name)
	local var_name = "workspace_" .. name

	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, value = pcall(vim.api.nvim_tabpage_get_var, tab, var_name)
		if ok and value then
			return tab
		end
	end

	return nil
end

---@private
---@param name string
---@return number
function M.create_workspace(name)
	vim.api.nvim_command("tabnew")
	vim.t["workspace_" .. name] = true
	local tab = vim.api.nvim_get_current_tabpage()

	for _, ws in ipairs(M.workspaces) do
		if ws.name == name then
			ws.tab = tab
			break
		end
	end

	return tab
end

---@param self Workspace
---@param is_first_open boolean
function M.Workspace:_navigate(is_first_open)
	local tab = M.get_workspace_tab(self.name)

	if tab and vim.api.nvim_tabpage_is_valid(tab) then
		vim.api.nvim_set_current_tabpage(tab)
		return tab
	end

	tab = M.create_workspace(self.name)

	if is_first_open then
		for _, config in ipairs(M.configs) do
			if config.name == self.name and config.on_init then
				config.on_init(self)
				break
			end
		end
	end

	return tab
end

---@param self Workspace
function M.Workspace:toggle()
	local tab = M.get_workspace_tab(self.name)
	local is_first_open = not tab or not vim.api.nvim_tabpage_is_valid(tab)

	if is_first_open then
		self:_navigate(true)
		return
	end

	local current = vim.api.nvim_get_current_tabpage()

	if current == tab then
		local first = vim.api.nvim_list_tabpages()[1]
		if first and vim.api.nvim_tabpage_is_valid(first) then
			vim.api.nvim_set_current_tabpage(first)
		end
	else
		vim.api.nvim_set_current_tabpage(tab)
	end
end

---@param self Workspace
function M.Workspace:activate()
	self:_navigate(false)
end

---@param self Workspace
---@param callback fun()?
function M.Workspace:open(callback)
	self:_navigate(false)
	if callback then
		callback()
	end
end

---@param config WorkspaceConfig
---@return Workspace
function M.register(config)
	local workspace = setmetatable({
		name = config.name,
		tab = M.get_workspace_tab(config.name),
	}, M.Workspace)

	table.insert(M.workspaces, workspace)
	table.insert(M.configs, config)

	return workspace
end

---@param name string
---@return Workspace|nil
function M.get(name)
	for _, ws in ipairs(M.workspaces) do
		if ws.name == name then
			return ws
		end
	end
	return nil
end

---@param name string
function M.toggle(name)
	local ws = M.get(name)
	if ws then
		ws:toggle()
	end
end

---@param name string
---@param callback fun()?
function M.open(name, callback)
	local ws = M.get(name)
	if ws then
		ws:open(callback)
	end
end

return M
