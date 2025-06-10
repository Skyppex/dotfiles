local cc = require("codecompanion")
local cca = require("codecompanion.adapters")
local mcphub = require("mcphub")

local adapters = {
	codellama = function()
		return cca.extend("ollama", {
			name = "codellama",
			schema = {
				model = {
					default = "codellama:7b-instruct",
				},
				num_ctx = {
					default = 16384,
				},
				num_predict = {
					default = -1,
				},
			},
		})
	end,
	codellama_code = function()
		return cca.extend("ollama", {
			name = "codellama_code",
			schema = {
				model = {
					default = "codellama:7b-code",
				},
				num_ctx = {
					default = 16384,
				},
				num_predict = {
					default = -1,
				},
			},
		})
	end,
}

local utils = require("skypex.utils")

local strategies = {}

if utils.is_work_computer() then
	local openai_api_key = skate.get("openai", "api")

	if openai_api_key then
		adapters["openai"] = function()
			return cca.extend("openai", {
				env = {
					api_key = openai_api_key,
				},
			})
		end
	end

	strategies = {
		chat = {
			adapter = {
				name = "openai",
				model = "gpt-4.1",
			},
		},
		inline = {
			adapter = {
				name = "openai",
				model = "gpt-4.1",
			},
			keymap = nil,
		},
	}
else
	strategies = {
		chat = {
			adapter = "codellama",
		},
		inline = {
			adapter = "codellama_code",
			keymap = nil,
		},
	}
end

cc.setup({
	adapters = adapters,
	strategies = strategies,
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				make_vars = true,
				make_slash_commands = true,
				show_result_in_chat = true,
			},
		},
	},
})

mcphub.setup({
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				show_result_in_chat = true,
				make_vars = true,
				make_slack_commands = true,
			},
		},
	},
})

local utils = require("skypex.utils")
local nmap = utils.nmap

nmap("<leader>ac", function()
	cc.chat()
end, "Start a new conversation with AI")

nmap("<leader>ta", function()
	cc.toggle()
end, "Toggle AI panel")

nmap("<leader>ay", function()
	cc.accept_change()
end, "Accept AI suggestion")

nmap("<leader>an", function()
	cc.reject_change()
end, "Reject AI suggestion")
