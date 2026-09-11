local devenv = require("devenv")

devenv.setup({
	auto_load = true,
	auto_reload = true,
	eager_manager = true,
	watch_trust = true,
})

local map = require("skypex.utils").map

map("n", "<leader>er", function()
	local status = devenv.status()

	if status == "loading" then
		return
	end

	devenv.load()
end, "Load or reload direnv in cwd")

map("n", "<leader>eq", function()
	devenv.revoke()
end, "Prevent devenv from running in cwd")

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "DevenvLoaded",
-- 	callback = function()
-- 		-- code to run after loading environment
-- 	end,
-- })

vim.api.nvim_create_autocmd("User", {
	pattern = "DevenvBlocked",
	callback = function()
		local status = devenv.status()
		vim.notify("status: " .. status)
		if status ~= "blocked" then
			vim.notify("not blocked?")
			return
		end

		vim.ui.input({
			prompt = "trust devenv in this project? (y/n)",
			scope = "cursor",
		}, function(result)
			if result == "y" or result == "Y" or result == "yes" or result == "Yes" or result == "YES" then
				devenv.allow()
			end
		end)
	end,
})
