local function getEnable()
	local enable = false
	local fromENV = os.getenv("LLM_ENABLE")
	if fromENV == "true" then
		enable = true
	end

	return enable
end

local function getModel()
	local model = "codellama:7b-code"
	local fromENV = os.getenv("LLM_MODEL")
	if fromENV ~= nil then
		model = fromENV
	end

	return model
end

local function getURL()
	-- code
	local url = "http://10.10.17.27:11434/api/generate"
	local fromENV = os.getenv("LLM_URL")
	if fromENV ~= nil then
		url = fromENV
	end
	return url
end

return {
	"huggingface/llm.nvim",
	cond = getEnable(),
	opts = {
		-- cf Setup
		api_token = nil, -- cf Install paragraph
		backend = "ollama",
		--model = "codellama:latest",
		model = getModel(),
		url = getURL(),
		tokens_to_clear = { "<EOT>" },
		request_body = {
			parameters = {
				max_new_tokens = 60,
				temperature = 0.2,
				top_p = 0.95,
			},
		},
		-- set this if the model supports fill in the middle

		fim = {
			enabled = true,
			prefix = "<PRE> ",
			middle = " <MID>",
			suffix = " <SUF>",
		},

		debounce_ms = 150,
		accept_keymap = "<C-f>",
		dismiss_keymap = "<S-Tab>",
		tls_skip_verify_insecure = false,
		-- llm-ls configuration, cf llm-ls section
		lsp = {
			bin_path = nil,
			host = nil,
			port = nil,
			version = "0.5.2",
		},
		tokenizer = nil, -- cf Tokenizer paragraph
		context_window = 8192, -- max number of tokens for the context window
		enable_suggestions_on_startup = true,
		enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
	},
}
