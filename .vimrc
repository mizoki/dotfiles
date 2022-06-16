set encoding=utf-8
scriptencoding utf-8

" ------------------------------------------------------------------------------
" {{{ Settings

" 全てのモードでマウスを有効にする
set mouse=a

" 行番号を表示
set number

" バックアップファイルを作成しない
set nobackup

" do not create a swap file
set noswapfile

" Enable undofile
set undofile
" Undoファイルの保存場所を変更
set undodir=~/.vim/undo

" ヘルプ検索の優先順位
set helplang=ja,en

" スペルチェックの言語
set spelllang=en,cjk

" インクリメント・デクリメントの設定
set nrformats=hex,alpha,bin

" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

" Tabをスペースに変換する
set expandtab
" タブの幅を2文字に設定する
set tabstop=2
set shiftwidth=2

" 120桁目にラインを入れる
set colorcolumn=120

" タブと改行を可視化
set list
set listchars=tab:»-,trail:␣,eol:⏎,extends:»,precedes:«,nbsp:%

"日本語の行の連結時には空白を入力しない。
set formatoptions+=mM

" Enable modeline
set modeline

" }}}
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" {{{ Key mappings

" Set mapleader
let g:mapleader = ","

" Toggle Line Number
nnoremap <Leader>m :<C-u>setlocal relativenumber!<CR>

" 設定ファイル再読込
nnoremap <silent><Leader>ss :source ~/.vimrc<CR>
" 設定ファイル編集
nnoremap <silent><Leader>ee :e ~/.vimrc<CR>

" Switch to command mode with semi colon key (For US keyboard)
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" 分割ウインドウ操作関係のプレフィックス
nnoremap [Window] <Nop>
nmap s [Window]

" ウインドウの分割
nnoremap [Window]s :split<CR>
nnoremap [Window]v :vsplit<CR>

" 分割ウインドウを閉じる
nnoremap [Window]q <C-W>q

" 分割ウインドウ間の移動

" Ref.
" https://github.com/kaosf/dotfiles/commit/50f38c9951b8f84aa11ef1a541b22df8900b7f00
" Switch tabs by same key mappings for moving windows
function! s:movewinleft()
  let before = winnr()
  wincmd h
  if before == winnr()
    tabprevious
  endif
endfunction
function! s:movewinright()
  let before = winnr()
  wincmd l
  if before == winnr()
    tabnext
  endif
endfunction

nnoremap [Window]j <C-W>j
nnoremap [Window]k <C-W>k
nnoremap [Window]l :call <SID>movewinright()<CR>
nnoremap [Window]h :call <SID>movewinleft()<CR>

" 分割ウインドウ自体の移動
nnoremap [Window]J <C-W>J
nnoremap [Window]K <C-W>K
nnoremap [Window]L <C-W>L
nnoremap [Window]H <C-W>H

" 分割ウインドウの大きさを調整
nnoremap [Window], <C-W><
nnoremap [Window]. <C-W>>
nnoremap [Window]= <C-W>+
nnoremap [Window]- <C-W>-
nnoremap [Window]+ <C-W>=

" }}}
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" Other configs {{{
" Ref. https://zenn.dev/comamoca/articles/58aa4c48f56e95

let splt = split(glob("~/.config/vim/" . "*.vim"))

for file in splt
  " 読み込んだファイルを表示する
  " echo "load " . file

  " ファイルの読み込み
  execute 'source' file
endfor

" }}}
" ------------------------------------------------------------------------------

" vim: foldmethod=marker
