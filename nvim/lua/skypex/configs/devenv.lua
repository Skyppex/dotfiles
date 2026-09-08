local devenv = require("devenv")

devenv.setup({
	auto_load = true,
	auto_reload = true,
	eager_manager = true,
})

local map = require("skypex.utils").map

map("n", "<leader>er", function()
	local status = devenv.status()

	if status == "loading" then
		return
	end

	devenv.load()
end, "Load or reload direnv in cwd")

map("n", "<leader>eu", devenv.up, "start all devenv processes")
map("n", "<leader>ed", devenv.down, "stop all devenv processes")
map("n", "<leader>te", devenv.process_panel_toggle, "toggle process_panel")

map("n", "<leader>eq", function()
	devenv.revoke()
end, "Prevent devenv from running in cwd")

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = "devenv://processes",
	callback = function(args)
		local buf = args.buf
		map("n", "<c-r>", devenv.process_panel_line_start, "start process below cursor", nil, buf)
		map("n", "<c-q>", devenv.process_panel_line_stop, "stop process below cursor", nil, buf)
	end,
})

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
			prompt = "allow devenv the load in this project? (y/n)",
			scope = "cursor",
		}, function(result)
			if result == "y" or result == "Y" or result == "yes" or result == "Yes" or result == "YES" then
				devenv.allow()
			end
		end)
	end,
})
