return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	event = { "BufReadPre", "BufNewFile" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", {
			desc = "Preview Markdown",
			noremap = true,
			silent = true,
		})
	end,
}
