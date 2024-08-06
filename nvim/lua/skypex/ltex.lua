local S = {}

-- define the files for each language
-- new words will be added to the last file in the language table
S.dictionaries = {
	["en-US"] = { vim.fn.stdpath("config") .. "/spell/en.txt" },
}

S.disables = {
	["en-US"] = { vim.fn.stdpath("config") .. "/spell/en-disable.txt" },
}

S.falsePositives = {
	["en-US"] = { vim.fn.stdpath("config") .. "/spell/en-false.txt" },
}

-- function to avoid interacting with the table directly
function S.getDictFiles(lang)
	local files = S.dictionaries[lang]
	if files then
		return files
	else
		return nil
	end
end

function S.getDisableFiles(lang)
	local files = S.disables[lang]
	if files then
		return files
	else
		return nil
	end
end

function S.getFalseFiles(lang)
	local files = S.falsePositives[lang]
	if files then
		return files
	else
		return nil
	end
end

-- combine words from all the files. Each line should contain one word
function S.readDictFiles(lang)
	local files = S.getDictFiles(lang)
	local dict = {}
	if files then
		for _, file in ipairs(files) do
			local f = io.open(file, "r")
			if f then
				for l in f:lines() do
					table.insert(dict, l)
				end
			else
				print("Can not read dict file %q", file)
			end
		end
	else
		print("Lang %q has no files", lang)
	end
	return dict
end

-- combine rules from all the files. Each line should contain one rule
function S.readDisableFiles(lang)
	local files = S.getDisableFiles(lang)
	local dict = {}
	if files then
		for _, file in ipairs(files) do
			local f = io.open(file, "r")
			if f then
				for l in f:lines() do
					table.insert(dict, l)
				end
			else
				print("Can not read dict file %q", file)
			end
		end
	else
		print("Lang %q has no files", lang)
	end
	return dict
end

-- combine rules from all the files. Each line should contain one rule
function S.readFalseFiles(lang)
	local files = S.getFalseFiles(lang)
	local dict = {}
	if files then
		for _, file in ipairs(files) do
			local f = io.open(file, "r")
			if f then
				for l in f:lines() do
					table.insert(dict, l)
				end
			else
				print("Can not read dict file %q", file)
			end
		end
	else
		print("Lang %q has no files", lang)
	end
	return dict
end

-- Append words to the last element of the language files
function S.addWordsToFiles(lang, words)
	local files = S.getDictFiles(lang)
	if not files then
		return print("no dictionary file defined for lang %q", lang)
	else
		local file = io.open(files[#files - 0], "a+")
		if file then
			for _, word in ipairs(words) do
				file:write(word .. "\n")
			end
			file:close()
		else
			return print("Failed insert %q", vim.inspect(words))
		end
	end
end

-- Append words to the last element of the language files
function S.disableRules(lang, rules)
	local files = S.getDisableFiles(lang)
	if not files then
		return print("no dictionary file defined for lang %q", lang)
	else
		local file = io.open(files[#files - 0], "a+")
		if file then
			for _, rule in ipairs(rules) do
				file:write(rule .. "\n")
			end
			file:close()
		else
			return print("Failed insert %q", vim.inspect(rules))
		end
	end
end

-- Append words to the last element of the language files
function S.addFalsePositives(lang, rules)
	local files = S.getFalseFiles(lang)
	if not files then
		return print("no dictionary file defined for lang %q", lang)
	else
		local file = io.open(files[#files - 0], "a+")
		if file then
			for _, rule in ipairs(rules) do
				file:write(rule .. "\n")
			end
			file:close()
		else
			return print("Failed insert %q", vim.inspect(rules))
		end
	end
end

-- The following part is a classic lspconfig config section
local lspconfig = require("lspconfig")
-- notifying wkspc will refresh the settings that contain the dictionary
local wkspc = "workspace/didChangeConfiguration"
-- instead of looping through the list of clients and check client.name == 'ltex' (which many solutions out there are doing)
-- We attach the command function to the bufer then ltex is loaded
local function on_attach(client, _)
	-- the second argument is named 'ctx', but we don't need it here
	--- command = {argument={...}, command=..., title=...}
	local addToDict = function(command, _)
		for _, arg in ipairs(command.arguments) do
			-- not the most efficent way, we could readDictFiles once per lang
			for lang, words in pairs(arg.words) do
				S.addWordsToFiles(lang, words)
				client.config.settings.ltex.dictionary = {
					[lang] = S.readDictFiles(lang),
				}
			end
		end
		-- notify the client of the new settings
		return client.notify(wkspc, client.config.settings)
	end

	local addToDisable = function(command, _)
		for _, arg in ipairs(command.arguments) do
			-- not the most efficent way, we could readDictFiles once per lang
			for lang, rules in pairs(arg.ruleIds) do
				S.disableRules(lang, rules)
				client.config.settings.ltex.disabledRules = {
					[lang] = S.readDisableFiles(lang),
				}
			end
		end
		-- notify the client of the new settings
		return client.notify(wkspc, client.config.settings)
	end

	local addToFalse = function(command, _)
		for _, arg in ipairs(command.arguments) do
			-- not the most efficent way, we could readDictFiles once per lang
			for lang, rules in pairs(arg.falsePositives) do
				S.addFalsePositives(lang, rules)
				client.config.settings.ltex.hiddenFalsePositives = {
					[lang] = S.readFalseFiles(lang),
				}
			end
		end
		-- notify the client of the new settings
		return client.notify(wkspc, client.config.settings)
	end

	-- add the function to handle the command
	-- then lsp.commands does not find the handler, it will look at opts.handler["workspace/executeCommand"]
	vim.lsp.commands["_ltex.addToDictionary"] = addToDict
	vim.lsp.commands["_ltex.disableRules"] = addToDisable
	vim.lsp.commands["_ltex.hideFalsePositives"] = addToFalse
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local dictionary = {}
local disabledRules = {}
local hiddenFalsePositives = {}

local patterns = {
	["en-US"] = {
		{ pattern = "[A-Z][a-z]+([A-Z][a-z]+)+", replacement = "PascalCase" },
		{ pattern = "_?[a-z]+([A-Z][a-z]+)+", replacement = "camelCase" },
		{ pattern = "[_a-z]+", replacement = "snake_case" },
		{ pattern = "[_A-Z]+", replacement = "SNAKE_CASE" },
	},
}

for lang, _ in pairs(S.dictionaries) do
	dictionary[lang] = S.readDictFiles(lang)
end

for lang, _ in pairs(S.disables) do
	disabledRules[lang] = S.readDisableFiles(lang)
end

for lang, _ in pairs(S.falsePositives) do
	hiddenFalsePositives[lang] = S.readFalseFiles(lang)
end

for lang, patternList in pairs(patterns) do
	for _, pattern in ipairs(patternList) do
		table.insert(hiddenFalsePositives[lang], pattern.replacement)
	end
end

lspconfig.ltex.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "*" },
	settings = {
		ltex = {
			diagnosticSeverity = "hint",
			dictionary = dictionary,
			disabledRules = disabledRules,
			hiddenFalsePositives = hiddenFalsePositives,
			patterns = patterns,
		},
	},
})
