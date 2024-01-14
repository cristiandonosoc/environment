local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
if not configs_ok then
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

local context_ok, context = pcall(require, "treesitter-context")
if not context_ok then
	return
end

context.setup({
	enable = true,
	-- If we want to disable for certain buffers, you can run this function.
	-- Likely we might want that for some very large buffers.
	on_attach = nil,
})
