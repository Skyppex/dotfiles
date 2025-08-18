local function setup_proof(lspconfig, configs, capabilities)
	local utils = require("skypex.utils")
	local code_path = utils.get_code_path()
	local proof_path = code_path .. "/proof"
	local proof_exe = nil

	if utils.is_linux() then
		proof_exe = proof_path .. "/proof"
	else
		proof_exe = proof_path .. "/proof.exe"
	end

	local log_file = proof_path .. "/log.txt"
	local dictionary_file = utils.get_chezmoi_path() .. "/nvim/proof/dictionary.txt"

	if not configs.proof then
		configs.proof = {
			default_config = {
				cmd = { proof_exe, log_file },
				filetypes = { "*" },
				single_file_support = true,
				root_dir = lspconfig.util.find_git_ancestor,
				settings = {},
				capabilities = capabilities,
			},
		}
	end

	lspconfig.proof.setup({
		settings = {
			proof = {
				dictionaryPath = string.gsub(dictionary_file, "\\", "/"),
				maxErrors = 6,
				maxSuggestions = 3,
				allowImplicitPlurals = true,
				ignoredWords = {},
				excludedFilePatterns = { ".*package.json^", ".*.env^" },
				excludedFileTypes = { "qf", "gitignore" },
			},
		},
	})
end

vim.lsp.set_log_level("OFF")

-- Alter hover style
local handlers = {
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	}),

	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	}),
}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		local ts_ls = nil
		for _, client in ipairs(clients) do
			if client.name == "ts_ls" then
				ts_ls = client
				break
			end
		end

		if not ts_ls then
			return
		end
		ts_ls:exec_cmd(
			{
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
			},
			{ bufnr = 0 }
			-- Optionally, you may supply a handler function as the third argument
		)
	end,
})

local cmp_lsp = require("cmp_nvim_lsp")
-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- Define variables used in the server configuration below
local lspconfig = require("lspconfig")
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
	lua_ls = {
		filetypes = { "lua" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				diagnostics = {
					globals = { "vim" },
					disable = { "missing-fields", "undefined-fields" },
				},
				telemetry = {
					enable = false,
				},
			},
		},
		capabilities = capabilities,
	},
	csharp_ls = {
		filetypes = { "cs", "csx" },
		single_file_support = true,
		handlers = {
			["textDocument/definition"] = cs_ls_ex.handler,
			["textDocument/typeDefinition"] = cs_ls_ex.handler,
			["window/showMessage"] = function(_, result, _, _)
				local fidget = require("fidget")
				fidget.notify(result.message, result.type)
			end,
			["window/logMessage"] = function(_, result, _, _)
				local fidget = require("fidget")
				fidget.notify(result.message, result.type)
			end,
		},
		after_attach = function(client)
			if client.server_capabilities.signatureHelpProvider then
				require("lsp-overloads").setup(client, {
					keymaps = {
						previous_signature = "<S-up>",
						next_signature = "<S-down>",
						previous_parameter = "<S-left>",
						next_parameter = "<S-right>",
						close_signature = "<C-e>",
					},
				})
			end
		end,
		override_gd = function(bufnr)
			require("telescope").load_extension("csharpls_definition")

			vim.keymap.set("n", "gd", function()
				vim.cmd("Telescope csharpls_definition")
				--[[ cs_ls_ex.lsp_definitions() ]]
			end, {
				buffer = bufnr,
				desc = "csharpls: Go to Definition",
				noremap = true,
				silent = true,
			})
		end,
		-- SEE: https://github.com/omnisharp/omnisharp-roslyn
		settings = {
			FormattingOptions = {
				-- Enables support for reading code style, naming convention and analyzer
				-- settings from .editorconfig.
				EnableEditorConfigSupport = true,
				-- Specifies whether 'using' directives should be grouped and sorted during
				-- document formatting.
				OrganizeImports = true,
			},
			MsBuild = {
				-- If true, MSBuild project system will only load projects for files that
				-- were opened in the editor. This setting is useful for big C# codebases
				-- and allows for faster initialization of code navigation features only
				-- for projects that are relevant to code that is being edited. With this
				-- setting enabled OmniSharp may load fewer projects and may thus display
				-- incomplete reference lists for symbols.
				LoadProjectsOnDemand = nil,
			},
			RoslynExtensionsOptions = {
				-- Enables support for roslyn analyzers, code fixes and rulesets.
				EnableAnalyzersSupport = true,
				-- Enables support for showing unimported types and unimported extension
				-- methods in completion lists. When committed, the appropriate using
				-- directive will be added at the top of the current file. This option can
				-- have a negative impact on initial completion responsiveness,
				-- particularly for the first few completion sessions after opening a
				-- solution.
				EnableImportCompletion = nil,
				-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
				-- true
				AnalyzeOpenDocumentsOnly = nil,
				enableDecompilationSupport = true,
			},
			Sdk = {
				-- Specifies whether to include preview versions of the .NET SDK when
				-- determining which version to use for project loading.
				IncludePrereleases = true,
			},
		},
		capabilities = capabilities,
	},
	tailwindcss = {
		on_attach = function(_, bufnr)
			require("tailwindcss-colors").buf_attach(bufnr)
		end,
	},
	kulala_ls = {
		capabilities = capabilities,
	},
	nushell = {
		capabilities = capabilities,
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, {
				noremap = true,
				silent = true,
				buffer = event.buf,
				desc = "LSP: " .. desc,
			})
		end

		local nvmap = function(keys, func, desc)
			vim.keymap.set({ "n", "v" }, keys, func, {
				noremap = true,
				silent = true,
				buffer = event.buf,
				desc = "LSP: " .. desc,
			})
		end

		local builtin = require("telescope.builtin")

		nmap("gr", builtin.lsp_references, "Go to References")
		nmap("gi", builtin.lsp_implementations, "Go to Implementation")
		nmap("gt", builtin.lsp_type_definitions, "Go to Type Definition")
		nmap("<leader>ss", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

		nmap("<leader>rn", function()
			vim.lsp.buf.rename()
			vim.schedule(function()
				vim.api.nvim_cmd({ cmd = "wa" }, {})
			end)
		end, "[R]e[n]ame")

		local ap = require("actions-preview")

		nvmap("<leader>ca", ap.code_actions, "Code Action")
		nmap("K", vim.lsp.buf.hover, "Hover Documentation")
		nmap("H", vim.lsp.buf.signature_help, "Signature Help")

		vim.keymap.set("i", "<C-M-H>", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "LSP: Signature Help" })

		nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
			local server = servers[client.name]
			local gd_exists, rhs = require("skypex.utils").local_keymap_exists(event.buf, "n", "gd")

			if server and server.override_gd then
				server.override_gd(event.buf)
			elseif not gd_exists then
				nmap("gd", builtin.lsp_definitions, "Go to Definition")
			end
		end

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
			nmap("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "Toggle Inlay Hints")
		end

		if client then
			local server = servers[client.name]

			if server and server.after_attach then
				server.after_attach(client)
			end
		end
	end,
})

local no_config_servers = { "rust_analyzer" }
local configs = require("lspconfig.configs")

setup_proof(lspconfig, configs)

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
	"rust-analyzer",
	"csharp-language-server",
	"codelldb",
	"gopls",
	"graphql-language-service-cli",
	"python-lsp-server",
	"typescript-language-server",
	"tailwindcss-language-server",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	automatic_enable = true,
})

for server_name, config in pairs(servers) do
	local server = config or {}

	if no_config_servers[server_name] ~= nil then
		return
	end

	-- This handles overriding only values explicitly passed
	-- by the server configuration above. Useful when disabling
	-- certain features of an LSP (for example, turning off formatting for tsserver)
	server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	server.handlers = vim.tbl_deep_extend("force", {}, vim.lsp.handlers, handlers, server.handlers or {})

	vim.lsp.config(server_name, server)
	vim.lsp.enable(server_name)
end

vim.diagnostic.config({
	virtual_text = {
		source = true,
		spacing = 2,
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
	},
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
