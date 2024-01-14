local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
	return
end

-- Disable netwr (the default file explorer plugin).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
	sort = {
		sorter = "name",
	},
	view = {
		width = {
			min = 60,
		},
	},
	renderer = {
		group_empty = true,
	},
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	filters = {
		dotfiles = false,
	},
	git = {
		enable = false,
	},
	diagnostics = {
		enable = false,
	},
	actions = {
		change_dir = {
			enable = false,
		},
		open_file = {
			quit_on_open = true,
			-- We want the windows to open from the buffer in which the NvimTree was called from.
			window_picker = {
				enable = false,
			},
		},
	},
})
