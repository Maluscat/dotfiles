vim9script

if has('win32')
  set runtimepath^=$HOME/.vim runtimepath+=$HOME/.vim/after
  set packpath^=$HOME/.vim packpath+=$HOME/.vim/after

  set runtimepath-=$HOME/vimfiles runtimepath-=$HOME/vimfiles/after
  set packpath-=$HOME/vimfiles packpath-=$HOME/vimfiles/after
endif

if !has('nvim')
  # Import default vim
  source $VIMRUNTIME/defaults.vim
endif

# This overrides windows-exclusive behaviours, like special mouse and selection behaviour
behave xterm

filetype plugin indent on

# cd C:/dev

g:mapleader = " "

# Screen padding around the cursor
set scrolloff=3

set autoindent
set shiftwidth=2
set tabstop=2
set expandtab

# Line height
set linespace=2

set foldmethod=syntax
set foldlevelstart=99
g:javaScript_fold = 1
g:php_folding = 1
g:markdown_folding = 1
g:sh_fold_enabled = 1
g:rust_fold = 1

set re=0
set lazyredraw

set termguicolors

set wrap linebreak

if has('win32')
  if !has('nvim')
    set pythonthreehome=~/scoop/apps/python/current
  endif
endif

set encoding=UTF-8

set updatetime=100

set splitright
set splitbelow

# Background buffers
set hidden

set noswapfile
set undofile
set backup
# set directory^=$VIMHOME/tmp/.swp//
set backupdir=~/.vim/tmp/.backup//

if has('nvim')
  set undodir=~/.vim/tmp/.undo.nvim//
else
  set undodir=~/.vim/tmp/.undo//
endif

# Session handling
set sessionoptions-=options
# FastFold compatibility
# set sessionoptions-=folds

# Disable automatic comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=o
autocmd FileType *.vim setlocal formatoptions+=c

# From https://stackoverflow.com/a/5357194
# Create a new motion `cp` for replacing a word with the paste buffer
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
def g:ChangePaste(type: string)
  silent exe "normal! `[v`]\"_c"
  silent exe "normal! p"
enddef

# --- Syntax ---

# Matching parens/braces style
highlight MatchParen gui=bold cterm=bold ctermbg=none ctermfg=magenta

# This makes the "sign column" (e.g. for the git gutter) the normal background
# color
highlight clear SignColumn

augroup extraTodoHighlight
  autocmd!
  autocmd Syntax * call SetExtraTodos()
augroup END

def SetExtraTodos()
  # NOTE: I have no idea what this does
  syn match myTodo /NOTE/ containedin=ALL
  hi link myTodo Todo
enddef


# --- line numbers ---

set number relativenumber

# Toggles relative line numbers when window loses/gets focus
# Copied from https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


# --- Remaps & Shortcuts ---

# Go up/down one full screen, swapped to match existing <C-u> und <C-d> maps
nnoremap <C-b> <C-f>
nnoremap <C-ö> <C-b>

nnoremap <C-w>Q :bd<CR>
nnoremap Y y$

nnoremap <C-p> <C-f>
nnoremap '' ``
nnoremap `` ''
nnoremap '. `.
nnoremap `. '.

noremap gs :s///g<Left><Left><Left>

nnoremap <leader><CR> a<CR><ESC>
nnoremap <leader><kEnter> a<CR><ESC>
nnoremap <leader>o o<ESC>O

nnoremap <leader>h :echo expand('%:p')<CR>

nnoremap <leader>g :Grepper<CR>
nnoremap <leader>G :Git<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>c :e ~/.vimrc<CR>
nnoremap <leader>C :SC<CR>
nnoremap <leader>S :Startify<CR>

# Toggle search highlight and clear highlight
nnoremap <leader>N :set hlsearch!<CR>
nnoremap <leader>n :nohlsearch<CR>

# NERDTree
nnoremap <leader>m :NERDTreeMirror<CR>
nnoremap <leader>M :NERDTreeFind<CR>
nnoremap <leader>s :NERDTreeFocus<CR>
nnoremap <C-f> :NERDTreeToggle<CR>

# Tagbar
nnoremap <C-g> :TagbarToggle<CR>

# YouCompleteMe
nnoremap <leader>l :YcmCompleter GoTo<CR>
nnoremap <leader>L :YcmCompleter GoToReferences<CR>
nnoremap <leader>R :YcmCompleter RefactorRename 
nnoremap <leader>O :YcmCompleter OrganizeImports<CR>
nnoremap <leader>F :YcmCompleter Format<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>
nnoremap <leader>D :YcmDiags<CR>
# <Plug> Keymaps have to me 'map's (non-recursive)
nmap <leader>i <Plug>(YCMFindSymbolInWorkspace)

nnoremap <C-s> :w<CR>

nnoremap <leader>z :tabnew<CR>
nnoremap <C-Right> :tabnext<CR> 
nnoremap <C-Left> :tabprev<CR>

# Custom text object to select a whole function
onoremap <silent>af :normal va}V<CR>
vnoremap <silent>af :normal va}V<CR>

command -nargs=? Count :%s/<args>//gn

# Memorizing and switching to last active tab
g:lasttab = 1
autocmd TabLeave * g:lasttab = tabpagenr()
nnoremap <leader>t :exe 'tabn ' .. g:lasttab<CR>

nnoremap <leader>T :tabfirst<CR>

# Linux: Make window fullscreen or maximized. Maximized is default on GUIEnter
if !has('win32')
  autocmd GUIEnter * call g:MaximizeWindow()
endif

def g:MaximizeWindow()
  silent call system('wmctrl -ir ' .. v:windowid .. ' -b remove,fullscreen')
  silent call system('wmctrl -ir ' .. v:windowid .. ' -b add,maximized_vert,maximized_horz')
enddef

def g:FullscreenWindow()
  silent call system('wmctrl -ir ' .. v:windowid .. ' -b add,fullscreen')
enddef


# Terminal
autocmd User StartifyBufferOpened call RemoveDeadTerminalBuffers()

if has('nvim')
  # I can't bother with nvim right now
  if has('win32')
    nnoremap <leader>p :terminal pwsh<CR><C-w>Li
  else
    nnoremap <leader>p :terminal<CR><C-w>Li
  endif
else
  nnoremap <leader>p :call <SID>SwitchToFirstTerminalAndBackOrOpen()<CR>
  nnoremap <leader>P :call <SID>OpenNewTerminal()<CR>
endif
tnoremap <ESC> <C-\><C-n>


var termType = has('win32') ? 'pwsh' : &l:shell

def RemoveDeadTerminalBuffers()
  # The dead buffers are always UNLOADED but LISTED
  # But I haven't found a way to get all UNLOADED buffers (it simply ignores bufloaded: 0)
  var bufList = getbufinfo({ 'buflisted': 1 })
  for listedBuffer in bufList
    if listedBuffer.name =~ termType && !BufNrIsTerminal(listedBuffer.bufnr)
      execute 'bdelete ' .. listedBuffer.bufnr
    endif
  endfor
enddef    

def SwitchToFirstTerminalAndBackOrOpen()
  if BufNrIsTerminal(bufnr())
    # From https://vi.stackexchange.com/a/18365
    # NOTE: This could have consequences
    #   (not checking for the window, but for the buffer)
    execute 'buffer ' .. bufnr('#')
  else 
    var openTerminals = term_list()
    if len(openTerminals) == 0
      OpenNewTerminal()
    else
      execute 'buffer ' .. openTerminals[0]
    endif
  endif
enddef

def OpenNewTerminal()
  term_start(termType, {
    curwin: 1,
    term_kill: 'term'
  })
enddef


def BufNrIsTerminal(bufnr: number): bool
  return getbufvar(bufnr, '&buftype') == 'terminal'
enddef


# --- Plug ---

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-grepper'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'

Plug 'itchyny/lightline.vim'

Plug 'konfekt/FastFold'

Plug 'preservim/tagbar'

Plug 'ap/vim-css-color'

# NERDTree
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

# syntax highlighting & language support
Plug 'sheerun/vim-polyglot'
Plug 'groenewege/vim-less'
Plug 'lepture/vim-jinja'

# snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

# autocomplete
Plug 'ycm-core/YouCompleteMe'

# Plug 'neoclide/coc.nvim', {'branch': 'release'}

# Themes
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'

call plug#end()


# --- Plugins Configuration ---

# FastFold
## This activates FastFold regardles of the number of lines
g:fastfold_minlines = 0

# NERDTree
if has('win32') && has('nvim')
  g:NERDTreeMapCustomOpen = '<kEnter>'
else
  g:NERDTreeMapCustomOpen = '<CR>'
endif

# Tagbar
g:tagbar_autofocus = 1
g:tagbar_sort = 0

# Startify
g:startify_bookmarks = [
  { c: '~/.vimrc' },
  { g: '~/.gvimrc' },
  { n: '~/nvim-init.vim' },
  { i: '~/nvim-ginit.vim' }
]

g:startify_session_persistence = 1
g:startify_session_sort = 1
g:startify_session_dir = '~/.vim/session'

# Lightline
set noshowmode
g:lightline = {
  colorscheme: 'moonfly',
  active: {
    left: [
      [ 'mode', 'paste' ],
      [ 'readonly', 'filename', 'gitbranch', 'modified' ]
    ]
  },
  component_function: {
    gitbranch: 'FugitiveHead'
  }
}

# Grepper
# NOTE: Needs to be initialized this way, see `:h grepper-options`
g:grepper = {
  tools: [ 'rg', 'git' ]
}

# Ultisnipts
g:UltiSnipsExpandTrigger = "<C-s>"
g:UltiSnipsJumpForwardTrigger = "<S-Right>"
g:UltiSnipsJumpBackwardTrigger = "<S-Left>"

# list all snippets for current filetype
g:UltiSnipsListSnippets = "<C-l>"

g:UltiSnipsUsePythonVersion = 3

# YouCompleteMe
g:ycm_autoclose_preview_window_after_completion = 1
g:ycm_autoclose_preview_window_after_insertion = 1
g:ycm_seed_identifiers_with_syntax = 1
g:ycm_tsserver_binary_path = 'tsserver'
g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
g:ycm_language_server = [
#   {
#     'name': 'deno',
#     'cmdline': [ 'deno', 'lsp' ],
#     'filetypes': [ 'javascript', 'typescript' ],
#     'project_root_files': [ 'deno.json' ]
#   },
    {
      name: 'json',
      cmdline: [ 'vscode-json-languageserver', '--stdio' ],
      filetypes: [ 'json', 'jsonc' ],
      capabilities: { textDocument: { completion: { completionItem: { snippetSupport: v:true } } } },
    },
    {
      name: 'R',
      cmdline: [ 'R', '--slave', '-e', 'languageserver::run()' ],
      filetypes: [ 'r', 'rmd' ]
    }
]

# NERDTree
g:NERDTreeHijackNetrw = 1
g:NERDTreeShowHidden = 1

g:AutoPairsMultilineClose = 0

colorscheme moonfly


# --- From https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim ---

# Ignore special files
set wildignore=*.o,*~,*.pyc,.git\*,.hg\*,.svn\*

# RegEx
set magic

set noerrorbells
set belloff=all
set novisualbell
set t_vb=

set mat=2

# Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

# Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

# Delete trailing white space on save, useful for some filetypes ;)
def CleanExtraSpaces()
  var save_cursor = getpos(".")
  var old_query = getreg('/')
  silent! :%s/\s\+$//e
  setpos('.', save_cursor)
  setreg('/', old_query)
enddef

if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

# --- Compile every `def` function ---
defcompile
