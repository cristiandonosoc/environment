vim.cmd("source ~/.vimrc")

require("lspconfig")["rust_analyzer"].setup({})

local ih = require("inlay-hints")

-- Activate the rust tools (for doing things like RustSetInlayHints).
require("rust-tools").setup({
  tools = {
    on_initialized = function()
      ih.set_all()
    end,
    inlay_hints = {
      auto = false,
    },
  },
})
