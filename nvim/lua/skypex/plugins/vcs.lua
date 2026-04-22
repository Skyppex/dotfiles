local utils = require("skypex.utils")

local function is_git_repo()
	local _, exit_code = utils.run_command_ret("git", { "rev-parse", "--is-inside-work-tree" })
	return exit_code == 0
end

local function is_jj_repo()
	local _, exit_code = utils.run_command_ret("jj", { "root" })
	return exit_code == 0
end

local function jj_then_git()
	if is_jj_repo() then
		return "jj"
	end

	if is_git_repo() then
		return "git"
	end

	return nil
end

local config = {
	config = function()
		require("skypex.custom.vcs").kanji()
	end,
}

local kanji = utils.local_plugin("kanji.nvim", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/kanji.nvim",
	}, config)
end)

local git_conflict = {
	"akinsho/git-conflict.nvim",
	event = "VeryLazy",
	version = "*",
	config = function()
		require("skypex.custom.vcs").conflict()
		require("skypex.custom.vcs").cmd()
	end,
}

local gitsigns = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	config = function()
		require("skypex.custom.vcs").gitsigns()
	end,
}

local repo_type = jj_then_git()

if repo_type == "jj" then
	return kanji
end

if repo_type == "git" then
	return {
		git_conflict,
		gitsigns,
	}
end

return {}
