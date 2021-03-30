set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin('$HOME/.vim/bundle')

" Plugin handler
Plugin 'VundleVim/Vundle.vim'
" Better filesystem management
Plugin 'scrooloose/nerdtree'
" Solarized colorscheme
Plugin 'altercation/vim-colors-solarized'
" Easier comments
Plugin 'tpope/vim-commentary'
" Autocomplete with C/C++ semantics
Plugin 'Valloric/YouCompleteMe'
" LSP
"Plugin 'autozimu/LanguageClient-neovim'
" " Easy scratch pad
" Plugin 'mtth/scratch.vim'
" OpenGL syntax
Plugin 'tikhomirov/vim-glsl'
" Typescript
Plugin 'leafgarland/typescript-vim'
" Many colorschemes!
Plugin 'flazz/vim-colorschemes'

if filereadable("~/.vim/vundle_plugins.vim.local")
  source "~/.vim/vundle_plugins.vim.local"
endif

call vundle#end()
