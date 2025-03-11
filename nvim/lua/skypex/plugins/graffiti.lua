local graffiti_dir = require("skypex.utils").get_code_path() .. "/graffiti.nvim"

local Path = require("plenary.path")
local path = Path:new(graffiti_dir)

if not path:is_dir() then
	return {
		"skyppex/graffiti.nvim",
		name = "graffiti",
		opts = {
			server_executable = vim.fn.stdpath("data") .. "/graffiti-rs/target/release/graffiti-rs.exe",
		},
		build = function()
			if vim.fn.executable(vim.fn.stdpath("data") .. "graffiti-rs/target/release/graffiti-rs.exe") ~= 0 then
				return
			end

			local Job = require("plenary.job")
			Job:new({
				command = "git",
				args = {
					"clone",
					"git@github.com:Skyppex/graffiti-rs.git",
					vim.fn.stdpath("data") .. "/graffiti-rs",
				},
				on_exit = function()
					Job:new({
						command = "cargo",
						args = {
							"build",
							"--release",
							"--manifest-path",
							vim.fn.stdpath("data") .. "/graffiti-rs/Cargo.toml",
							"--target-dir",
							vim.fn.stdpath("data") .. "/graffiti-rs/target",
						},
					}):start()
				end,
			}):start()
		end,
		config = function()
			require("skypex.custom.graffiti")
		end,
	}
end

return {
	"graffiti",
	dir = graffiti_dir,
	config = function()
		require("skypex.custom.graffiti")
	end,
}
