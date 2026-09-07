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

-- map("n", "<leader>ed", function()
-- 	devenv.deny_direnv()
-- end, "Deny direnv from running in cwd")

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "DirenvLoaded",
-- 	callback = function()
-- 		-- code to run after loading environment
-- 	end,
-- })

map("n", "<leader>eu", devenv.up, "start all devenv processes")
map("n", "<leader>ed", devenv.down, "stop all devenv processes")
map("n", "<leader>te", devenv.process_panel_toggle, "toggle process_panel")

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = "devenv://processes",
	callback = function(args)
		local buf = args.buf
		map("n", "<c-r>", devenv.process_panel_line_start, "start process below cursor", nil, buf)
		map("n", "<c-q>", devenv.process_panel_line_stop, "stop process below cursor", nil, buf)
	end,
})
