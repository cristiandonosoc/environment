-- "," is my leader.
vim.g.mapleader = ","

local options = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- NORMAL ------------------------------------------------------------------------------------------

-- Disable the god awful Ex mode.
keymap("n", "Q", "<Nop>", options)

-- Map <Space> to search. This one is controversial, but I love it.
keymap("n", "<space>", "/", options)

-- Disable highlight when <leader><space> is pressed.
keymap("n", "<leader><space>", ":nohlsearch<cr>", options)

-- Smart way to move between windows CTRL-W j abbreviation.
keymap("n", "<C-j>", "<C-W>j", options)
keymap("n", "<C-k>", "<C-W>k", options)
keymap("n", "<C-h>", "<C-W>h", options)
keymap("n", "<C-l>", "<C-W>l", options)

-- Using these will expand the tab vertically and horizontally. I like a lot.
keymap("n", "<C-Up>", ":resize +5<cr>", options)
keymap("n", "<C-Down>", ":resize -5<cr>", options)
keymap("n", "<C-Left>", ":vertical resize +5<cr>", options)
keymap("n", "<C-Right>", ":vertical resize -5<cr>", options)

-- Treat long lines as break lines (useful when moving around in them).
-- This means that if a line is wrapped, you jump to the wrapped text as if it was another line,
-- instead of jumping over. Very intuitive.
keymap("n", "j", "gj", options)
keymap("n", "k", "gk", options)

-- Navigate buffers.
keymap("n", "<S-h>", ":bprevious<cr>", options)
keymap("n", "<S-l>", ":bnext<cr>", options)

-- B and E move to beggining/end of line respectively. Never use this to be honest.
keymap("n", "B", "^", options)
keymap("n", "E", "$", options)

-- Move line around
keymap("n", "<A-j>", ":m .+1<cr>==", options)
keymap("n", "<A-k>", ":m .-2<cr>==", options)

-- Make saving more hardcode (https://www.reddit.com/r/neovim/comments/owl1wg/job_still_running/)
vim.cmd("command Z w | qa")
vim.cmd("cabbrev wqa Z")

-- We want to close the window
vim.cmd("cabbrev q close")

-- SAVING ------------------------------------------------------------------------------------------

-- VISUAL ------------------------------------------------------------------------------------------

-- Stay in indent mode when indenting.
keymap("v", "<", "<gv", options)
keymap("v", ">", ">gv", options)

-- Move lines around.
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", options)
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", options)

-- Keep the pasting thing in the register.
keymap("v", "p", [["_dP]], options)

-- VISUAL BLOCK ------------------------------------------------------------------------------------

-- Move lines around.
keymap("x", "<A-j>", ":m '>+1<cr>gv=gv", options)
keymap("x", "<A-k>", ":m '<-2<cr>gv=gv", options)

-- EXTRAS ------------------------------------------------------------------------------------------

-- Copy to clipboard.
keymap("n", "<leader>y", [["y]], options)
keymap("n", "<leader>Y", [["yg_]], options)
keymap("v", "<leader>y", [["+y]], options)

-- Paste from clipboard.
keymap("n", "<leader>P", [["+p]], options)
keymap("v", "<leader>P", [["+p]], options)

-- ERRORS ------------------------------------------------------------------------------------------

-- Move between diagnostic errors.
keymap("n", "<leader>N", "<cmd>lua vim.diagnostic.goto_prev()<cr>", options)
keymap("n", "<leader>n", "<cmd>lua vim.diagnostic.goto_next()<cr>", options)

-- TERMINAL SETUP ----------------------------------------------------------------------------------

keymap("n", "<C-t>", "<cmd>ToggleTerm direction=horizontal<cr>", options)
-- Terminal mode escape. This permits escape to go out of writing in the terminal.
keymap("t", "<Esc>", "<C-\\><C-n>", options)

-- TELESCOPE ---------------------------------------------------------------------------------------

keymap("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", options)
keymap("n", "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<cr>", options)
keymap("n", "<leader>r", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", options)

-- LSP ---------------------------------------------------------------------------------------------

keymap("n", "gdd", "<cmd>lua vim.lsp.buf.definition()<cr>", options)
keymap("n", "<A-f>", "<cmd>lua vim.lsp.buf.definition()<cr>", options)
keymap("n", "<A-F>", "<cmd>vs | lua vim.lsp.buf.definition()<cr>", options)
keymap("n", "gdv", "<cmd>vs | lua vim.lsp.buf.definition()<cr>", options)

local function quick_fix()
	vim.lsp.buf.code_action({
		filter = function(a)
			if a.isPreferred ~= nil then
				return a.isPreferred
			end

			if a.kind ~= "quickfix" then
				return true
			end

			return false
		end,
		apply = true,
	})
end
vim.keymap.set("n", "<leader>qf", quick_fix, options)
vim.keymap.set("n", "<leader>qa", "<cmd>lua vim.lsp.buf.code_action()<cr>", options)

-- FORMAT ------------------------------------------------------------------------------------------

keymap("n", "<tab>", ":FormatWriteLock<cr>", options)

-- NVIMTREE ----------------------------------------------------------------------------------------

keymap("n", "<leader>e", ":NvimTreeToggle<cr>", options)
