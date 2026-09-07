local devenv = require("devenv")

devenv.setup({
	auto_load = true,
	auto_reload = true,
})

local map = require("skypex.utils").map

map("n", "<leader>er", function()
	local status = devenv.status()

	if status == "loading" then
		return
	end

	devenv.load()
end, "Load or reload direnv in cwd")

-- map("n", "<leader>ed", function()
-- 	devenv.deny_direnv()
-- end, "Deny direnv from running in cwd")

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "DirenvLoaded",
-- 	callback = function()
-- 		-- code to run after loading environment
-- 	end,
-- })
