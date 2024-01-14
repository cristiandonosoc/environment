local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

configs.setup({
	ensure_installed = {
		-- These should always be in (according to doc).
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		-- Insert your languages here.
		"go",
	},
	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = false,
	},
})
