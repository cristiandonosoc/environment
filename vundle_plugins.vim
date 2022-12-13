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

" " Easy scratch pad
" Plugin 'mtth/scratch.vim'

" OpenGL syntax
Plugin 'tikhomirov/vim-glsl'

" Many colorschemes!
Plugin 'flazz/vim-colorschemes'

" Automatically reload externally modified files.
Plugin 'djoshea/vim-autoread'

" Automatic tab/space management.
" Plugin 'tpope/vim-sleuth'

" Better info line.
Plugin 'bling/vim-airline'

" A bit Better tabs
Plugin 'webdevel/tabulous'

" Terraform support
Plugin 'hashivim/vim-terraform'

" Better C++ highlighting.
Plugin 'bfrg/vim-cpp-modern'

source ~/.vim/vundle_plugins.vim.local

call vundle#end()
