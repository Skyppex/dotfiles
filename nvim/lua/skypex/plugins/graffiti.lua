local graffiti_dir = require("skypex.utils").get_code_path() .. "/graffiti.nvim"

-- if not require("plenary.scandir").scan_dir(graffiti_dir) then
-- 	vim.notify("Graffiti is not installed")
-- 	return {}
-- end

return {
	"graffiti",
	dir = graffiti_dir,
	config = true,
}
