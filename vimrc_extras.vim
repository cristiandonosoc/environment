" YouCompleteMe
"-------------------------------------------------------------------------------

let g:ycm_confirm_extra_conf=0
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" Ycm wrappers
"-------------------------------------------------------------------------------

" Runs a YCM function to some binding. Enables to do GoTo into vertical and
" horizontal splits.
function! YcmGoToWrapper(ycm_command, split_kind)
  if a:split_kind == "tabnew"
    " Tabnew is implemented with promoting the buffer
    exec "normal sp"
    exec "YcmCompleter " . a:ycm_command
    exec "normal \<C-W>T"
  elseif a:split_kind != ""
    exec a:split_kind
    exec "YcmCompleter" . " " . a:ycm_command
  else
    " No splitting required
    exec "YcmCompleter" . " " . a:ycm_command
  endif
endfunction

" GoToDeclaration
nnoremap <leader>dec :call YcmGoToWrapper("GoToDeclaration", "")<cr>
nnoremap <leader>des :call YcmGoToWrapper("GoToDeclaration", "sp")<cr>
nnoremap <leader>dev :call YcmGoToWrapper("GoToDeclaration", "vs")<cr>
nnoremap <leader>det :call YcmGoToWrapper("GoToDeclaration", "tabnew")<cr>

" GoToDefinition
nnoremap <leader>dfc :call YcmGoToWrapper("GoToDefinition", "")<cr>
nnoremap <leader>dfs :call YcmGoToWrapper("GoToDefinition", "sp")<cr>
nnoremap <leader>dfv :call YcmGoToWrapper("GoToDefinition", "vs")<cr>
nnoremap <leader>dft :call YcmGoToWrapper("GoToDefinition", "tabnew")<cr>

" GoToInclude
nnoremap <leader>gic :call YcmGoToWrapper("GoToInclude", "")<cr>
nnoremap <leader>gis :call YcmGoToWrapper("GoToInclude", "sp")<cr>
nnoremap <leader>giv :call YcmGoToWrapper("GoToInclude", "vs")<cr>
nnoremap <leader>git :call YcmGoToWrapper("GoToInclude", "tabnew")<cr>

" C++
"-------------------------------------------------------------------------------

" Swap between .h/.cc
" Can be improved to support .cpp, .hpp, .c ... etc.
function! HeaderSourceChange(open_cmd)
  let a:path = expand("%:r")
  let a:extension = expand("%:e")

  " We change h/cc
  let a:new_extension = ""
  if a:extension == "h"
    let a:new_extension = "cc"
  elseif a:extension == "cc"
    let a:new_extension = "h"
  endif

  if a:new_extension == ""
    return
  endif

  let a:new_filename = a:path . "." . a:new_extension

  " We open the file
  exec a:open_cmd . ' ' . a:new_filename
endfunction

nnoremap <leader>hsc :call HeaderSourceChange("e")<cr>
nnoremap <leader>hss :call HeaderSourceChange("sp")<cr>
nnoremap <leader>hsv :call HeaderSourceChange("vs")<cr>
nnoremap <leader>hst :call HeaderSourceChange("tabnew")<cr>

" Fuzzy search your project. Useful, but I never remember to use it, so I
" never do.
function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    if a:vim_command == ":tabnew"
      exec "sp " . output
      exec "normal \<C-W>T"
    else
      exec a:vim_command . ' ' . output
    endif
  endif
endfunction

nnoremap <leader>ffe :call FzyCommand("find -type f", ":e")<cr>
nnoremap <leader>ffv :call FzyCommand("find -type f", ":vs")<cr>
nnoremap <leader>ffs :call FzyCommand("find -type f", ":sp")<cr>
nnoremap <leader>fft :call FzyCommand("find -type f", ":tabnew")<cr>

" ERRORS
"-------------------------------------------------------------------------------

nnoremap <leader>p :cprev<cr>
nnoremap <leader>P :cfirst<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>N :clast<cr>
nnoremap <leader>o :copen<cr>
nnoremap <leader>c :cclose<cr>

" clang-format
"-------------------------------------------------------------------------------

map <C-I> :pyf ~/.vim/clang-format.py<cr>
