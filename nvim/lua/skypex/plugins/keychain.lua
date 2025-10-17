local keychain_dir = require("skypex.utils").get_code_path() .. "/keychain.nvim"

local Path = require("plenary.path")
local path = Path:new(keychain_dir)

if path:is_dir() then
	return {
		"keychain.nvim",
		dir = keychain_dir,
		config = function()
			require("skypex.custom.keychain")
		end,
	}
end

return {
	"skyppex/keychain.nvim",
	config = function()
		require("skypex.custom.keychain")
	end,
}
