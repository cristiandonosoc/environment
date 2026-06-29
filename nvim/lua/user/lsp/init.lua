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

require("mason-lspconfig").setup({
	ensure_installed = auto_install_servers,
	automatic_installation = false,
})

-- Set on_attach and capabilities as defaults for all servers.
vim.lsp.config("*", {
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
})

for _, server in pairs(servers) do
	local server_name = vim.split(server, "@")[1]
	local path = "user.lsp.settings." .. server_name
	local ok, result = pcall(require, path)
	if ok then
		vim.lsp.config(server_name, result)
	else
		if not string.match(result, "module 'user.lsp.settings.*' not found") then
			vim.notify("could not load config for " .. path .. ": " .. result)
		end
	end
end

vim.lsp.enable(servers)

lsp_handlers.setup()
