local utils = require("skypex.utils")
if utils.is_home_computer_windows() then
	vim.g.undotree_DiffCommand = "FC"
else
	vim.g.undotree_DiffCommand = "diff"
end

utils.map("n", "<leader>u", vim.cmd.UndotreeToggle, "Toggle Undo Tree")
