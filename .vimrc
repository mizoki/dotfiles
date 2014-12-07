"-------------------------------------------------------------------------------
" ■各OS固有の設定 {{{
"-------------------------------------------------------------------------------
" 初期化処理中のみ（再読み込み時に実行しない）
if (has("vim_starting"))
  if (has('mac'))
  elseif ($HOSTNAME == "example.com")
  endif
endif

if (has("win32") || has("win64"))
  set runtimepath+=$HOME/.vim/
  " シェルにPowerShellを使用する
  set shell=powershell
  set shellcmdflag="-c"
  set shellquote="\'"
  set shellxquote="\'"
  set shellredir=">"
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" プラグインの読み込み {{{
"-------------------------------------------------------------------------------
set nocompatible
filetype off

if (has("vim_starting"))
  set rtp+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim' " MRU plugin includes unite.vim MRU sources

" # 汎用
" ## システム
NeoBundle 'vim-scripts/sudo.vim' " Allows one to edit a file with prevledges from an unprivledged session.

" ## ファイル
NeoBundle 'renamer.vim' " 1.0   Use the power of vim to rename groups of files : http://www.vim.org/scripts/script.php?script_id=1721
NeoBundle 'kien/ctrlp.vim' " Fuzzy file, buffer, mru, tag, etc finder.
NeoBundle 'scrooloose/nerdtree' " A tree explorer plugin for vim.

" ## テキストオブジェクト関連
NeoBundle 'kana/vim-textobj-user' " Vim plugin: Create your own text objects
NeoBundle 'kana/vim-textobj-jabraces' " Vim plugin: Text objects for Japanese braces

" ## テキスト
NeoBundle 'Align' " 27/31 Help folks to align text, eqns, declarations, tables, etc : http://www.vim.org/scripts/script.php?script_id=294
NeoBundle 'plasticboy/vim-markdown' " Markdown Vim Mode
NeoBundle 'thinca/vim-qfreplace' " Perform the replacement in quickfix. : ref. http://d.hatena.ne.jp/thinca/20081107/1225997310

" ## アウトライン
NeoBundle 'VOoM' " 1.0   Vim two-pane outliner

" ##カラースキーム
NeoBundle 'w0ng/vim-hybrid' " A dark colour scheme for Vim & gVim
NeoBundle 'altercation/vim-colors-solarized' " precision colorscheme for the vim text editor

" # 開発系
" ## common
NeoBundle 'mattn/webapi-vim' " vim interface to Web API
NeoBundle 'thinca/vim-quickrun' " Run commands quickly.
NeoBundle 'tpope/vim-fugitive' " fugitive.vim: a Git wrapper so awesome, it should be illegal
NeoBundle 'tpope/vim-endwise' " endwise.vim: wisely add 'end' in ruby, endfunction/endif/more in vim script, etc : http://www.vim.org/scripts/script.php?script_id=2386
NeoBundle 'lilydjwg/colorizer' " A Vim plugin to colorize all text in the form #rrggbb or #rgb.
NeoBundle 'surround.vim' " 1.6   Delete/change/add parentheses/quotes/XML-tags/much more with ease : http://www.vim.org/scripts/script.php?script_id=1697
NeoBundle 'mattn/gist-vim' " vimscript for gist

" ## HTML
""" NeoBundle 'mattn/zencoding-vim' " zen-coding for vim : http://code.google.com/p/zen-coding/ : https://github.com/mattn/zencoding-vim
NeoBundle 'mattn/emmet-vim' " emmet for vim: http://emmet.io/
NeoBundle 'str2numchar.vim' " 0.1   String convert to Numeric Character Reference : http://www.vim.org/scripts/script.php?script_id=1646

" ## Ruby
NeoBundle 'tpope/vim-rails' " rails.vim: Ruby on Rails power tools
NeoBundle 'basyura/unite-rails' " a unite.vim plugin for rails http://basyura.org
NeoBundle 'todesking/ruby_hl_lvar.vim' " Highlight Ruby local variables

call neobundle#end()

filetype plugin indent on
syntax enable

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" 設定の変更 {{{
"-------------------------------------------------------------------------------
" 初期のカラースキームを指定する
if has('mac') || has('unix')
  let g:hybrid_use_iTerm_colors = 1
  colorscheme hybrid
endif

" 全てのモードでマウスを有効にする
set mouse=a

" ルーラーを表示
set number

" バックアップファイルを作成しない
set nobackup

" vimgrepを標準のgrepプログラムに指定する
set grepprg=internal

" viminfoの設定を変更
set viminfo='50,<50,s10,:200,@200,/200,h,rA:,rB:"

" ヘルプ検索の優先順位
set helplang=ja,en

" スペルチェックの言語
set spelllang=en_us

" インクリメント・デクリメントの設定
set nrformats=hex,alpha

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
set statusline=[%02n]%f%m\ %y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%r%h%w 
set statusline+=%=%{fugitive#statusline()}[\%04b]\[\0x%04B]\ \ %02l,%02c\ \ %4P

" Tabをスペースに変換する
set expandtab
" タブの幅を2文字に設定する
set tabstop=2
set shiftwidth=2

" Grep検索時にQuickFixリストを自動で表示する
autocmd QuickfixCmdPost grep cw

" テキストの最大幅（フォーマット時に手動で設定する）
set textwidth=0
" デフォルトvimrc_exampleのtextwidth設定上書き
autocmd FileType text setlocal textwidth=0
"
" 全角スペースを視覚化
highlight ZenkakuSpace term=underline cterm=underline ctermbg=White guibg=White
match ZenkakuSpace /　/
" タブを視覚化
"""highlight TabMoji term=underline cterm=underline ctermbg=LightBlue guibg=LightBlue
"2match TabMoji /	/

" タブと改行を可視化
set list
set listchars=tab:»-,trail:␣,eol:⏎,extends:»,precedes:«,nbsp:%

" PowerShellファイルのSyntaxの読み込み用
" autocmd BufRead,BufNewFile *.ps1 set syntax=ps1

" 選択時にクリップボードレジスタに値をコピーする
set guioptions+=a

" CUI用の設定
" set clipboard+=autoselect
set clipboard+=unnamed

" ツールバーを削除
set guioptions-=T

" メニューを削除
"""set guioptions-=m

" Alignプラグインのメニューを非表示にする
let g:DrChipTopLvlMenu=""

"日本語の行の連結時には空白を入力しない。
set formatoptions+=mM

"□や○の文字があってもカーソル位置がずれないようにする。
set ambiwidth=double

"画面最後の行をできる限り表示する。
set display+=lastline

" バッファの内容が変更されていても、バッファの切り替えができるようにする
" :q! を使うときには注意！！
set hidden

" 矩形ビジュアルモードで仮想編集を有効にする
set virtualedit=block

" カーソルがある画面上の行をCursorLineで強調する
set cursorline

" Undoファイルの保存場所を変更
set undodir=~/.vim/undo

" バックスペースが効かない問題に対応する
" ref. http://qiita.com/omega999/items/23aec6a7f6d6735d033f
set backspace=indent,eol,start

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=10

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" キーマップの変更 {{{
"-------------------------------------------------------------------------------
let mapleader = ","     "Set mapleader 
if (has("win32") || has("win64"))
  " 設定ファイル再読込
  nmap <silent><Leader>ss :source ~/_vimrc<CR>
  " 設定ファイル編集
  nmap <silent><Leader>ee :e ~/_vimrc<CR>
  " プリント設定
  nmap <silent><Leader>ps :e ~/macros/printrc.vim<CR>
  " このファイルを編集したら、このファイルを再読込する
  autocmd BufWritePost _vimrc source ~/_vimrc
elseif (has("mac") || has("unix"))
  " 設定ファイル再読込
  nmap <silent><Leader>ss :source ~/.vimrc<CR>
  " 設定ファイル編集
  nmap <silent><Leader>ee :e ~/.vimrc<CR>
  " プリント設定
  nmap <silent><Leader>ps :e ~/Dropbox/Data/Vim/macros/printrc.vim<CR>
  " このファイルを編集したら、このファイルを再読込する
  autocmd BufWritePost .vimrc source ~/.vimrc
endif

" スペルチェックのオン・オフ
"""nmap <silent><Leader>spl :set spell!<CR>

" Ctrl+C でクリップボードへコピー (linux OS用)
" ref. https://github.com/mizoki/rpbcopy
" vnoremap <C-C> :!pbcopy<CR>

" ref. http://qiita.com/kseta/items/ba1754ec74254863e9ec
vnoremap <C-c> :w !pbcopy<CR><CR>

"""nmap <C-C> "*y

" インサートモード時にCtrl+Vでクリップボードからペースト
"""nmap <silent><Leader><C-V>       "*p
"""nmap <S-Insert>  "*p
"""imap <C-V>       <C-R>*
""""cmap <C-V>       <C-R>*
"""cmap <S-Insert>  <C-R>*

" Space でコマンドモード
noremap <Space> :

" Esc×2で検索結果のハイライトを解除する
nnoremap <Esc><Esc> :nohlsearch<CR>

" 分割ウインドウの大きさを調整
nmap <silent><Leader>h <C-W><
nmap <silent><Leader>l <C-W>>
nmap <silent><Leader>j <C-W>+
nmap <silent><Leader>k <C-W>-

if has('kaoriya')
  " 作業用バッファの作成
  nmap <silent><Leader>s :Scratch<CR>
  " カレントディレクトリの変更
  nmap <silent><Space>cd :CdCurrent<CR>
endif

" Auto escape / and ? in search command.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

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
vnoremap ff <Esc>

" Easy escape.
"""inoremap jj <ESC>
"""cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
"""onoremap jj <ESC>
"""
"""inoremap j<Space> j
"""onoremap j<Space> j

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Tab関係の設定 {{{
"-------------------------------------------------------------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[ ' . title . ' ]'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= ' ' . no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
"""set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" 外部アプリケーションの設定 {{{
"-------------------------------------------------------------------------------
if (has("win32") || has("win64"))
elseif (has("mac"))
  " Google Chrome で Google検索
  nmap <silent><Leader>sg :!open -a 'Google Chrome' https://www.google.co.jp/search?q=
  " Safari で Google検索
  nmap <silent><Leader>sf :!open -a 'Safari' https://www.google.co.jp/search?q=
  " Geeknote を実行する
  command! -nargs=+ Geeknote :!geeknote <args>
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" HTML編集用の設定 {{{
"-------------------------------------------------------------------------------

" HTMLの閉じタグの自動入力
autocmd FileType html,xhtml,css,perl inoremap <buffer> </ </<C-x><C-o>

" HTMLの編集時に編集中のファイルを標準のブラウザで開く
autocmd FileType html,xhtml,css,perl nmap <silent><Leader>o :!open %<CR><CR>

" HTMLの編集時に編集中のファイルをw3mで開く
autocmd FileType html,xhtml,css,perl nmap <silent><Leader>w :!w3m %<CR><CR>

" HTMLを編集するときはタブをスペースに変換する
autocmd FileType html,xhtml,css,perl set expandtab

if has('mac')
  " HTMLの編集時に編集中のファイルをGoogle Chromeで開く
  autocmd FileType html,xhtml,css,perl nmap <silent><Leader>gc :!open -a 'Google Chrome' %<CR><CR>
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" emmet-vimの設定 {{{
"-------------------------------------------------------------------------------

" インデントの文字をスペースに変更する
let g:user_emmet_settings = {
  \  'lang' : 'ja',
  \  'html' : {
  \    'indentation' : '  ',
  \    'snippets' : {
  \      'jq' : "<script type=\"text/javascript\" src=\"files/jquery/1.10.2/jquery.min.js\"></script>\n<script>\n\\$(function() {\n\t|\n})\n</script>",
  \      'st' : "<style type=\"text/css\">\n\t<!--\n\t${cursor}\n\t-->\n</style>",
  \      'hs' : "<script type=\"text/javascript\" src=\"files/highslide/highslide.js\"></script>\n<link rel=\"stylesheet\" href=\"files/highslide/highslide.css\" type=\"text/css\">\n<script type=\"text/javascript\">\n\ths.graphicsDir = 'files/highslide/graphics/';\n\ths.outlineType = '';\n\ths.captionEval = 'this.thumb.alt';\n</script>",
  \      'hs:rw' : "<script type=\"text/javascript\" src=\"files/highslide/highslide.js\"></script>\n<link rel=\"stylesheet\" href=\"files/highslide/highslide.css\" type=\"text/css\">\n<script type=\"text/javascript\">\n\ths.graphicsDir = 'files/highslide/graphics/';\n\ths.outlineType = 'rounded-white';\n\ths.captionEval = 'this.thumb.alt';\n</script>",
  \    },
  \    'default_attributes': {
  \      'a:ttl' : {'href': '', 'title': ''},
  \    },
  \  },
  \  'css' : {
  \    'filters' : 'fc',
  \    'snippets' : {
  \      'box-shadow' : "-webkit-box-shadow: 0 0 0 # 000;\n-moz-box-shadow: 0 0 0 0 # 000;\nbox-shadow: 0 0 0 # 000;",
  \    },
  \  },
  \  'javascript' : {
  \    'snippets' : {
  \      'jq' : "\\$(function() {\n\t\\${cursor}\\${child}\n});",
  \      'jq:json' : "\\$.getJSON(\"${cursor}\", function(data) {\n\t\\${child}\n});",
  \      'jq:each' : "\\$.each(data, function(index, item) {\n\t\\${child}\n});",
  \      'fn' : "(function() {\n\t\\${cursor}\n})();",
  \      'tm' : "setTimeout(function() {\n\t\\${cursor}\n}, 100);",
  \    },
  \    'use_pipe_for_cursor' : 0,
  \  },
  \  'xhtml': {
  \    'indentation' : '  ',
  \  },
  \}

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Unite.vimの設定 {{{
" http://www.vim.org/scripts/script.php?script_id=3396
"-------------------------------------------------------------------------------

" Unite起動用のショートカット
nmap <silent><Leader>b :Unite buffer<CR>
nmap <silent><Leader>um :Unite file_mru<CR>
nmap <silent><Leader>ur :Unite register<CR>
nmap <silent><Leader>ut :Unite tab<CR>

" unite-rails
nmap <silent><Leader>rm :Unite rails/model<CR>
nmap <silent><Leader>rv :Unite rails/view<CR>
nmap <silent><Leader>rc :Unite rails/controller<CR>
nmap <silent><Leader>rs :Unite rails/spec<CR>

" Uniteのオプション設定
let g:unite_enable_start_insert = 1 " 絞り込みモードで起動する
let g:unite_winheight = 20          " 起動時のウインドウの高さ（def:20）

" ref. http://blog.monochromegane.com/blog/2013/09/18/ag-and-unite/
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep検索
nnoremap <silent><Leader>g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent><Leader>cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>

" grep検索結果の再呼出
nnoremap <silent><Leader>r  :<C-u>UniteResume search-buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" neocomplcache.vimの設定 {{{
" neocomplete.vimの設定
"-------------------------------------------------------------------------------

if neobundle#is_installed('neocomplete')
    " neocomplete用設定
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_smart_case = 1
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache')
    " neocomplcache用設定
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1
endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"


" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Alignの設定 {{{
"-------------------------------------------------------------------------------

" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

" AlignCtrlの設定を初期状態に戻す(:AlignReset)
command! -nargs=0 AlignReset call Align#AlignCtrl("default")

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" vimfilerの設定 {{{
"-------------------------------------------------------------------------------

" vimfilerをデフォルトのExplorerに指定
let g:vimfiler_as_default_explorer = 1

" Enable file operation commands.
let g:vimfiler_safe_mode_by_default = 0

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" vim-quickrun の設定 {{{
"-------------------------------------------------------------------------------
" デフォルトのキーマッピングを無効にする
"let g:quickrun_no_default_key_mappings = 1

if (has('mac'))
  let g:quickrun_config = {}
  let g:quickrun_config.mkd = {
              \   'outputter' : 'null',
              \   'command': 'open',
              \   'cmdopt': '-a',
              \   'args': 'Mou',
              \   'exec': '%c %o %a %s',
              \ }
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" VimShell の設定 {{{
"-------------------------------------------------------------------------------
" プロンプトの設定
let g:vimshell_user_prompt = 'getcwd()'
" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Ctrlp の設定 {{{
"-------------------------------------------------------------------------------
let g:ctrlp_use_migemo = 1
" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" NERDTree の設定 {{{
"-------------------------------------------------------------------------------
" 隠しファイルをデフォルトで表示
let NERDTreeShowHidden = 1
" デフォルトのエクスプローラを置き換えない
let NERDTreeHijackNetrw = 0

nmap <silent><Leader>f :NERDTree<CR>
" }}}
"-------------------------------------------------------------------------------
