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

local map = require("skypex.utils").map
map("n", "<leader>Fmir", "<cmd>CellularAutomaton make_it_rain<cr>", "Make it rain")
map("n", "<leader>Fgol", "<cmd>CellularAutomaton game_of_life<cr>", "Game of life")
map("n", "<leader>Fscr", "<cmd>CellularAutomaton scramble<cr>", "Scramble")
map("n", "<leader>Fsld", "<cmd>CellularAutomaton slide<cr>", "Slide")
