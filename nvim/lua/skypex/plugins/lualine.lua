-- Define the endswith function
local function endswith(s, ending)
	return ending == "" or s:sub(-#ending) == ending
end

-- Define the get_session_name function
local function get_session_name()
	-- Call current_session_name to get the session name
	local session_name = require("auto-session.lib").current_session_name()
	local cwd = vim.fn.getcwd()
	local basename = cwd:match("([^/\\]+)$")

	if endswith(session_name, basename) then
		return basename
	else
		return session_name
	end
end

-- Return the lualine configuration
return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "dracula",
			},
			sections = {
				lualine_c = { get_session_name },
			},
		},
	},
}
