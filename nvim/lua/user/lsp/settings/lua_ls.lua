return {
	settings = {
		Lua = {
			-- Add the global vim object to the diagnostics, so that the LSP can recognize it.
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- Add some common paths for the LSP to search Lua sources.
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
