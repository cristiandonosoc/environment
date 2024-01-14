-- This is a file with vim configuration.
-- This roughly equates to a vimrc config.

-- :help options

-- MOST IMPORTANT SETTING OF THEM ALL
-- Return to last edit position when opening files (You want this!)
vim.cmd([[
au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
        \ execute("normal `\"") |
    \ endif
]])

vim.opt.compatible = false

-- Command line abbreviations for the most annoying errors in existence.
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev WA wa")
vim.cmd("cnoreabbrev Wqa wqa")
vim.cmd("cnoreabbrev WQa wqa")
vim.cmd("cnoreabbrev WQA wqa")
vim.cmd("cnoreabbrev E e")
vim.cmd("cnoreabbrev Tabnew tabnew")
vim.cmd("cnoreabbrev Vs vs")
vim.cmd("cnoreabbrev VS vs")
vim.cmd("cnoreabbrev Sp sp")
vim.cmd("cnoreabbrev SP sp")

vim.opt.exrc = true
vim.opt.secure = true

-- FILES -------------------------------------------------------------------------------------------

-- Plugins && indentation per filetype
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- Auto reload a file when outside modification has been detected.
vim.opt.autoread = true

-- Triger `autoread` when files changes on disk.
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
vim.cmd([[
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
	\ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
]])

-- Notification after file change.
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.cmd([[
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

-- UI ----------------------------------------------------------------------------------------------

vim.opt.termguicolors = true -- Support more colors.

-- 7 lines from the top/bottom of the buffer will begin scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- No numbers in the left.
vim.opt.number = false

-- Show both horizontal and vertical cursor lines
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "101" -- Highlight where the characters would end.

--Show current line, character and file % in status bar
vim.opt.ruler = true

-- Turn on the wild menu (that shows in bottom line all the available commands).
-- This also changes how the tab autocomplete works by cycling through the available options.
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
-- Ignore compiled files on wildmenu and repository thingys
vim.cmd("set wildignore+=*.o,*~,*.a,*.pyc")
vim.cmd("set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store")

-- Height of the command bar.
vim.opt.cmdheight = 1

-- Margin to the left of line numbers used to indicate folding.
vim.opt.foldcolumn = "1"

-- Always show the status line.
vim.opt.laststatus = 2

vim.opt.syntax = "enable"

-- BEHAVIOUR ---------------------------------------------------------------------------------------

-- Allow the mouse to be used in neovim.
vim.opt.mouse = "a"

-- Configure backspace so it acts as it should act
-- 	start: delete before the start of insert (so annoying if off)
-- 	eol: deletes from the start of a line to end of the previous
-- 	indent: deletes over autoindent (yet to see what exactly this is)
vim.opt.backspace = { "start", "eol", "indent" }

-- Ignore casing when searching. Smartcase ignore only if no specific case is present in the search query.
vim.opt.smartcase = true
vim.opt.hlsearch = true -- Highlight the search results.
vim.opt.incsearch = true -- Incremental matches as search goes on (*very* annoying if off).
vim.opt.magic = true -- Magic Special characters as * don't get escaped.

-- Don't redraw while executing macros (if off, sometimes runtime goes to hell)
vim.opt.lazyredraw = true

-- Show matching brackets when cursor is over it (very important!)
vim.opt.showmatch = true
vim.opt.mat = 1 -- mat is how many tenths of a second to blink on those matches.

-- No annoying bells
vim.cmd([[
set noerrorbells novisualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
]])

-- Specify the behavior when switching between buffers.
vim.cmd([[
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry
]])

-- Remember info about open buffers on close.
vim.cmd("set viminfo^=%")

-- TEXT & INDENTING --------------------------------------------------------------------------------

-- Allow
vim.opt.smarttab = true

vim.opt.tabstop = 4 -- Amount of spaces in a tabSpaces in a tab.
vim.opt.softtabstop = 4 -- Tab Extension When Editing.
vim.opt.expandtab = false -- Tabs are NOT spaces.
vim.opt.shiftwidth = 4 -- Amount of spaces a shift indent moves.
vim.opt.autoindent = true -- Try to copy the indent of the previous line
vim.opt.smartindent = true -- Indent better with scopes

-- Wrap lines after the buffer width is reached
vim.opt.wrap = true

-- Better unprintable characters
vim.cmd([[
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
  let &listchars="tab:\u25b8 ,trail:\u2423,nbsp:\u26ad,eol:\u00ac,extends:\u21c9,precedes:\u21c7"
  let &fillchars="fold:\u00b7"
  let &showbreak="\u00bb "
endif
]])

-- MODES & TABS ------------------------------------------------------------------------------------

-- Max tabs to open from command line at once.
vim.opt.tabpagemax = 10

vim.opt.showmode = true -- Always show the mode.
vim.opt.showcmd = true -- Show command while it is being written.
vim.opt.display = "lastline" -- If wrap set, display last line.
vim.opt.virtualedit = "block" -- Move freely in visual block.
vim.opt.linebreak = true -- Wrap at spaces characters.
vim.opt.joinspaces = false -- One space after sentences.

vim.opt.splitbelow = true -- All horizontal splits to go below current window.
vim.opt.splitright = true -- All vertical splits to go to the right of current window.

-- MISC --------------------------------------------------------------------------------------------

vim.opt.fileencoding = "utf-8" -- the encoding written to a file

-- Delete trailing white space on save, useful for Python and CoffeeScript ;)
vim.cmd([[
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()
]])

vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp

-- BACKUPS -----------------------------------------------------------------------------------------

-- Turn backup off. But turn on writebackup, which means if a write fails, we can go back
-- (editor crash).
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.swapfile = true
vim.opt.undofile = true

-- Set the directory for swap, backup and undo. Neovim will create them automatically.
vim.cmd([[
	let &directory = expand("~/.nvim/cache/swap")
	let &backupdir = expand("~/.nvim/cache/backup")
	let &undodir = expand("~/.nvim/cache/undo")
]])

-- TERMINAL ----------------------------------------------------------------------------------------

vim.cmd([[
function! s:TermForceCloseAll() abort
    let term_bufs = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&buftype") == "terminal"')
    for t in term_bufs
            execute "bd! " t
    endfor
endfunction
autocmd QuitPre * call <sid>TermForceCloseAll()
]])
