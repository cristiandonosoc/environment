" YouCompleteMe -------------------------------------------------------------------------------

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

function! PythonOpenSwarmFile(filename, line)
python3 << EOF
import os
import subprocess

# Find the monorepo.
def FindMonorepoDir(filename):
	last = filename
	d = filename
	while True:
		# Go over searching the parent. If we found the same directory twice in a row, it means that
		# we are at the file system root.
		d = os.path.dirname(d)
		if d == last:
			raise("MONOREPO FILE NOT FOUND")
		last = d

		# Search directory for Build.cs file.
		for f in os.listdir(d):
			basename = os.path.basename(f)
			if "MONOREPO" in basename:
				return d

def OpenSwarmFile(filename, line):
	root = FindMonorepoDir(filename)
	rel = os.path.relpath(filename, root)


	url = "https://swarm.havenstudios.com/files/hvn/{}#{}".format(rel, line)
	os.system("start "+url)

OpenSwarmFile(vim.eval("a:filename"), vim.eval("a:line"))
EOF
endfunction

nnoremap <leader>u :call PythonOpenSwarmFile(expand("%:p"), line('.'))<cr>

" C++
"-------------------------------------------------------------------------------

function! PythonHeaderSourceChange(filepath, open_cmd)
python3 << EOF
import os
import vim

h_extensions = ["h", "hpp"]
c_extensions = ["cc", "cpp", "c"]


def ChangeExtension(filepath):
	filename, fileext = os.path.splitext(filepath)
	extension = fileext[1:]

	new_extensions = []
	if extension in h_extensions:
		new_extensions = c_extensions
	elif extension in c_extensions:
		new_extensions = h_extensions

	# Search for a match.
	for ext in new_extensions:
		path = os.path.abspath("{}.{}".format(filename, ext))
		if os.path.exists(path):
			return path, True

	return "", False

def SearchForUnrealModuleHeader(filepath):
	# See if this is a module.
	if (not "Public" in filepath) and (not "Private" in filepath):
		return "", False

	last = filepath
	d = filepath
	while True:
		# Go over searching the parent. If we found the same directory twice in a row, it means that
		# we are at the file system root.
		d = os.path.dirname(d)
		if d == last:
			return "", False
		last = d

		base = os.path.basename(d)
		if base == "Public":
			other = "Private"
		elif base == "Private":
			other = "Public"
		else:
			continue

		# Find the path where the other headern should be.
		rel = os.path.relpath(filepath, d)
		target = os.path.join(os.path.dirname(d), other, rel)

		# Try to find the other header.
		other, ok = ChangeExtension(target)
		if not ok:
			continue
		return other, True

def DoHeaderChange(open_cmd, filepath):
	# First try to see if we found an Unreal header.
	newpath, ok = SearchForUnrealModuleHeader(filepath)
	if ok:
		vim.command("{} {}".format(open_cmd, newpath))
		return

	newpath, ok = ChangeExtension(filepath)
	if ok:
		vim.command("{} {}".format(open_cmd, newpath))
		return

	# If we didn't find a header, simply change to the other new extension.
	# This is normally we wanting to open a new .cc from a new header file.
	filename, fileext = os.path.splitext(filepath)
	extension = fileext[1:]

	new_extensions = []
	if extension in h_extensions:
		new_extensions = c_extensions
	elif extension in c_extensions:
		new_extensions = h_extensions

	new_path = os.path.abspath("{}.{}".format(filename, new_extensions[0]))
	vim.command("{} {}".format(open_cmd, new_path))

DoHeaderChange(vim.eval("a:open_cmd"), vim.eval("a:filepath"))
EOF
endfunction

nnoremap <leader>hsc :call PythonHeaderSourceChange(expand("%:p"), "e")<cr>
nnoremap <leader>hss :call PythonHeaderSourceChange(expand("%:p"), "sp")<cr>
nnoremap <leader>hsv :call PythonHeaderSourceChange(expand("%:p"), "vs")<cr>
nnoremap <leader>hst :call PythonHeaderSourceChange(expand("%:p"), "tabnew")<cr>

function! OpenDirectory(open_cmd)
python3 << EOF
import os
import vim
vim.command("{} {}".format(vim.eval("a:open_cmd"), os.path.dirname(vim.eval('expand("%:p")'))))
EOF
endfunction

nnoremap <leader>odc :call OpenDirectory("e")<cr>
nnoremap <leader>ods :call OpenDirectory("sp")<cr>
nnoremap <leader>odv :call OpenDirectory("vs")<cr>

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

function! OpenTerminal()
  exec ":sp | terminal"
endfunction

nnoremap <leader>t :call OpenTerminal()<cr><C-W><S-J>

" Workaround on wqa
command Z w | qa
cabbrev wqa Z


" ERRORS
"-------------------------------------------------------------------------------

nnoremap <leader>p :cprev<cr>
nnoremap <leader>P :cfirst<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>N :clast<cr>
nnoremap <leader>o :copen<cr>
nnoremap <leader>c :cclose<cr>

" format
"-------------------------------------------------------------------------------

function! PythonDoFormat(filepath)
python3 << EOF
import os

filepath = vim.eval("a:filepath")
filename, ext = os.path.splitext(filepath)
if ext == ".go":
	vim.command("!gofmt.exe -w %")
elif ext == ".tf":
	vim.command("!terraform.exe fmt %")
elif ext in [".h", ".hpp", ".hxx", ".cc", ".cpp", ".cxx"]:
	vim.command("!clang-format.exe -Werror -i --style=file %")
elif ext in [".rs"]:
	vim.command("!rustfmt.exe %")
EOF
endfunction

nnoremap <silent><TAB> :call PythonDoFormat(expand("%:p"))<cr>

augroup filetypedetect
		autocmd BufNew,BufNewFile,BufRead *.cpp,*.h :set ff=dos
    autocmd BufNew,BufNewFile,BufRead *.txt,*.text,*.md,*.markdown :setfiletype markdown
    autocmd BufNew,BufNewFile,BufRead *.Jenkinsfile :setfiletype groovy
    autocmd BufNew,BufNewFile,BufRead *.go,*.tf,*.rs :set ff=unix
augroup END


