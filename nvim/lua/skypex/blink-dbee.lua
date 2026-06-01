--- @module 'blink.cmp'
--- @class blink.cmp.Source
---
--- blink-dbee: A blink.cmp completion source for nvim-dbee.
--- Provides SQL keyword, table, column, and schema completions
--- based on the currently active dbee connection's structure.
---
--- Usage in lazy.nvim:
---   {
---     "saghen/blink.cmp",
---     opts = {
---       sources = {
---         default = { "lsp", "path", "snippets", "buffer", "dbee" },
---         providers = {
---           dbee = {
---             name = "Dbee",
---             module = "blink-dbee",
---             opts = {
---               -- Only complete in these filetypes (optional – nil = always on)
---               filetypes = { "sql", "mysql", "plsql" },
---             },
---           },
---         },
---       },
---     },
---   }

local source = {}

-- ─── SQL keyword list ────────────────────────────────────────────────────────
-- local SQL_KEYWORDS = {
-- 	"SELECT",
-- 	"select",
-- 	"FROM",
-- 	"from",
-- 	"WHERE",
-- 	"where",
-- 	"INSERT",
-- 	"insert",
-- 	"INTO",
-- 	"into",
-- 	"VALUES",
-- 	"values",
-- 	"UPDATE",
-- 	"update",
-- 	"SET",
-- 	"set",
-- 	"DELETE",
-- 	"delete",
-- 	"CREATE",
-- 	"create",
-- 	"TABLE",
-- 	"table",
-- 	"DROP",
-- 	"drop",
-- 	"ALTER",
-- 	"alter",
-- 	"ADD",
-- 	"add",
-- 	"COLUMN",
-- 	"column",
-- 	"INDEX",
-- 	"index",
-- 	"JOIN",
-- 	"join",
-- 	"INNER",
-- 	"inner",
-- 	"LEFT",
-- 	"left",
-- 	"RIGHT",
-- 	"right",
-- 	"FULL",
-- 	"full",
-- 	"OUTER",
-- 	"outer",
-- 	"ON",
-- 	"on",
-- 	"AS",
-- 	"as",
-- 	"GROUP",
-- 	"group",
-- 	"BY",
-- 	"by",
-- 	"ORDER",
-- 	"order",
-- 	"HAVING",
-- 	"having",
-- 	"LIMIT",
-- 	"limit",
-- 	"OFFSET",
-- 	"offset",
-- 	"DISTINCT",
-- 	"distinct",
-- 	"COUNT",
-- 	"count",
-- 	"SUM",
-- 	"sum",
-- 	"AVG",
-- 	"avg",
-- 	"MIN",
-- 	"min",
-- 	"MAX",
-- 	"max",
-- 	"AND",
-- 	"and",
-- 	"OR",
-- 	"or",
-- 	"NOT",
-- 	"not",
-- 	"IN",
-- 	"in",
-- 	"LIKE",
-- 	"like",
-- 	"BETWEEN",
-- 	"between",
-- 	"IS",
-- 	"is",
-- 	"NULL",
-- 	"null",
-- 	"TRUE",
-- 	"true",
-- 	"FALSE",
-- 	"false",
-- 	"CASE",
-- 	"case",
-- 	"WHEN",
-- 	"when",
-- 	"THEN",
-- 	"then",
-- 	"ELSE",
-- 	"else",
-- 	"END",
-- 	"end",
-- 	"UNION",
-- 	"union",
-- 	"ALL",
-- 	"all",
-- 	"EXISTS",
-- 	"exists",
-- 	"WITH",
-- 	"with",
-- 	"RETURNING",
-- 	"returning",
-- 	"PRIMARY",
-- 	"primary",
-- 	"KEY",
-- 	"key",
-- 	"FOREIGN",
-- 	"foreign",
-- 	"REFERENCES",
-- 	"references",
-- 	"UNIQUE",
-- 	"unique",
-- 	"DEFAULT",
-- 	"default",
-- 	"CHECK",
-- 	"check",
-- 	"CONSTRAINT",
-- 	"constraint",
-- 	"VIEW",
-- 	"view",
-- 	"TRUNCATE",
-- 	"truncate",
-- 	"BEGIN",
-- 	"begin",
-- 	"COMMIT",
-- 	"commit",
-- 	"ROLLBACK",
-- 	"rollback",
-- 	"TRANSACTION",
-- 	"transaction",
-- }

-- ─── Helpers ─────────────────────────────────────────────────────────────────

--- Safely require a module; return nil on failure.
local function try_require(mod)
	local ok, result = pcall(require, mod)
	return ok and result or nil
end

--- Walk the dbee structure tree (returned by api.core.connection_get_structure)
--- and collect { name, type } entries for schemas, tables, and columns.
---@param nodes table
---@param results table
local function collect_structure(nodes, results)
	if not nodes then
		return
	end
	for _, node in ipairs(nodes) do
		-- node fields: name (string), type (string), children (table|nil)
		-- type is usually "table", "column", "schema", "view", etc.
		local kind = (node.type or ""):lower()
		table.insert(results, { name = node.name, kind = kind })
		if node.children then
			collect_structure(node.children, results)
		end
	end
end

--- Map a dbee node kind to a blink.cmp CompletionItemKind number.
local function kind_for(node_kind)
	local kinds = require("blink.cmp.types").CompletionItemKind
	local map = {
		table = kinds.Class,
		view = kinds.Interface,
		column = kinds.Field,
		schema = kinds.Module,
	}
	return map[node_kind] or kinds.Text
end

--- Build a detail string shown next to the item label.
local function detail_for(node_kind)
	local labels = {
		table = "[table]",
		view = "[view]",
		column = "[column]",
		schema = "[schema]",
		keyword = "[keyword]",
	}
	return labels[node_kind] or ("[" .. node_kind .. "]")
end

-- ─── Source implementation ────────────────────────────────────────────────────

---@param opts table  Options from `sources.providers.dbee.opts`
function source.new(opts)
	local self = setmetatable({}, { __index = source })
	self.opts = opts or {}
	-- Per-session cache: { conn_id -> { items, timestamp } }
	self._cache = {}
	return self
end

--- Only activate for SQL-like filetypes (configurable via opts.filetypes).
function source:enabled()
	local fts = self.opts.filetypes
	if not fts then
		return true
	end -- no filter = always on
	local ft = vim.bo.filetype
	for _, allowed in ipairs(fts) do
		if ft == allowed then
			return true
		end
	end
	return false
end

--- Trigger on common SQL punctuation so completions pop after `.` (schema.table)
--- and `(` (function arguments).
function source:get_trigger_characters()
	return { ".", "(" }
end

---@param _ctx  table  blink.cmp context (keyword, cursor position, bufnr, …)
---@param callback fun(response: table)
function source:get_completions(_ctx, callback)
	local items = {}

	-- 1. Always include SQL keywords.
	-- local kinds = require("blink.cmp.types").CompletionItemKind
	-- for _, kw in ipairs(SQL_KEYWORDS) do
	-- 	table.insert(items, {
	-- 		label = kw,
	-- 		kind = kinds.Keyword,
	-- 		detail = detail_for("keyword"),
	-- 		insertText = kw,
	-- 		insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
	-- 	})
	-- end

	-- 2. Try to fetch the schema structure from dbee.
	local api = try_require("dbee.api")
	if not api then
		-- dbee not installed / not loaded yet – return only keywords.
		callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
		return
	end

	-- Get the currently active connection.
	local ok, conn = pcall(function()
		return api.core.get_current_connection()
	end)

	if not ok or not conn then
		callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
		return
	end

	-- Cache key so we don't hammer the Go backend on every keystroke.
	local cache_ttl = self.opts.cache_ttl or 30 -- seconds
	local now = os.time()
	local cached = self._cache[conn.id]
	if cached and (now - cached.ts) < cache_ttl then
		-- Merge cached schema items with keyword items and return.
		vim.list_extend(items, cached.items)
		callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
		return
	end

	-- Fetch the schema structure from the Go backend (may be slow on first call).
	local struct_ok, structure = pcall(function()
		return api.core.connection_get_structure(conn.id)
	end)

	if struct_ok and structure then
		local schema_items = {}
		local raw = {}
		collect_structure(structure, raw)

		for _, node in ipairs(raw) do
			table.insert(schema_items, {
				label = node.name,
				kind = kind_for(node.kind),
				detail = detail_for(node.kind),
				insertText = node.name,
				insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
				-- Store metadata so resolve() can enrich docs later.
				data = { dbee_kind = node.kind, conn_id = conn.id },
			})
		end

		-- Update cache.
		self._cache[conn.id] = { items = schema_items, ts = now }
		vim.list_extend(items, schema_items)
	end

	callback({
		items = items,
		is_incomplete_forward = false,
		is_incomplete_backward = false,
	})
end

--- Enrich the item with documentation when the user pauses on it.
---@param item  table  lsp.CompletionItem
---@param callback fun(item: table)
function source:resolve(item, callback)
	item = vim.deepcopy(item)

	if item.data and item.data.dbee_kind then
		local kind = item.data.dbee_kind
		local docs = {
			table = "**Table** – select this identifier to complete the table name.",
			view = "**View** – a virtual table based on a SELECT statement.",
			column = "**Column** – a column belonging to one of the available tables.",
			schema = "**Schema** – a namespace that groups database objects.",
		}
		item.documentation = {
			kind = "markdown",
			value = docs[kind] or ("**" .. kind .. "**"),
		}
	end

	callback(item)
end

return source
