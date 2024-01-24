-- Load the configs.
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

-- SERVERS WITH SPECIFIC CONFIGS
-- IMPORTANT: If there is an entry here, there should be an lsp/settings/<server>.lua file.
local servers = {
	"lua_ls",
	"gopls",
	"clangd",
}

local lsp_handlers = require("user.lsp.handlers")

require("mason").setup({
	ui = {
		border = "none",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local options = {}

for _, server in pairs(servers) do
	options = {
		on_attach = lsp_handlers.on_attach,
		capabilities = lsp_handlers.capabilities,
	}

	-- Try to see if there are configs for this.
	-- If so, we extend the options with the server specific options.
	local server_name = vim.split(server, "@")[1]
	local path = "user.lsp.settings." .. server_name
	local ok, result = pcall(require, path)
	if ok then
		options = vim.tbl_deep_extend("force", result, options)
	else
		if not string.match(result, "module '.*' not found") then
			vim.notify("could not load config for " .. path .. ": " .. result)
		end
	end

	-- Finally send this config to the config exposed by lsp config.
	lspconfig[server_name].setup(options)
end

-- Finally set up the handlers module.
-- This has to ocurur after the mason configs it seems.

lsp_handlers.setup()
