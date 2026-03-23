local utils = require("skypex.utils")
local Path = require("plenary.path")

local M = {}

local function setup_proof(capabilities)
	local code_path = utils.get_code_path()
	local proof_path = code_path .. "/proof"
	local proof_exe = nil

	if utils.is_linux() then
		proof_exe = proof_path .. "/proof"

		if not Path:new(proof_exe):exists() then
			proof_exe = proof_path .. "/result/bin/proof"
		end
	else
		proof_exe = proof_path .. "/proof.exe"
	end

	local log_file = proof_path .. "/log.txt"
	local dictionary_file = utils.get_chezmoi_path() .. "/nvim/proof/dictionary.txt"

	vim.lsp.config("proof", {
		cmd = { proof_exe, log_file },
		single_file_support = true,
		capabilities = capabilities,
		settings = {
			proof = {
				dictionaryPath = string.gsub(dictionary_file, "\\", "/"),
				maxErrors = 6,
				maxSuggestions = 3,
				allowImplicitPlurals = true,
				ignoredWords = {},
				excludedFilePatterns = { ".*package.json^", ".*.env^" },
				excludedFileTypes = { "qf", "gitignore", "registers" },
			},
		},
	})

	vim.lsp.enable("proof")
end

vim.lsp.set_log_level("OFF")

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

local cs_ls_ex = require("csharpls_extended")

M.servers = {
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
		settings = {
			FormattingOptions = {
				EnableEditorConfigSupport = true,
				OrganizeImports = true,
			},
			MsBuild = {
				LoadProjectsOnDemand = nil,
			},
			RoslynExtensionsOptions = {
				EnableAnalyzersSupport = true,
				EnableImportCompletion = nil,
				AnalyzeOpenDocumentsOnly = nil,
				enableDecompilationSupport = true,
			},
			Sdk = {
				IncludePrereleases = true,
			},
		},
		capabilities = capabilities,
	},
	kulala_ls = {
		capabilities = capabilities,
	},
	nushell = {
		capabilities = capabilities,
	},
	qmlls = {
		handlers = {
			["textDocument/publishDiagnostics"] = function(_, result, ctx, _)
				if result then
					local filtered = {}
					for _, d in ipairs(result.diagnostics) do
						if d.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
							table.insert(filtered, d)
						end
					end
					result.diagnostics = filtered
				end
				vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx)
			end,
		},
	},
	jsonls = {
		settings = {
			json = {
				validate = { enable = true },
				format = { enable = false },
				schemaDownload = { enable = true },
				schemas = {
					{
						fileMatch = { "package.json" },
						url = "json.schemastore.org",
					},
				},
				trace = { server = "off" },
			},
		},
	},
	nixd = {
		cmd = { "nixd", "--inlay-hints=true" },
		capabilities = capabilities,
		filetypes = { "nix" },
		root_markers = { "flake.nix", ".git" },
		settings = {
			nixpkgs = {
				expr = "import <nixpkgs> {}",
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake "'
						.. os.getenv("HOME")
						.. '/.config/nixos").nixosConfigurations.'
						.. utils.get_hostname()
						.. ".options",
				},
				-- home_manager = {
				-- 	expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
				-- },
			},
		},
	},
	gopls = {},
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(modes, left, right, desc)
			utils.map(modes, left, right, "lsp: " .. desc, nil, event.buf)
		end

		local pick = require("mini.extra").pickers

		map("n", "gr", function()
			pick.lsp({ scope = "references" })
		end, "Go to References")

		map("n", "gi", function()
			pick.lsp({ scope = "implementation" })
		end, "Go to Implementation")

		map("n", "gt", function()
			pick.lsp({ scope = "type_definition" })
		end, "Go to Type Definition")

		map("n", "<leader>ss", function()
			pick.lsp({ scope = "workspace_symbol_live" })
		end, "Workspace Symbols")

		map("n", "<leader>rn", function()
			vim.lsp.buf.rename()
			vim.schedule(function()
				vim.api.nvim_cmd({ cmd = "wa" }, {})
			end)
		end, "[R]e[n]ame")

		map("n", "gD", function()
			pick.lsp({ scope = "declaration" })
		end, "Go to Declaration")

		map("n", "gd", function()
			pick.lsp({ scope = "definition" })
		end, "Go to Definition")

		map("nx", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
		map("n", "H", vim.lsp.buf.signature_help, "Signature Help")
		map("i", "<c-h>", vim.lsp.buf.signature_help, "Signature Help")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
			local server = M.servers[client.name]
			local gd_exists, _ = require("skypex.utils").local_keymap_exists(event.buf, "n", "gd")

			if server and server.override_gd then
				server.override_gd(event.buf)
			elseif not gd_exists then
				map("n", "gd", function()
					pick.lsp({ scope = "definition" })
				end, "Go to Definition")
			end
		end

		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "Toggle Inlay Hints")
		end

		if client then
			local server = M.servers[client.name]

			if server and server.after_attach then
				server.after_attach(client)
			end
		end
	end,
})

local no_config_servers = {
	"rust_analyzer",
	"rust-analyzer",
}

local no_install_servers = {
	"nushell",
	"kulala_ls",
	"json_ls",
	"nixd",
	"terraform-ls",
}

setup_proof(capabilities)

require("mason").setup()

local servers_to_install = vim.tbl_deep_extend("keep", M.servers, {})

for k, _ in pairs(M.servers) do
	for _, v in ipairs(no_install_servers) do
		if k == v then
			servers_to_install[k] = nil
		end
	end
end

local ensure_installed = vim.tbl_keys(servers_to_install or {})
vim.list_extend(ensure_installed, {
	"lua-language-server",
	"csharp-language-server",
	"gopls",
	"ruff",
	"pyright",
	"typescript-language-server",
	"vue-language-server",
	"graphql-language-service-cli",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	automatic_enable = true,
})

local function should_not_configure(server_name)
	for _, v in ipairs(no_config_servers) do
		if server_name == v then
			return true
		end

		return false
	end
end

for server_name, config in pairs(M.servers) do
	config = config or {}

	if should_not_configure(server_name) then
		goto continue
	end

	config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
	config.handlers = vim.tbl_deep_extend("force", {}, vim.lsp.handlers, config.handlers or {})

	vim.lsp.config(server_name, config)
	vim.lsp.enable(server_name)

	::continue::
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

return M
