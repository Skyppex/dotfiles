local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

local leader = "SPC"

local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "left",
		shortcut = "[" .. sc .. "] ",
		cursor = 1,
		-- width = 50,
		align_shortcut = "left",
		hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
		shrink_margin = false,
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

local file_icons = {
	enabled = true,
	highlight = true,
	-- available: devicons, mini, to use nvim-web-devicons or mini.icons
	-- if provider not loaded and enabled is true, it will try to use another provider
	provider = "devicons",
}

local function icon(fn)
	if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
		vim.notify(
			"Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons",
			vim.log.levels.WARN
		)
		file_icons.enabled = false
		return "", ""
	end

	local utils = require("alpha.utils")

	local ico, hl = utils.get_file_icon(file_icons.provider, fn)
	if ico == "" then
		file_icons.enabled = false
		vim.notify("Alpha: Mini icons or devicons get icon failed, disable file icons", vim.log.levels.WARN)
	end
	return ico, hl
end

local function file_button(fn, sc, short_fn, autocd)
	short_fn = if_nil(short_fn, fn)
	local ico_txt
	local fb_hl = {}
	if file_icons.enabled then
		local ico, hl = icon(fn)
		local hl_option_type = type(file_icons.highlight)
		if hl_option_type == "boolean" then
			if hl and file_icons.highlight then
				table.insert(fb_hl, { hl, 0, #ico })
			end
		end
		if hl_option_type == "string" then
			table.insert(fb_hl, { file_icons.highlight, 0, #ico })
		end
		ico_txt = ico .. "  "
	else
		ico_txt = ""
	end
	local cd_cmd = (autocd and " | cd %:p:h" or "")
	local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
	end
	file_button_el.opts.hl = fb_hl
	return file_button_el
end

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
	opts = opts or mru_opts
	items_number = if_nil(items_number, 10)
	local oldfiles = {}
	for _, v in pairs(vim.v.oldfiles) do
		if #oldfiles == items_number then
			break
		end
		local cwd_cond
		if not cwd then
			cwd_cond = true
		else
			cwd_cond = vim.startswith(v, cwd)
		end
		local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
		if (filereadable(v) == 1) and cwd_cond and not ignore then
			oldfiles[#oldfiles + 1] = v
		end
	end

	local tbl = {}
	for i, fn in ipairs(oldfiles) do
		local short_fn
		if cwd then
			short_fn = fnamemodify(fn, ":.")
		else
			short_fn = fnamemodify(fn, ":~")
		end
		local file_button_el = file_button(fn, tostring(i + start - 1), short_fn, opts.autocd)
		tbl[i] = file_button_el
	end
	return {
		type = "group",
		val = tbl,
		opts = {},
	}
end

return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"nobbmaestro/nvim-andromeda",
		event = "VimEnter",
		lazy = true,
		dependencies = {
			"tjdevries/colorbuddy.nvim",
		},
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			require("andromeda").setup({
				preset = "andromeda",
				transparent_bg = true,
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("andromeda")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
			vim.cmd.hi("gitsignscurrentlineblame guifg=#ff8800 guibg=none")
			vim.cmd.hi("CursorLine guibg=none")
			vim.cmd.hi("CursorLineNr guibg=none")
			vim.cmd.hi("Visual guibg=#2e2e2e")
			vim.cmd.hi("LspInlayHint guifg=#464959")
		end,
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = {
			"echasnovski/mini.icons",
			{
				"MaximilianLloyd/ascii.nvim",
				dependencies = { "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
			},
		},
		config = function()
			-- require("alpha").setup(require("alpha.themes.startify").config)
			local alpha = require("alpha")
			local ascii = require("ascii")
			require("telescope").load_extension("ascii")

			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = ascii.art.text.neovim.sharp

			-- dashboard.section.header.val = {
			--
			-- 	[[          ▀████▀▄▄              ▄█ ]],
			-- 	[[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
			-- 	[[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
			-- 	[[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
			-- 	[[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
			-- 	[[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
			-- 	[[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
			-- 	[[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
			-- 	[[   █   █  █      ▄▄           ▄▀   ]],
			-- }

			dashboard.section.buttons.val = {}
			-- dashboard.section.buttons.val = {
			-- 	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			-- 	dashboard.button(":ene <BAR> startinsert <CR>", "  New file", "e"),
			-- 	dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
			-- 	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
			-- 	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.vim<CR>"),
			-- 	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
			-- }

			dashboard.section.mru = {
				type = "group",
				val = function()
					return { mru(10) }
				end,
			}

			dashboard.section.header.opts.hl = "Include"

			dashboard.opts.opts.noautocmd = true

			alpha.setup(dashboard.opts)
		end,
	},
}
