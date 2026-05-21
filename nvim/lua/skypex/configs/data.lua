-- json
local jq = require("jq-playground")

local jq_output_name = "jq-out"
local jq_query_name = "jq-query"

jq.setup({
	cmd = { "jq" },
	output_window = {
		split_direction = "right",
		width = nil,
		height = nil,
		scratch = true,
		filetype = "json",
		name = jq_output_name,
	},
	query_window = {
		split_direction = "below",
		width = nil,
		height = 0.3,
		scratch = true,
		filetype = "jq",
		name = jq_query_name,
	},
})

local utils = require("skypex.utils")
local map = utils.map

map("n", "<leader>tj", function()
	local visible = false
	local jq_output_buf = utils.bufs_by_name(jq_output_name)

	if jq_output_buf ~= nil then
		if utils.is_buf_visible(jq_output_buf) then
			visible = true
		end

		vim.api.nvim_buf_delete(jq_output_buf, { force = true })
	end

	local jq_query_buf = utils.bufs_by_name(jq_query_name)

	if jq_query_buf ~= nil then
		if utils.is_buf_visible(jq_query_buf) then
			visible = true
		end

		vim.api.nvim_buf_delete(jq_query_buf, { force = true })
	end

	if not visible then
		jq.open()
	end
end, "toggle jq playground")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if vim.b.jqplayground_inputbuf == nil then
			return
		end

		vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, { "." })
	end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	callback = function()
		if vim.b.jqplayground_inputbuf == nil then
			return
		end

		jq.run_query()
	end,
})
