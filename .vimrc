if has('win32')
  set runtimepath^=$HOME/.vim
endif

let $VIMHOME = '~/.vim'

" Import default vim
source $VIMRUNTIME/defaults.vim

" This overrides windows-exclusive behaviours, like special mouse and selection behaviour
behave xterm

filetype plugin indent on

" cd C:/dev

let mapleader = " "

" Screen padding around the cursor
set scrolloff=3

set autoindent
set shiftwidth=2
set tabstop=2
set expandtab

set foldmethod=syntax
set foldlevelstart=99

set termguicolors

set wrap linebreak

if has('win32')
  set shell=pwsh

  if !has('nvim')
    set pythonthreehome=C:/Program\ Files/Python/Python39
  endif
endif

set encoding=UTF-8

set splitright

set noswapfile
set undofile
set backup
" set directory^=$VIMHOME/tmp/.swp//
set backupdir^=$VIMHOME/tmp/.backup//
set undodir^=$VIMHOME/tmp/.undo//

" Session handling
set sessionoptions-=options

" Disable automatic comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=o
autocmd FileType *.vim setlocal formatoptions+=c

" Matching parens/braces style
highlight MatchParen gui=bold cterm=bold ctermbg=none ctermfg=magenta

" This makes the "sign column" (e.g. for the git gutter) the normal background
" color
highlight clear SignColumn

" function LessToCSS(path = expand("%:p"), line = getline(1))
"   let options = {}
"   for option in split(a:line[2:], ',')
"     let splitOption = split(option, ':')
"     let options[trim(splitOption[0])] = trim(splitOption[1])
"   endfor

"   " If the options contain a 'main' flag, relay to the given file
"   if has_key(options, 'main')
"     for mainFile in split(options.main, '|')
"       let mainPath = fnamemodify(a:path, ':h') . '/' . mainFile
"       call LessToCSS(mainPath, readfile(mainPath)[:1][0])
"     endfor
"   elseif has_key(options, 'out')
"     " we will ignore compress...
"     silent execute
"         \ '!lessc '
"         \ . (get(options, 'sourcemap') == 'true' ? '--source-map ' : '')
"         \ . a:path . ' '
"         \ . fnamemodify(a:path, ':h') . '/' . options.out
"   endif
" endfunction

function! LessToCSS()
python3 << EOF

import vim
import pathlib
import subprocess

def less_to_CSS(path):
    firstline = read_first_line(path)[2:]

    options = {}
    for option in firstline.split(','):
        if option == '\n':
            continue
        split_option = option.split(':')
        options[split_option[0].strip()] = split_option[1].strip()

    if 'main' in options:
        for main_file in options['main'].split('|'):
            main_file_path = path.parent / main_file
            less_to_CSS(main_file_path)
    elif 'out' in options:
        subprocess.run([
            'lessc',
            ('--source-map' if options['sourcemap'] == 'true' else ''),
            str(path),
            str(path.parent / options['out'])
        ], shell=True)


def read_first_line(file_name):
    with open(file_name) as file:
        return file.readline()

less_to_CSS(pathlib.Path(vim.eval('expand("%:p")')))

EOF
endfunction


" --- line numbers ---

set number relativenumber

" Toggles relative line numbers when window loses/gets focus
" Copied from https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" --- Remaps & Shortcuts ---

nnoremap <leader><CR> i<CR><ESC>

nnoremap <leader>o o<ESC>O

nnoremap <C-s> :w<CR>

nnoremap <C-z> :tabnew<CR>
nnoremap <C-Right> :tabnext<CR> 
nnoremap <C-Left> :tabprev<CR>

command -nargs=? Count :%s/<args>//gn


" --- Plug ---

call plug#begin('~/.vim/plugged')

" Plug 'dense-analysis/ale'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'

Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'

Plug 'itchyny/lightline.vim'

" syntax highlighting & language support
Plug 'sheerun/vim-polyglot'

Plug 'groenewege/vim-less'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" autocomplete
Plug 'ycm-core/YouCompleteMe'

" Themes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'

call plug#end()


" --- Plugins Configuration ---

nnoremap <C-f> :NERDTreeToggle<CR>

" Startify
let g:startify_bookmarks = [
\	{'c': '~/.vimrc'},
\	{'g': '~/.gvimrc'}
\ ]

let g:startify_session_persistence = 1
let g:startify_session_sort = 1

" Signify
set updatetime=100

" highlight GitGutterAdd    guifg=#009900 ctermfg=2
" highlight GitGutterChange guifg=#bbbb00 ctermfg=15
" highlight GitGutterDelete guifg=#ff2222 ctermfg=28

" Lightline
set noshowmode
let g:lightline = { 'colorscheme': 'nightfly' }

let g:UltiSnipsExpandTrigger = "<C-s>"
let g:UltiSnipsJumpForwardTrigger = "<S-Right>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Left>"

" list all snippets for current filetype
let g:UltiSnipsListSnippets = "<C-l>"

let g:UltiSnipsUsePythonVersion = 3

let NERDTreeHijackNetrw = 1
" Hack to prevent devicons from being cut off
set ambiwidth=double

" Colorschemes
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

colorscheme moonfly


" --- From https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim ---

" Ignore special files
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*

" RegEx
set magic

set noerrorbells
set belloff=all
set novisualbell
set t_vb=

set mat=2

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	silent! %s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfun

if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

