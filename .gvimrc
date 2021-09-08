" start maximized
au GUIEnter * simalt ~x

if has("win32")
  set guifont=SauceCodePro\ NF:h11
else
  set guifont=SauceCodePro\ NF\ 11
endif

set guioptions-=e guioptions-=m guioptions-=T guioptions-=r guioptions-=L
set guioptions+=d guioptions+=! 
