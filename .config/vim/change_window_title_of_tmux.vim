" Change window title of tmux
" ref. http://qiita.com/ssh0/items/9300a22954cf7016279d
if !($TMUX == '')
  augroup titlesettings
    autocmd!
    autocmd BufEnter * call system("tmux rename-window " . "'[Vim] " . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux rename-window " . fnamemodify($SHELL, ":t"))
    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
  augroup END
endif

