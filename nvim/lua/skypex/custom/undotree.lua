vim.g.undotree_DiffCommand = "FC"
require("skypex.utils").nmap("<leader>u", vim.cmd.UndotreeToggle, "Toggle Undo Tree")
