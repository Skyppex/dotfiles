local M = {}

M.cellular_automation = function()
	local slide = {
		fps = 50,
		name = "slide",
	}

	-- slide.init = function(grid) end

	--- @class GridItem
	--- @field char string
	--- @field hl_group string
	---
	--- @param grid GridItem[][]
	slide.update = function(grid)
		for i = 1, #grid do
			local prev = grid[i][#grid[i]]
			for j = 1, #grid[i] do
				grid[i][j], prev = prev, grid[i][j]
			end
		end
		return true
	end

	require("cellular-automaton").register_animation(slide)

	vim.keymap.set("n", "<leader>fmir", "<cmd>CellularAutomaton make_it_rain<cr>", { desc = "Make it rain" })
	vim.keymap.set("n", "<leader>fgol", "<cmd>CellularAutomaton game_of_life<cr>", { desc = "Game of life" })
	vim.keymap.set("n", "<leader>fscr", "<cmd>CellularAutomaton scramble<cr>", { desc = "Scramble" })
	vim.keymap.set("n", "<leader>fsld", "<cmd>CellularAutomaton slide<cr>", { desc = "Slide" })
end

M.all = M.cellular_automation

return M
