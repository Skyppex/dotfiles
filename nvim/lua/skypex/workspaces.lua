local M = {}

---@class WorkspaceConfig
---@field name string
---@field on_init? fun(ws: Workspace)

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
	local var_name = "workspace"

	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, value = pcall(vim.api.nvim_tabpage_get_var, tab, var_name)
		if ok and value and value == name then
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
	local tab = vim.api.nvim_get_current_tabpage()
	vim.api.nvim_tabpage_set_var(tab, "workspace", name)

	for _, ws in ipairs(M.workspaces) do
		if ws.name == name then
			ws.tab = tab
			break
		end
	end

	return tab
end

function M.initialize_workspace(name, tab)
	for _, ws in ipairs(M.workspaces) do
		if ws.name == name then
			ws.tab = tab
			break
		end
	end
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
	local tab = M.get_workspace_tab(self.name)
	local is_first_open = not tab or not vim.api.nvim_tabpage_is_valid(tab)
	self:_navigate(is_first_open)
end

---@param self Workspace
---@param callback fun()?
function M.Workspace:open(callback)
	local tab = M.get_workspace_tab(self.name)
	local is_first_open = not tab or not vim.api.nvim_tabpage_is_valid(tab)
	self:_navigate(is_first_open)

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

---@param config? WorkspaceConfig
---@return Workspace?
function M.setup(config)
	local tabs = vim.api.nvim_list_tabpages()

	if #tabs ~= 1 then
		vim.notify("workspaces must be initialized with only a single existing tabpage", vim.log.levels.ERROR)
		return nil
	end

	local code_ws_name = "code"
	local tab = tabs[1]
	vim.api.nvim_tabpage_set_var(tab, "workspace", code_ws_name)
	vim.notify(vim.inspect(tab))

	---@type WorkspaceConfig
	local extended_config = vim.tbl_deep_extend("force", { name = code_ws_name }, config or {}, {
		tab = tab,
	})

	vim.notify(vim.inspect(tab))

	local code_ws = setmetatable({
		name = code_ws_name,
		tab = tab,
	}, M.Workspace)

	table.insert(M.workspaces, code_ws)
	table.insert(M.configs, extended_config)

	if code_ws and extended_config.on_init then
		extended_config.on_init(code_ws)
	end

	return code_ws
end

return M
