local function trigger_hop_command(cmd, opts, cmdname)
	vim.notify("trigger_hop_command: " .. cmdname)
	vim.api.nvim_command("doautocmd User " .. cmdname)
	cmd(opts)
end
local hop = require("hop")
local hint = require("hop.hint")

hop.setup({
	keys = "qweasdzxcyuiohjklnm,.",
	quit_key = "<C-c>",
	multi_windows = true,
})

local nxmap = require("skypex.utils").nxmap

nxmap("<leader>hh", function()
	trigger_hop_command(hop.hint_char1, {}, "HopChar1")
end, "Hop to character 1")

nxmap("<leader>hj", function()
	trigger_hop_command(hop.hint_char2, {}, "HopChar2")
end, "Hop to character 2")

nxmap("<leader>hk", function()
	trigger_hop_command(hop.hint_patterns, {}, "HopPattern")
end, "Hop to pattern")

nxmap("<leader>hep", function()
	trigger_hop_command(hop.hint_patterns, { hint_position = hint.HintPosition.END }, "HopPattern")
end, "Hop to end of pattern")

nxmap("<leader>hmp", function()
	trigger_hop_command(hop.hint_patterns, { hint_position = hint.HintPosition.MIDDLE }, "HopPattern")
end, "Hop to middle of pattern")

nxmap("<leader>hw", function()
	trigger_hop_command(hop.hint_words, {}, "HopWord")
end, "Hop to word")

nxmap("<leader>hew", function()
	trigger_hop_command(hop.hint_words, { hint_position = hint.HintPosition.END }, "HopWord")
end, "Hop to end of word")

nxmap("<leader>hmw", function()
	trigger_hop_command(hop.hint_words, { hint_position = hint.HintPosition.MIDDLE }, "HopWord")
end, "Hop to middle of word")

nxmap("<leader>hl", function()
	trigger_hop_command(hop.hint_lines_skip_whitespace, {}, "HopLineStart")
end, "Hop to line start")
