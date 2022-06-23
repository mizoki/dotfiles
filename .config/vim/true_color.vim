" TrueColor対応
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " 文字色
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " 背景色
  set termguicolors
endif
