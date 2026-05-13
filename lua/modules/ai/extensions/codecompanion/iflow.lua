local helpers = require("codecompanion.adapters.acp.helpers")

---@class CodeCompanion.ACPAdapter.iFlow: CodeCompanion.ACPAdapter
---@diagnostic disable-next-line: missing-fields
return {
  -- Adapter identification
  name = "iflow",
  formatted_name = "iFlow",
  type = "acp",

  -- Role definitions for the conversation
  roles = {
    llm = "assistant",
    user = "user",
  },

  -- Adapter options
  opts = {
    vision = true,
    trim_tool_output = true,
  },

  -- Command configurations for different modes
  commands = {
    default = {
      "iflow",
      "--experimental-acp",
    },
    yolo = {
      "gemini",
      "--yolo",
      "--experimental-acp",
    },
  },

  -- Default configuration values
  defaults = {
    auth_method = "oauth-personal", -- iflow-api-key | oauth-personal
    mcpServers = {},
    timeout = 20000, -- 20 seconds
  },

  -- Environment variables required for authentication
  env = {
    api_key = "IFLOW_API_KEY",
    oauth_token = "IFLOW_OAUTH_TOKEN",
  },

  -- Protocol parameters for ACP communication
  parameters = {
    protocolVersion = 1,
    clientCapabilities = {
      fs = { readTextFile = true, writeTextFile = true },
    },
    clientInfo = {
      name = "CodeCompanion.nvim",
      version = "1.0.0",
    },
  },

  -- Event handlers for the adapter lifecycle
  handlers = {
    ---Initialize the adapter
    ---@param self CodeCompanion.ACPAdapter
    ---@return boolean
    setup = function(self)
      return true
    end,

    ---Handle authentication based on auth_method
    ---@param self CodeCompanion.ACPAdapter
    ---@return boolean
    auth = function(self)
      local auth_method = self.defaults.auth_method

      if auth_method == "oauth-personal" then
        -- OAuth personal authentication
        vim.notify("use 'oauth-personal' auth in iflow", vim.log.levels.INFO)
        local oauth_token = self.env_replaced.oauth_token
        if oauth_token and oauth_token ~= "" then
          vim.env.IFLOW_OAUTH_TOKEN = oauth_token
          return true
        end
      elseif auth_method == "iflow-api-key" then
        -- API key authentication
        vim.notify("use 'iflow-api-key' auth in iflow", vim.log.levels.INFO)
        local api_key = self.env_replaced.api_key
        if api_key and api_key ~= "" then
          vim.env.IFLOW_API_KEY = api_key
          return true
        end
      end

      return false
    end,

    ---Format messages for the ACP protocol
    ---@param self CodeCompanion.ACPAdapter
    ---@param messages table
    ---@param capabilities table
    ---@return table
    form_messages = function(self, messages, capabilities)
      return helpers.form_messages(self, messages, capabilities)
    end,

    ---Function to run when the request has completed. Useful to catch errors
    ---@param self CodeCompanion.ACPAdapter
    ---@param code number
    ---@return nil
    on_exit = function(self, code) end,
  },
}
