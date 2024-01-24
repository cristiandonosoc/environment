local ok, formatter = pcall(require, "formatter")
if not ok then
	return
end

formatter.setup({
	logging = true,
	log_level = vim.log.levels.DEBUG,
	filetype = {
		-- Install via Mason.
		bzl = {
			function()
				return {
					exe = "buildifier",
				}
			end,
		},
		-- Installed via installing Go.
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		-- Install stylua manually.
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		cpp = {
			require("formatter.filetypes.cpp").clangformat
		},
	},
})
