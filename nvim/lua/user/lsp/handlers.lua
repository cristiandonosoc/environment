local M = {}

M.setup = function()
	-- Add fonts for the different types of diagnostics lsp will give.
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- Virtual text shows the completion as virtual text.
		virtual_text = true,
		-- show signs (set above).
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server capabilities.
	if not client.server_capabilities.documentHighlight then
		return
	end

	vim.api.nvim_exec(
		[[
		augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
	]],
		false
	)
end

local function lsp_signature(buffer)
	local ok, signature = pcall(require, "lsp_signature")
	if not ok then
		return
	end

	local MAX_HEIGHT = 8
	local MAX_WIDTH = 100

	signature.on_attach({
		bind = true,
		handler_opts = {
			border = "rounded",
		},
		hint_prefix = "🔰",
		max_width = MAX_WIDTH,
		max_height = MAX_HEIGHT,
		floating_window_above_cur_line = true,
		floating_window_off_y = function()
			-- local lineno = vim.api.nvim_win_get_cursor(0)[1]
			-- local pumheight = vim.o.pumheight
			local pumheight = MAX_HEIGHT
			local winline = vim.fn.winline()
			local winheight = vim.fn.winheight(0)

			-- We try on bottom first.
			if winheight - winline > pumheight then
				local value = pumheight + 2
				return value
				-- return pumheight+2
			end

			-- Then we try on top.
			if winline - 1 < pumheight then
				local value = -pumheight
				return value
			end

			return 0
		end,
	}, buffer)
end

local function lsp_keymaps(buffer)
	local options = { noremap = true, silent = true }

	local keymap = vim.api.nvim_buf_set_keymap

	keymap(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", options)
	keymap(buffer, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", options)
	keymap(buffer, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", options)
	keymap(buffer, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", options)
	-- keymap(buffer, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", options)
	-- keymap(buffer, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", options)
	keymap(buffer, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", options)
	-- keymap(buffer, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", options)
	-- keymap(buffer, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", options)

	keymap(buffer, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', options)
	keymap(buffer, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", options)
	keymap(buffer, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', options)
	keymap(buffer, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", options)

	keymap(buffer, "n", "<C-s>", "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", options)
	keymap(buffer, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
end

M.on_attach = function(client, buffer)
	-- Why do we need this?
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_highlight_document(client)
	lsp_signature(buffer)
	lsp_keymaps(buffer)
end

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	M.capabilities = cmp_nvim_lsp.default_capabilities()
end

return M
