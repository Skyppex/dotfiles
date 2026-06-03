local utils = require("skypex.utils")

while true do
	if utils.direnv_status() ~= "pending" then
		break
	end
end

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

vim.lsp.log.set_level("OFF")

local capabilities = require("blink.cmp").get_lsp_capabilities(nil, true)

local cs_ls_ex = require("csharpls_extended")

M.servers = {
	lua_ls = {
		filetypes = { "lua" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("lua", true),
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
	},
	kulala_ls = {},
	nushell = {},
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
						url = "https://json.schemastore.org/package.json",
					},
				},
				trace = { server = "off" },
			},
		},
	},
	nixd = {
		cmd = { "nixd", "--inlay-hints=true" },
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
	tsgo = {
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	},
	ts_ls = {
		filetypes = { "vue" },
	},
}

-- takes only the first item for each starting line number
local function filter_items(t)
	local items = {}
	local lnums = {}

	for _, item in ipairs(t.items) do
		local lnum = tostring(item.lnum)

		if lnums[lnum] == nil then
			table.insert(items, item)
			lnums[lnum] = true
		end
	end

	return items
end

local function jump_to(item)
	local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
	vim.bo[bufnr].buflisted = true
	vim.cmd("normal! m'") -- push current pos to jumplist (optional)
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, bufnr)
	pcall(vim.api.nvim_win_set_cursor, win, { item.lnum, item.col - 1 })
	vim.cmd("normal! zz")
end

local function request(method, on_list)
	if method == "references" then
		vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
	else
		vim.lsp.buf[method]({ on_list = on_list })
	end
end

local function jump_or_pick(method)
	return function()
		request(method, function(t)
			local items = filter_items(t)

			-- single result: jump straight there
			if #items == 1 then
				jump_to(items[1])
				return
			end

			-- multiple results: open mini.pick
			require("mini.pick").start({
				source = {
					name = t.title or method,
					items = vim.tbl_map(function(it)
						return {
							text = string.format(
								"%s:%d:%d: %s",
								vim.fn.fnamemodify(it.filename, ":~:."),
								it.lnum,
								it.col,
								(it.text or ""):gsub("^%s*", "")
							),
							path = it.filename,
							lnum = it.lnum,
							col = it.col,
						}
					end, items),
				},
			})
		end)
	end
end

local function jump_or_qf(method)
	return function()
		request(method, function(t)
			local items = t.items

			-- single result: jump straight there
			if #items == 1 then
				jump_to(items[1])
				return
			end

			vim.fn.setqflist({}, " ", {
				title = t.title or method,
				items = items,
				context = t.context,
			})

			local quicker = require("quicker")

			if not quicker.is_open() then
				quicker.open()
			end
		end)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(modes, left, right, desc)
			utils.map(modes, left, right, "lsp: " .. desc, nil, event.buf)
		end

		map("n", "gr", jump_or_qf("references"), "put references in quickfix list")
		map("n", "gi", jump_or_qf("implementation"), "put implementations in quickfix list")
		map("n", "gt", jump_or_pick("type_definition"), "go to type definition")
		map("n", "gD", jump_or_pick("declaration"), "go to declaration")
		map("n", "gd", jump_or_pick("definition"), "go to definition")

		map("n", "<leader>rn", function()
			vim.lsp.buf.rename()
			vim.schedule(function()
				vim.cmd("wa")
			end)
		end, "rename")

		map("nx", "<leader>ca", vim.lsp.buf.code_action, "code action")
		map("n", "K", vim.lsp.buf.hover, "hover documentation")
		map("n", "H", vim.lsp.buf.signature_help, "signature help")
		map("i", "<c-h>", vim.lsp.buf.signature_help, "signature help")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
			local server = M.servers[client.name]
			local gd_exists, _ = require("skypex.utils").local_keymap_exists(event.buf, "n", "gd")

			if server and server.override_gd then
				server.override_gd(event.buf)
			elseif not gd_exists then
				map("n", "gd", function()
					map("n", "gd", jump_or_pick("definition"), "go to definition")
				end, "go to definition")
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
	"tsgo",
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
	end

	return false
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
	signs = false,
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
		border = require("skypex.style").border,
		source = true,
		header = "",
		prefix = "",
	},
})

return M
