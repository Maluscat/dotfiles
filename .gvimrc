if has('win32')
  " start maximized
  au GUIEnter * simalt ~x
endif

" NOTE: Copy font changes to ~|ginit.vim
if !has("nvim")
  if has("win32")
    set guifont=SauceCodePro\ NF:h11
  else
    set guifont=SauceCodePro\ Nerd\ Font\ Mono\ 13
  endif
endif

set guioptions-=e guioptions-=m guioptions-=T guioptions-=r guioptions-=L
set guioptions+=d guioptions+=! 
