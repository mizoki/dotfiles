" 初期化処理中のみ（再読み込み時に実行しない）
if has("vim_starting")
  " ウインドウを最大化
  set columns=9999
  set lines=999

  " colorschemeの設定
  if !dein#check_install(['vim-tomorrow-theme']) && dein#is_sourced('vim-tomorrow-theme')
    colorscheme Tomorrow-Night-Eighties
  else
    colorscheme desert
  endif

  " フォント設定
  if has('gui_macvim')
    set guifont=Ricty:h14
  endif
endif

" ツールバーを削除
set guioptions-=T

" メニューを削除
set guioptions-=m

" スクロールバーを削除
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=b
set guioptions-=h

