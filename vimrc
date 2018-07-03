" GENERIC STARTUP & UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MOST IMPORTANT SETTING OF THEM ALL
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Load local .vimrc found in $PWD
" Secure means that loaded .vimrc through exrc cannot run autocommands
set exrc
set secure

" Do not make VIM compatible with Vi (not sure what this does actually...)
set nocompatible

" Command line abbreviations for the most error in existence
cnoreabbrev W w
cnoreabbrev Wa wa
cnoreabbrev WA wa
cnoreabbrev Wqa wqa
cnoreabbrev WQa wqa
cnoreabbrev WQA wqa

" Plugins && indentation per filetype
filetype on
filetype plugin on
filetype indent on

" Automatically reload a file when outside detection has been detected
set autoread

" , is my leader
let g:mapleader = ","

" Setup mouse
try
  set mouse=a
catch
endtry

" 7 lines from the top/bottom of the buffer will begin scrolling
set scrolloff=7

" Show line numbers
set number

" Show both horizontal and vertical cursor lines
set cursorline
set cursorcolumn

" Show current line, character and file % in status bar
set ruler

" Turn on the wild menu (that shows in bottom line all the available
" commands). This also changes how the tab autocomplete works by cycling
" through the available options.
set wildmenu
set wildmode=list:longest,full
" Ignore compiled files on wildmenu and repository thingys
set wildignore+=*.o,*~,*.a,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Height of the command bar
set cmdheight=1

" Configure backspace so it acts as it should act
" start: delete before the start of insert (so annoying if off)
" eol: deletes from the start of a line to end of the previous
" indent: deletes over autoindent (yet to see what exactly this is)
set backspace=start,eol,indent

" Ignore casing when searching. Smartcase ignore only if no specific case is
" present in the search query
" Highlight the search results
" Incremental matches as search goes on (*very* annoying if off)
" Magic Special characters as * don't get escaped
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

" Don't redraw while executing macros (if off, sometimes runtime goes to hell)
set lazyredraw

" Show matching brackets when cursor is over it (very important!)
" mat is how many tenths of a second to blink on those matches
set showmatch
set mat=2

" No annoying bells
set noerrorbells novisualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Margin to the left of line numbers used to indicate folding
set foldcolumn=1

" COLORS AND FONTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax highlighting
syntax enable

" Set extra options when running in GUI mode
if has("gui_running")
    set guifont=Consolas:h10
    set guioptions-=T           " Include window toolbar
    set guioptions-=e           " Add tab pages
    set t_Co=256                " Number of colors in the terminal
    set guitablabel=%M\ %t      " Tab Name formatting
else
  try
    set term=xterm-256color     " Typical color setting
  catch
  endtry
endif

" Use Unix as the standard file type
set fileformats=unix,dos,mac
set fileformat=unix

" Always show the status line
set laststatus=2

" BACKUPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off. Most of stuff is in git anyway. But turn on writebackup,
" which means if a write fails, we can go back (editor crash)
set nobackup
set writebackup

" Swap files for undo, cache and backups
" These files are left in external directories. Otherwise they polute the
" current one and is very annoying.

set swapfile
let swapfolder = 0
if isdirectory(expand('~/.vim/cache'))
  let swapfolder = '~/.vim/cache'
endif
" Windows
if isdirectory(expand('~/vimfiles/cache'))
  let swapfolder = '~/vimfiles/cache'
endif

" Where to put swap, backup and undo files
if isdirectory(expand(swapfolder))
  let &directory=expand(swapfolder.'/swap')
  let &backupdir=expand(swapfolder.'/backup')
  if exists('+undodir')
    let &undodir=expand(swapfolder.'/undo')
  endif
endif
if exists('+undofile')
  set undofile
endif

" TEXT & INDENTING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Be smart about tabs... and use spaces obviously
set expandtab
set smarttab

set tabstop=2       " Amount of spaces in a tabSpaces in a tab
set softtabstop=2   " Tab Extension When Editing
set expandtab       " Tabs are spaces
set tabstop=2       " Amount of spaces in a tabSpaces in a tab
set shiftwidth=2    " The >> and << space value. Auto-indent works this way

set autoindent      " Try to copy the indent of the previous line
set smartindent     " Indent better with scopes

" Wrap lines after the buffer width is reached
set wrap

" Better unprintable characters
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
  let &listchars="tab:\u25b8 ,trail:\u2423,nbsp:\u26ad,eol:\u00ac,extends:\u21c9,precedes:\u21c7"
  let &fillchars="fold:\u00b7"
  let &showbreak="\u00bb "
endif

" MODES & TABS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Max tabs to open from command line at once
set tabpagemax=10

set showmode        " Always show the mode
set showcmd         " Show command while it is being written


set display+=lastline       " If wrap set, display last line
set virtualedit=block       " Move freely in visual block
set linebreak               " Wrap at spaces characters
set nojoinspaces            " One space after sentences

set splitright              " We always split to the right :)

" MOVING AROUND
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk

" B and E move to beggining/end of line respectively
nnoremap B ^
nnoremap E $

" Map <Space> to search
map <space> /

" Disable highlight when <leader><space> is pressed
map <silent> <leader><space> :nohlsearch<cr>

" Smart way to move between windows CTRL-W j abbreviation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>          " Open a new tab
map <leader>to :tabonly<cr>         " Close all other tabs
map <leader>tc :tabclose<cr>        " Close current tab
map <leader>tm :tabmove             " Ask for how many tabs move current tab

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" TODO(cristiandonosoc): Edit this ones to split
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Opens the vim page for the current buffer's path
map <leader>td :tabedit <c-r>=expand("%:p:h")<cr>/<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" Remember info about open buffers on close
set viminfo^=%

" USEFUL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

" ERRORS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Open the error window
map <leader>cc :botright copen<cr>
map <leader>p :cp<cr>       " Previous error
map <leader>n :cn<cr>       " Next error

" SPELL CHECKING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set spelllang=es,en                         " Spelling languages
set spellsuggest=10                         " Number of spelling suggestions
"set spellfile=~/.vim/spell/mine.utf-8.add   " Spell file for additions

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s           " Next spell error
map <leader>sp [s           " Previous spell error
map <leader>sa zg           " Add word to dictionary
map <leader>s? z=           " Proposals for words (not very friendly, but works)

" VISUAL MODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

vnoremap <silent> <leader>j :call VisualSelection('f', '')<CR>
vnoremap <silent> <leader>k :call VisualSelection('b', '')<CR>

" SOURCE LOCAL CHANGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vimrc.local
