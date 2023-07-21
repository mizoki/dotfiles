set encoding=utf-8
scriptencoding utf-8

" vimrc グループのautocmdを初期化
augroup vimrc
  autocmd!
augroup END

" ------------------------------------------------------------------------------
" {{{ Settings

" 全てのモードでマウスを有効にする
set mouse=a
set ttymouse=xterm2

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
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif
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

" Enable modeline
set modeline

" Use highlight search
set hlsearch

" :h :filetype-overview
filetype plugin indent on

" Always show the sign column
set signcolumn=yes

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Grep検索にripgrepを使用する
if executable('rg')
 set grepprg=rg\ --vimgrep
 set grepformat=%f:%l:%c:%m
endif

" QuickFixリストを自動で開く
autocmd vimrc QuickfixCmdPost make,grep,grepadd,vimgrep copen

" The time in milliseconds that is waited for a key code or mapped key sequence to complete.
set ttimeoutlen=50

" Hide line numbers, etc. in terminal normal mode
autocmd vimrc ModeChanged *:nt setlocal nonumber norelativenumber signcolumn=no

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

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

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

" ref.
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim
"
" Command-line mode keymappings
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" Only when clipboard is enabled
if has('clipboard')
  " <C-y>: paste.
  cnoremap <C-y>          <C-r>*
endif
" <C-g>: Exit.
cnoremap <C-g>          <C-c>
" <C-k>: Delete to the end.
cnoremap <expr><C-k>
      \ repeat("\<Del>", strchars(getcmdline()[getcmdpos() - 1:]))

" Resize Window
" Ref. https://zenn.dev/mattn/articles/83c2d4c7645faa
nmap <C-w>+ <C-w>+<SID>ws
nmap <C-w>- <C-w>-<SID>ws
nmap <C-w>> <C-w>><SID>ws
nmap <C-w>< <C-w><<SID>ws
nnoremap <script> <SID>ws+ <C-w>+<SID>ws
nnoremap <script> <SID>ws- <C-w>-<SID>ws
nnoremap <script> <SID>ws> <C-w>><SID>ws
nnoremap <script> <SID>ws< <C-w><<SID>ws
nmap <SID>ws <Nop>

" Ctrl-Space for omni completion
inoremap <NUL> <C-X><C-O>

" Auto escape / and ? in search command.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" Enable to move freely
" ref.
"   :help virtualedit
"   http://qiita.com/ka_/items/8e7a5e681db857b2ee26#comment-8d7a434b595f023cd12c
set virtualedit=all

" Settings of cursor movement
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k

" Return to normal mode by jj
inoremap <silent> jj <Esc>

" terminal
nnoremap [Shell] <Nop>
nmap <Space>s [Shell]

nnoremap <silent>[Shell]s :botright terminal ++rows=10<CR>
nnoremap <silent>[Shell]c :terminal ++curwin<CR>

tnoremap <silent> <ScrollWheelUp> <C-W>N<C-Y>

" wrap toggle
nnoremap <silent><Leader>w :setlocal wrap!<CR>

" }}}
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" plugin settings {{{
" Ref. https://knowledge.sakura.ad.jp/23248/
" Ref. https://sy-base.com/myrobotics/vim/dein/

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_local_toml_dir = expand('~/.vim/plugins')

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

  call dein#load_toml(s:toml_dir . '/common.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/common_lazy.toml', {'lazy': 1})
  call dein#load_toml(s:toml_dir . '/display.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/ddc.toml', {'lazy': 1})
  call dein#load_toml(s:toml_dir . '/development.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/development_lazy.toml', {'lazy': 1})
  call dein#load_toml(s:toml_dir . '/lsp.toml', {'lazy': 0})
  call dein#load_toml(s:toml_dir . '/dev_ruby.toml', {'lazy': 1})
  if filereadable(s:dein_local_toml_dir . '/fzf.toml')
    call dein#load_toml(s:dein_local_toml_dir . '/fzf.toml', {'lazy': 0})
  endif

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

" Write about device-dependent settings and secure settings
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

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

" ------------------------------------------------------------------------------
" {{{ command

command! -bar -nargs=1 OpenTempBuffer new | setlocal buftype=nofile bufhidden=hide filetype=<args> noswapfile

if get(g:, 'dein#install_github_api_token')
  command DeinUpdate call dein#check_update(v:true)
endif

" tagジャンプの結果をロケーションリストに表示し、ロケーションリストを開く
command LTag exec('ltag '.expand('<cword>')) | lopen

" 文字コードを指定して開きなおす
command! -bang -nargs=? ShiftJIS edit<bang> ++enc=cp932 <args>
command! -bang -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>

" }}}
" ------------------------------------------------------------------------------

" vim: foldmethod=marker
