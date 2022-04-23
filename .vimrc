if has('win32')
  set runtimepath^=$HOME/.vim runtimepath+=$HOME/.vim/after
  set packpath^=$HOME/.vim packpath+=$HOME/.vim/after

  set runtimepath-=$HOME/vimfiles runtimepath-=$HOME/vimfiles/after
  set packpath-=$HOME/vimfiles packpath-=$HOME/vimfiles/after
endif

if !has('nvim')
  " Import default vim
  source $VIMRUNTIME/defaults.vim
endif

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

" Line height
set linespace=2

set foldmethod=syntax
set foldlevelstart=99

set termguicolors

set wrap linebreak

if has('win32')
  if !has('nvim')
    set pythonthreehome=~/scoop/apps/python/current
  endif
endif

set encoding=UTF-8

set splitright
set splitbelow

set noswapfile
set undofile
set backup
" set directory^=$VIMHOME/tmp/.swp//
set backupdir=~/.vim/tmp/.backup//

if has('nvim')
  set undodir=~/.vim/tmp/.undo.nvim//
else
  set undodir=~/.vim/tmp/.undo//
endif

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

nnoremap <C-p> <C-f>
nnoremap '' ``
nnoremap `` ''

nnoremap <leader><CR> a<CR><ESC>
nnoremap <leader><kEnter> a<CR><ESC>
nnoremap <leader>o o<ESC>O

nnoremap <leader>g :Grepper<CR>
nnoremap <leader>G :Git<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>c :e ~/.vimrc<CR>
nnoremap <leader>C :SC<CR>
nnoremap <leader>S :Startify<CR>

if has('nvim')
  nnoremap <leader>p :vsplit<CR> :terminal pwsh<CR><C-w>Li
  tnoremap <ESC> <C-\><C-n>
else
  nnoremap <leader>p :terminal pwsh<CR><C-w>L
  tnoremap <C-w>q <C-\><C-n>:bd!<CR>
end

" Toggle search highlight and clear highlight
nnoremap <leader>N :set hlsearch!<CR>
nnoremap <leader>n :nohlsearch<CR>

" NERDTree
nnoremap <leader>m :NERDTreeMirror<CR>
nnoremap <C-f> :NERDTreeToggle<CR>

" YouCompleteMe
nnoremap <leader>l :YcmCompleter GoTo<CR>
nnoremap <leader>L :YcmCompleter GoToReferences<CR>
nnoremap <leader>R :YcmCompleter RefactorRename 
nnoremap <leader>O :YcmCompleter OrganizeImports<CR>
nnoremap <leader>F :YcmCompleter Format<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>
nnoremap <leader>D :YcmCompleter GetDoc<CR>
" <Plug> Keymaps have to me 'map's (non-recursive)
nmap <leader>i <Plug>(YCMFindSymbolInWorkspace)

nnoremap <C-s> :w<CR>

nnoremap <leader>z :tabnew<CR>
nnoremap <C-Right> :tabnext<CR> 
nnoremap <C-Left> :tabprev<CR>

" Custom text object to select a whole function
onoremap <silent>af :normal va}V<CR>
vnoremap <silent>af :normal va}V<CR>

command -nargs=? Count :%s/<args>//gn

" Memorizing and switching to last active tab
autocmd TabLeave * let g:lasttab = tabpagenr()
nnoremap <leader>t :exe "tabn ".g:lasttab<CR>

nnoremap <leader>T :tabfirst<CR>


" --- Plug ---

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-grepper'

Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'

Plug 'itchyny/lightline.vim'

" syntax highlighting & language support
Plug 'sheerun/vim-polyglot'
Plug 'groenewege/vim-less'
Plug 'lepture/vim-jinja'

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

" NERDTree
let g:NERDTreeMapCustomOpen = '<kEnter>'

" Startify
let g:startify_bookmarks = [
\	{'c': '~/.vimrc'},
\	{'g': '~/.gvimrc'},
\	{'n': '~/init.vim'},
\	{'i': '~/ginit.vim'},
\	{'r': '/dev/node/RobBot_yarn/main.js'}
\ ]

let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let g:startify_session_dir = '~/.vim/session'

" Signify
set updatetime=100

" Lightline
set noshowmode
let g:lightline = {
      \   'colorscheme': 'moonfly',
      \   'active': {
      \     'left': [
      \       [ 'mode', 'paste' ],
      \       [ 'readonly', 'filename', 'gitbranch', 'modified' ]
      \     ]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   }
      \ }

" Grepper
let g:grepper = {
      \   'tools': [ 'rg', 'git' ]
      \ }

let g:UltiSnipsExpandTrigger = "<C-s>"
let g:UltiSnipsJumpForwardTrigger = "<S-Right>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Left>"

" list all snippets for current filetype
let g:UltiSnipsListSnippets = "<C-l>"

let g:UltiSnipsUsePythonVersion = 3

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_seed_identifiers_with_syntax = 1
" let g:ycm_language_server = [
"       \   {
"       \     'name': 'deno',
"       \     'cmdline': [ 'deno', 'lsp' ],
"       \     'filetypes': [ 'typescript' ],
"       \     'project_root_files': [ 'main.ts' ]
"       \   }
"       \ ]

let g:NERDTreeHijackNetrw = 1
let g:NERDTreeShowHidden = 1

let g:AutoPairsMultilineClose = 0

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

