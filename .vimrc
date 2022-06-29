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

" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" コマンドをステータス行に表示
set showcmd

" ステータス行の設定
set statusline=[%02n]%f%m\ %y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}
set statusline+=%r%h%w%=
set statusline+=%{fugitive#statusline()}
set statusline+=[\%04b]\[\0x%04B]\ \ %02l,%02c\ \ %4P

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

"画面最後の行をできる限り表示する。
set display+=lastline

" バッファの内容が変更されていても、バッファの切り替えができるようにする
set hidden

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

" Enable modeline
set modeline

" Use highlight search
set hlsearch

" :h :filetype-overview
filetype plugin indent on

" Always show the sign column
set signcolumn=yes

" }}}
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" {{{ command

command! -bar -nargs=1 OpenTempBuffer new | setlocal buftype=nofile bufhidden=hide filetype=<args> noswapfile

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

" Markdown用の作業バッファの作成
nnoremap <silent><Leader>s :OpenTempBuffer markdown<CR>

" Esc×2で検索結果のハイライトを解除する
nnoremap <Esc><Esc> :nohlsearch<CR>

" ref.
" http://qiita.com/inodev/items/4f4d5412e65c2564b273
"検索語が画面の真ん中に来るようにする
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" }}}
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" plugin settings {{{
" Ref. https://knowledge.sakura.ad.jp/23248/
" Ref. https://sy-base.com/myrobotics/vim/dein/

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = expand('~/.config/vim/plugins')
  if !isdirectory(s:toml_dir)
    call mkdir(s:toml_dir, 'p')
  endif

  execute 'set path+=' . s:toml_dir
  call dein#load_toml(s:toml_dir . '/' . 'common.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/' . 'color_scheme.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/' . 'ddc.toml', {'lazy': 1})
  call dein#load_toml(s:toml_dir . '/' . 'ddu.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/' . 'development.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/' . 'lsp.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/' . 'dev_ruby.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

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

" Write about device-dependent settings and secure settings
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" }}}
" ------------------------------------------------------------------------------

" vim: foldmethod=marker
