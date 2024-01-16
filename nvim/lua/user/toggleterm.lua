local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	return
end

toggleterm.setup({
	size = 30,
	start_in_insert = false,
})
