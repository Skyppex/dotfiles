local cloak = require("cloak")

cloak.setup({
	cloak_length = 8,
	cloak_on_leave = true,
	patterns = {
		{
			-- Match any file containing '.env'.
			file_pattern = {
				-- Match any file containing '.env'.
				"*.env*",
			},
			-- Match an equals sign and any character after it.
			-- This can also be a table of patterns to cloak,
			-- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
			cloak_pattern = {
				"=.+",
				":.+",
				"-.+",
			},
			-- A function, table or string to generate the replacement.
			-- The actual replacement will contain the 'cloak_character'
			-- where it doesn't cover the original text.
			-- If left empty the legacy behavior of keeping the first character is retained.
			replace = nil,
		},
	},
})

local nmap = require("skypex.utils").nmap

nmap("<leader>tc", "<cmd>CloakToggle<cr>", "Toggle cloak")

local function disable_cloak_preview_line(buf)
	-- turn off; delete autocmd group and unset flag
	local buffer = vim.b[buf]

	if buffer.cloak_preview_line_group then
		pcall(vim.api.nvim_del_augroup_by_id, buffer.cloak_preview_line_group)
	end

	buffer.cloak_preview_line_active = false
	buffer.cloak_preview_line_group = nil
	cloak.opts.uncloaked_line_num = nil
	cloak.recloak_file(vim.api.nvim_buf_get_name(0))
end

local function toggle_cloak_preview_line()
	if vim.b.cloak_preview_line_active then
		disable_cloak_preview_line(0)
	else
		-- turn on; create autocmd group and set flag
		local group =
			vim.api.nvim_create_augroup("CloakPreviewLine_" .. vim.api.nvim_get_current_buf(), { clear = true })

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
			group = group,
			buffer = 0,
			callback = function(args)
				if args.event == "BufLeave" then
					disable_cloak_preview_line(args.buf)
					return
				end

				vim.cmd("silent! CloakPreviewLine")
			end,
			desc = "Cloak: Auto-preview line on cursor move",
		})

		vim.b.cloak_preview_line_active = true
		vim.b.cloak_preview_line_group = group
		vim.cmd("silent! CloakPreviewLine")
	end
end

nmap("<leader>tC", toggle_cloak_preview_line, "Toggle cloak line-follow preview")
