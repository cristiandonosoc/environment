-- Load the configs.
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

-- SERVERS WITH SPECIFIC CONFIGS

local auto_install_servers = {
	"lua_ls",
	"gopls",
	"rust_analyzer",
}

local servers = {
	"lua_ls",
	"gopls",
	"clangd",
	"rust_analyzer",
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
	ensure_installed = auto_install_servers,
	automatic_installation = false,
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
		if not string.match(result, "module 'user.lsp.settings.*' not found") then
			vim.notify("could not load config for " .. path .. ": " .. result)
		end
	end

	-- Finally send this config to the config exposed by lsp config.
	lspconfig[server_name].setup(options)
end

-- Finally set up the handlers module.
-- This has to ocurur after the mason configs it seems.

lsp_handlers.setup()
