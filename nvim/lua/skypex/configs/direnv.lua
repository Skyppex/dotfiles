local direnv = require("direnv")

direnv.setup({
	autoload_direnv = true,
	statusline = {
		enabled = true,
		icon = "",
	},
	keybindings = false,
	notification = {
		silent_autoload = true,
	},
})

local map = require("skypex.utils").map

map("n", "<leader>er", function()
	local status = direnv.statusline()

	if status == " active" then
		direnv.check_direnv()
		return
	end

	if status == " pending" then
		return
	end

	direnv.allow_direnv()
end, "Load or reload direnv in cwd")

map("n", "<leader>ed", function()
	direnv.deny_direnv()
end, "Deny direnv from running in cwd")

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "DirenvLoaded",
-- 	callback = function()
-- 		-- code to run after loading environment
-- 	end,
-- })
