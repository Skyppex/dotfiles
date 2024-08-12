return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"folke/neodev.nvim",
			"j-hui/fidget.nvim",
			"Decodetalkers/csharpls-extended-lsp.nvim",
			-- "Hoffs/omnisharp-extended-lsp.nvim",
			-- "Issafalcon/lsp-overloads.nvim",
			{
				"mfussenegger/nvim-lint",
				config = function()
					local lint = require("lint")

					lint.linters_by_ft = {
						lua = { "luacheck" },
						javascript = { "eslint_d" },
						typescript = { "eslint_d" },
					}

					vim.api.nvim_create_autocmd("BufWritePost", {
						group = vim.api.nvim_create_augroup("lint", { clear = true }),
						callback = function()
							lint.try_lint()
						end,
					})
				end,
			},
		},
		opts = {
			setup = {
				rust_analyzer = function()
					return true
				end,
			},
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local mapnv = function(keys, func, desc)
						vim.keymap.set({ "n", "v" }, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local builtin = require("telescope.builtin")
					-- Jump to the definition of the word under your cursor.--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", builtin.lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("<leader>ss", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", function()
						vim.lsp.buf.rename()
						vim.schedule(function()
							vim.api.nvim_cmd({ cmd = "wa" }, {})
						end)
					end, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					mapnv("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Opens a popup that displays the signature of whatever is under your cursor
					map("H", vim.lsp.buf.signature_help, "Signature Help")
					vim.keymap.set(
						"i",
						"<A-H>",
						vim.lsp.buf.signature_help,
						{ buffer = event.buf, desc = "LSP: Signature Help" }
					)

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following autocommand is used to enable inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- -- LOOK IN CURRENT DIRECTORY FOR csproj FILE using glob
			-- -- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
			-- local function find_closest_csproj(directory)
			-- 	-- print("currentFileDirectory: " .. directory)
			-- 	local csproj = vim.fn.glob(directory .. "/*.csproj", true, false)
			-- 	if csproj == "" then
			-- 		csproj = vim.fn.glob(directory .. "/*.vbproj", true, false)
			-- 	end
			-- 	if csproj == "" then
			-- 		-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
			-- 		local parent_directory = vim.fn.fnamemodify(directory, ":h")
			-- 		if parent_directory == directory then
			-- 			return nil
			-- 		end
			-- 		return find_closest_csproj(parent_directory)
			-- 	-- elseif there are multiple csproj files, then return the first one
			-- 	elseif string.find(csproj, "\n") ~= nil then
			-- 		local first_csproj = string.sub(csproj, 0, string.find(csproj, "\n") - 1)
			-- 		print("Found multiple csproj files, using: " .. first_csproj)
			-- 		return first_csproj
			-- 	else
			-- 		return csproj
			-- 	end
			-- end
			--
			-- -- CHECK CSPROJ FILE TO SEE IF ITS .NET CORE OR .NET FRAMEWORK
			-- local function getFrameworkType()
			-- 	local currentFileDirectory = vim.fn.expand("%:p:h")
			-- 	-- print("currentFileDirectory file: " .. currentFileDirectory)
			-- 	local csproj = find_closest_csproj(currentFileDirectory)
			-- 	-- print("csproj file: " .. csproj)
			-- 	if csproj == nil then
			-- 		return false
			-- 	end
			-- 	local f = io.open(csproj, "rb")
			-- 	local content = f:read("*all")
			-- 	f:close()
			-- 	-- return string.find(content, "<TargetFramework>netcoreapp") ~= nil
			-- 	local frameworkType = ""
			-- 	-- IF FILE CONTAINS <TargetFrameworkVersion> THEN IT'S .NET FRAMEWORK
			-- 	if string.find(content, "<TargetFrameworkVersion>") ~= nil then
			-- 		frameworkType = "netframework"
			-- 	-- IF FILE CONTAINS <TargetFramework>net48 THEN IT'S .NET FRAMEWORK
			-- 	elseif string.find(content, "<TargetFramework>net48") ~= nil then
			-- 		frameworkType = "netframework"
			-- 	-- ELSE IT'S .NET CORE
			-- 	else
			-- 		frameworkType = "netcore"
			-- 	end
			-- 	return frameworkType
			-- end

			-- CREATE AUTOCMD FOR CSHARP FILES
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	-- pattern = 'cs',
			-- 	pattern = { "cs", "cshtml", "vb" },
			-- 	callback = function()
			-- 		-- print("FileType: cs, cshtml, vb")
			-- 		if vim.g.dotnetlsp then
			-- 			-- print("dotnetlsp is already set: " .. vim.g.dotnetlsp)
			-- 			return
			-- 		end
			--
			-- 		local on_attach = function(client, bufnr)
			-- 			--- Guard against servers without the signatureHelper capability
			-- 			if client.server_capabilities.signatureHelpProvider then
			-- 				require("lsp-overloads").setup(client, {})
			-- 				-- ...
			-- 				-- keymaps = {
			-- 				-- 		next_signature = "<C-j>",
			-- 				-- 		previous_signature = "<C-k>",
			-- 				-- 		next_parameter = "<C-l>",
			-- 				-- 		previous_parameter = "<C-h>",
			-- 				-- 		close_signature = "<A-s>"
			-- 				-- 	},
			-- 				-- ...
			-- 			end
			--
			-- 			vim.keymap.set("n", "gd", function()
			-- 				require("omnisharp_extended").telescope_lsp_definitions()
			-- 			end, { buffer = bufnr, desc = "LSP: [G]oto [D]efinition", noremap = true, silent = true })
			-- 		end
			--
			-- 		-- SEE: https://github.com/omnisharp/omnisharp-roslyn
			-- 		local settings = {
			-- 			FormattingOptions = {
			-- 				-- Enables support for reading code style, naming convention and analyzer
			-- 				-- settings from .editorconfig.
			-- 				EnableEditorConfigSupport = true,
			-- 				-- Specifies whether 'using' directives should be grouped and sorted during
			-- 				-- document formatting.
			-- 				OrganizeImports = true,
			-- 			},
			-- 			MsBuild = {
			-- 				-- If true, MSBuild project system will only load projects for files that
			-- 				-- were opened in the editor. This setting is useful for big C# codebases
			-- 				-- and allows for faster initialization of code navigation features only
			-- 				-- for projects that are relevant to code that is being edited. With this
			-- 				-- setting enabled OmniSharp may load fewer projects and may thus display
			-- 				-- incomplete reference lists for symbols.
			-- 				LoadProjectsOnDemand = nil,
			-- 			},
			-- 			RoslynExtensionsOptions = {
			-- 				-- Enables support for roslyn analyzers, code fixes and rulesets.
			-- 				EnableAnalyzersSupport = false, -- THIS ADED FIX FORMATTING ON EVERY SINGLE LINE IN CS FILES!
			-- 				-- Enables support for showing unimported types and unimported extension
			-- 				-- methods in completion lists. When committed, the appropriate using
			-- 				-- directive will be added at the top of the current file. This option can
			-- 				-- have a negative impact on initial completion responsiveness,
			-- 				-- particularly for the first few completion sessions after opening a
			-- 				-- solution.
			-- 				EnableImportCompletion = nil,
			-- 				-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
			-- 				-- true
			-- 				AnalyzeOpenDocumentsOnly = nil,
			-- 				enableDecompilationSupport = true,
			-- 			},
			-- 			Sdk = {
			-- 				-- Specifies whether to include preview versions of the .NET SDK when
			-- 				-- determining which version to use for project loading.
			-- 				IncludePrereleases = true,
			-- 			},
			-- 		}
			--
			-- 		-- CHECK THE CSPROJ OR SOMETHING ELSE TO CONFIRM IT'S .NET FRAMEWORK OR .NET CORE PROJECT
			-- 		local frameworkType = getFrameworkType()
			-- 		if frameworkType == "netframework" then
			-- 			print("Found a .NET Framework project, starting .NET Framework OmniSharp")
			-- 			require("lspconfig").omnisharp_mono.setup({
			-- 				enable_decompilation_support = true,
			-- 				handlers = {
			-- 					["textDocument/definition"] = require("omnisharp_extended").handler,
			-- 				},
			-- 				organize_imports_on_format = true,
			-- 				settings = settings,
			-- 				on_attach = on_attach,
			-- 			})
			-- 			vim.g.dotnetlsp = "omnisharp_mono"
			-- 			vim.cmd("LspStart omnisharp_mono")
			-- 		elseif frameworkType == "netcore" then
			-- 			print("Found a .NET Core project, starting .NET Core OmniSharp")
			-- 			require("lspconfig").omnisharp.setup({
			-- 				enable_decompilation_support = true,
			-- 				handlers = {
			-- 					["textDocument/definition"] = require("omnisharp_extended").handler,
			-- 				},
			-- 				organize_imports_on_format = true,
			-- 				settings = settings,
			-- 				on_attach = on_attach,
			-- 			})
			-- 			vim.g.dotnetlsp = "omnisharp"
			-- 			vim.cmd("LspStart omnisharp")
			-- 		else
			-- 			return
			-- 		end
			-- 	end,
			-- 	group = vim.api.nvim_create_augroup("_nvim-lspconfig.lua.filetype.csharp", { clear = true }),
			-- })

			local cmp_lsp = require("cmp_nvim_lsp")
			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

			require("fidget").setup({})

			-- Define variables use din the server configuration below
			local lspconfig = require("lspconfig")
			local csharpls = vim.fn.stdpath("data") .. "/mason/bin/csharp-ls.cmd"
			local cs_ls_ex = require("csharpls_extended")

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--

				lua_ls = {
					-- filetypes = { "lua" },
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = {
								disable = { "missing-fields", "undefined-fields" },
								globals = { "vim" },
							},
						},
					},
					capabilities = capabilities,
				},
				csharp_ls = {
					cmd = { csharpls },
					filetypes = { "cs", "csx" },
					single_file_support = true,
					handlers = {
						["textDocument/definition"] = function(err, result, ctx, config)
							if err then
								vim.notify("Error: " .. err, vim.log.levels.ERROR)
							else
								vim.notify("Result: " .. vim.inspect(result), vim.log.levels.INFO)
							end
							cs_ls_ex.handler(err, result, ctx, config)
						end,
						["textDocument/typeDefinition"] = cs_ls_ex.handler,
					},
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "gd", function()
							cs_ls_ex.lsp_definitions()
						end, {
							buffer = bufnr,
							desc = "csharls: [G]oto [D]efinition",
							noremap = true,
							silent = true,
						})
					end,
					capabilities = capabilities,
				},
			}

			lspconfig.nushell.setup({
				cmd = { "nu", "--lsp" },
				filetypes = { "nu" },
				single_file_support = true,
				root_dir = lspconfig.util.find_git_ancestor,
				capabilities = capabilities,
			})

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"lua-language-server",
				"stylua", -- Used to format Lua code
				"rust-analyzer",
				"csharp-language-server",
				-- "omnisharp",
				-- "omnisharp_mono",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						if string.find(server_name, "ltex") then
							return
						end
						-- if string.find(server_name, "omnisharp") then
						-- 	return
						-- end
						-- vim.notify("Setting up LSP: " .. server_name, vim.log.levels.INFO)
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						lspconfig[server_name].setup(server)
					end,
				},
			})

			require("skypex.proof")

			vim.diagnostic.config({
				severity_sort = true,
				update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
