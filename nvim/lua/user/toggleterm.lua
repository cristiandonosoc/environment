local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	return
end

toggleterm.setup({
	size = 20,
	start_in_insert = false,
})
