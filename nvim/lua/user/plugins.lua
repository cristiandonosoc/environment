local fn = vim.fn

-- Automatically install packer.
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer. Close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file.
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

-- Try to load the packer module.
local ok, packer = pcall(require, "packer")
if not ok then
	vim.notify("Could not load packer module")
	return
end

-- Display packer updates in a popup window.
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- PLUGINS LIST ------------------------------------------------------------------------------------

return packer.startup(function(use)
	-- Have packer manage itself.
	use("wbthomason/packer.nvim")

	use("nvim-lua/plenary.nvim") -- Set of common lua functions.
	use("nvim-lua/popup.nvim") -- Implementation of the popup vim api.

	use("folke/tokyonight.nvim") -- Cool ass colorscheme.

	use("tpope/vim-commentary") -- Easier commenting/uncommenting.

	use("djoshea/vim-autoread") -- Automatically reload externally modified files.

	use("webdevel/tabulous") -- A bit Better tabs.

	-- cmp (completion).
	use("hrsh7th/nvim-cmp") -- The completion engine plugin.
	use("hrsh7th/cmp-buffer") -- In-buffer completions.
	use("hrsh7th/cmp-path") -- Path (filepath) completions.
	use("hrsh7th/cmp-cmdline") -- cmdline completions.
	use("saadparwaiz1/cmp_luasnip") -- Snippets completions.
	use("hrsh7th/cmp-nvim-lsp") -- LSP integration.
	use("hrsh7th/cmp-nvim-lua") -- Nvim specific lua LSP.

	-- Snippets.
	use("L3MON4D3/LuaSnip") -- Snippet engine.
	use("rafamadriz/friendly-snippets") -- A bunch of snippets to use.

	-- LSP.
	use("neovim/nvim-lspconfig") -- Expose LSP configurations.
	use("williamboman/mason.nvim") -- Simple to use language server installer.
	use("williamboman/mason-lspconfig.nvim") -- Bridge some gaps between mason and lsp.
	-- use 'jose-elias-alvarez/null-ls.nvim'	-- LSP diagnostics and code actions.

	-- Telescope.
	use("nvim-telescope/telescope.nvim")

	-- Formatter.
	use("mhartington/formatter.nvim")

	-- NvimTree (file explorer plugin).
	use("nvim-tree/nvim-web-devicons")
	use("nvim-tree/nvim-tree.lua")

	-- Windline (nicer status line for files).
	use("windwp/windline.nvim")

	-- LSP Signature hints.
	use("ray-x/lsp_signature.nvim")

	-- Toggleterm
	use("akinsho/toggleterm.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("nvim-treesitter/nvim-treesitter-context")

	-- Spell-checking.
	use("f3fora/cmp-spell")

	-- Automatically set up your config after cloning packer.nvim.
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
