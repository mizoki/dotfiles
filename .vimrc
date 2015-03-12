set encoding=utf-8
scriptencoding utf-8

"-------------------------------------------------------------------------------
" ■各OS固有の設定 {{{
"-------------------------------------------------------------------------------

" 初期化処理中のみ（再読み込み時に実行しない）
"if (has("vim_starting"))
"  if (has('mac'))
"  elseif ($HOSTNAME == "example.com")
"  endif
"endif

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
" 設定の変更 {{{
"-------------------------------------------------------------------------------

" vimrc グループのautocmdを初期化
augroup vimrc
  autocmd!
augroup END

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
set spelllang=en,cjk

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
autocmd vimrc QuickfixCmdPost grep cw

" テキストの最大幅（フォーマット時に手動で設定する）
set textwidth=0
" デフォルトvimrc_exampleのtextwidth設定上書き
autocmd vimrc FileType text setlocal textwidth=0

" タブと改行を可視化
set list
set listchars=tab:»-,trail:␣,eol:⏎,extends:»,precedes:«,nbsp:%

" 選択時にクリップボードレジスタに値をコピーする
set guioptions+=a

" CUI用の設定
" set clipboard+=autoselect
set clipboard+=unnamed

" ツールバーを削除
set guioptions-=T

" メニューを削除
"""set guioptions-=m

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

" Enable undofile
set undofile
" Undoファイルの保存場所を変更
set undodir=~/.vim/undo

" バックスペースが効かない問題に対応する
" ref. http://qiita.com/omega999/items/23aec6a7f6d6735d033f
set backspace=indent,eol,start

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=10

" ref. http://itchyny.hatenablog.com/entry/2014/12/25/090000
" Determines the maximum number of items to show in the popup menu for Insert mode completion.
set pumheight=10

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" キーマップの変更 {{{
"-------------------------------------------------------------------------------

let g:mapleader = ","     "Set mapleader
if (has("win32") || has("win64"))
  " 設定ファイル再読込
  nnoremap <silent><Leader>ss :source ~/_vimrc<CR>
  " 設定ファイル編集
  nnoremap <silent><Leader>ee :e ~/_vimrc<CR>
  " プリント設定
  nnoremap <silent><Leader>ps :e ~/macros/printrc.vim<CR>
  " このファイルを編集したら、このファイルを再読込する
  autocmd vimrc BufWritePost _vimrc source ~/_vimrc
elseif (has("mac") || has("unix"))
  " 設定ファイル再読込
  nnoremap <silent><Leader>ss :source ~/.vimrc<CR>
  " 設定ファイル編集
  nnoremap <silent><Leader>ee :e ~/.vimrc<CR>
  " プリント設定
  nnoremap <silent><Leader>ps :e ~/Dropbox/Data/Vim/macros/printrc.vim<CR>
  " このファイルを編集したら、このファイルを再読込する
  autocmd vimrc BufWritePost .vimrc source ~/.vimrc
endif

" Switch to command mode with semi colon key (For US keyboard)
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" スペルチェックのオン・オフ
nnoremap <silent><Leader>spl :set spell!<CR>

" Ctrl+C でクリップボードへコピー (linux OS用)
" ref. https://github.com/mizoki/rpbcopy
" vnoremap <C-C> :!pbcopy<CR>

" ref. http://qiita.com/kseta/items/ba1754ec74254863e9ec
vnoremap <C-c> :w !pbcopy<CR><CR>

" Space でコマンドモード
nnoremap <Space> :

" Esc×2で検索結果のハイライトを解除する
nnoremap <Esc><Esc> :nohlsearch<CR>

" 分割ウインドウ操作関係のプレフィックス
nnoremap [Window] <Nop>
nmap s [Window]

" ウインドウの分割
nnoremap [Window]s :split<CR>
nnoremap [Window]v :vsplit<CR>

" 分割ウインドウを閉じる
nnoremap [Window]q <C-W>q

" 分割ウインドウ間の移動
nnoremap [Window]j <C-W>j
nnoremap [Window]k <C-W>k
nnoremap [Window]l <C-W>l
nnoremap [Window]h <C-W>h

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

if has('kaoriya')
  " 作業用バッファの作成
  nnoremap <silent><Leader>s :Scratch<CR>
  " カレントディレクトリの変更
  nnoremap <silent><Space>cd :CdCurrent<CR>
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

" ref.
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim
" https://github.com/Shougo/shougo-s-github/blob/d0c3785c4a3913ba3fc02e184de8d51c9356e535/vim/rc/mappings.rc.vim#L42-L62
"
" Command-line mode keymappings:"{{{
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
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
"}}}

" Easy escape.
"""inoremap jj <ESC>
"""cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
"""onoremap jj <ESC>
"""
"""inoremap j<Space> j
"""onoremap j<Space> j

" Set VoomToggle for markdown
nnoremap <Leader>m :VoomToggle markdown<CR>

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
nnoremap [Tab] <Nop>
nmap t [Tab]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

nnoremap <silent> [Tab]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
nnoremap <silent> [Tab]x :tabclose<CR>
" tx タブを閉じる
nnoremap <silent> [Tab]n :tabnext<CR>
" tn 次のタブ
nnoremap <silent> [Tab]p :tabprevious<CR>
" tp 前のタブ

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" 外部アプリケーションの設定 {{{
"-------------------------------------------------------------------------------

if (has("win32") || has("win64"))
elseif (has("mac"))
  " Google Chrome で Google検索
  nnoremap <silent><Leader>sg :!open -a 'Google Chrome' https://www.google.co.jp/search?q=
  " Safari で Google検索
  nnoremap <silent><Leader>sf :!open -a 'Safari' https://www.google.co.jp/search?q=
  " Geeknote を実行する
  command! -nargs=+ Geeknote :!geeknote <args>
endif

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" HTML編集用の設定 {{{
"-------------------------------------------------------------------------------

" htmlグループのautocmdを設定
augroup html
  autocmd!
  " HTMLの閉じタグの自動入力
  autocmd FileType html,xhtml,css,perl inoremap <buffer> </ </<C-x><C-o>

  " HTMLの編集時に編集中のファイルを標準のブラウザで開く
  autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>o :!open %<CR><CR>

  " HTMLの編集時に編集中のファイルをw3mで開く
  autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>w :!w3m %<CR><CR>

  " HTMLを編集するときはタブをスペースに変換する
  autocmd FileType html,xhtml,css,perl set expandtab

  if has('mac')
    " HTMLの編集時に編集中のファイルをGoogle Chromeで開く
    autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>gc :!open -a 'Google Chrome' %<CR><CR>
  endif
augroup END

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" プラグインの設定 {{{
"-------------------------------------------------------------------------------

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if (has("vim_starting"))
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }


" Shougo/vimshell {{{
NeoBundle 'Shougo/vimshell'

" プロンプトの設定
let g:vimshell_user_prompt = 'getcwd()'

" -------------------------------------------------------------------------- }}}

" Shougo/vimfiler {{{
NeoBundle 'Shougo/vimfiler'

" vimfilerをデフォルトのExplorerに指定
let g:vimfiler_as_default_explorer = 1

" Enable file operation commands.
let g:vimfiler_safe_mode_by_default = 0

if has('mac')
  " QuickLook
  " See :h g:vimfiler_quick_look_command
  let g:vimfiler_quick_look_command = 'qlmanage -p'
  augroup vimfiler
    autocmd!
    autocmd FileType vimfiler nmap <buffer> p <Plug>(vimfiler_quick_look)
  augroup END
endif

" Tree View Filer
nnoremap <silent><Leader>f :VimFilerExplore -split -winwidth=30 -find -no-quit<CR>

" -------------------------------------------------------------------------- }}}

" Shougo/neocomplcache or Shougo/neocomplete  {{{
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

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

" -------------------------------------------------------------------------- }}}

" Shougo/unite.vim {{{
" http://www.vim.org/scripts/script.php?script_id=3396
NeoBundle 'Shougo/unite.vim'

" Unite起動用のショートカット
nnoremap <silent><Leader>b :Unite buffer<CR>
nnoremap <silent><Leader>uf :Unite file<CR>
nnoremap <silent><Leader>um :Unite file_mru<CR>
nnoremap <silent><Leader>ur :Unite register<CR>
nnoremap <silent><Leader>ut :Unite tab<CR>

"ref. http://kannokanno.hatenablog.com/entry/20120429/1335679101
nnoremap <silent><Leader>uw :UniteWithCursorWord -no-quit line<CR>

" unite-rails
nnoremap <silent><Leader>rm :Unite rails/model<CR>
nnoremap <silent><Leader>rv :Unite rails/view<CR>
nnoremap <silent><Leader>rc :Unite rails/controller<CR>
nnoremap <silent><Leader>rs :Unite rails/spec<CR>

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

" -------------------------------------------------------------------------- }}}

NeoBundle 'Shougo/neomru.vim'                " MRU plugin includes unite.vim MRU sources
NeoBundle 'basyura/unite-rails'              " a unite.vim plugin for rails ( http://basyura.org )

" Shougo/neosnippet.vim {{{
NeoBundle 'Shougo/neosnippet.vim'            " neo-snippet plugin contains neocomplcache snippets source

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" -------------------------------------------------------------------------- }}}

NeoBundle 'Shougo/neosnippet-snippets'       " The standard snippets repository for neosnippet

" Align {{{
NeoBundle 'Align'                            " 27/31 Help folks to align text, eqns, declarations, tables, etc ( http://www.vim.org/scripts/script.php?script_id=294 )

" Alignプラグインのメニューを非表示にする
let g:DrChipTopLvlMenu=""

" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

" AlignCtrlの設定を初期状態に戻す(:AlignReset)
command! -nargs=0 AlignReset call Align#AlignCtrl("default")

" -------------------------------------------------------------------------- }}}

" ctrlpvim/ctrlp.vim {{{
NeoBundle 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file, buffer, mru, tag, etc finder. http://ctrlpvim.github.com/ctrlp.vim

" ref. http://celt.hatenablog.jp/entry/2014/07/11/205308
" ag入ってたらagで検索させる
" ついでにキャッシュファイルからの検索もさせない
if executable('ag')
  let g:ctrlp_use_caching = 0
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g ""'
endif

" -------------------------------------------------------------------------- }}}

" thinca/vim-quickrun {{{
NeoBundle 'thinca/vim-quickrun'              " Run commands quickly.

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

" -------------------------------------------------------------------------- }}}

" mattn/emmet-vim {{{
NeoBundle 'mattn/emmet-vim'                  " emmet for vim ( http://emmet.io/ )

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
  \      'a:ttg' : {'href': '', 'title': '', 'target': '_blank'},
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

" -------------------------------------------------------------------------- }}}

NeoBundle 'VOoM'                             " 1.0   Vim two-pane outliner
NeoBundle 'surround.vim'                     " 1.6   Delete/change/add parentheses/quotes/XML-tags/much more with ease ( http://www.vim.org/scripts/script.php?script_id=1697 )
NeoBundle 'str2numchar.vim'                  " 0.1   String convert to Numeric Character Reference ( http://www.vim.org/scripts/script.php?script_id=1646 )
NeoBundle 'Shougo/vinarise.vim'              " Ultimate hex editing system with Vim
NeoBundle 'vim-scripts/sudo.vim'             " Allows one to edit a file with prevledges from an unprivledged session.
NeoBundle 'mattn/webapi-vim'                 " vim interface to Web API
NeoBundle 'kana/vim-textobj-user'            " Vim plugin: Create your own text objects
NeoBundle 'kana/vim-textobj-jabraces'        " Vim plugin: Text objects for Japanese braces
NeoBundle 'plasticboy/vim-markdown'          " Markdown Vim Mode
NeoBundle 'rking/ag.vim'                     " Vim plugin for the_silver_searcher, 'ag', a replacement for the Perl module / CLI script 'ack'
NeoBundle 'thinca/vim-qfreplace'             " Perform the replacement in quickfix. ( ref. http://d.hatena.ne.jp/thinca/20081107/1225997310 )
NeoBundle 'tpope/vim-fugitive'               " fugitive.vim: a Git wrapper so awesome, it should be illegal
NeoBundle 'rhysd/committia.vim'              " A Vim plugin for more pleasant editing on commit messages
NeoBundle 'tpope/vim-endwise'                " endwise.vim: wisely add 'end' in ruby, endfunction/endif/more in vim script, etc ( http://www.vim.org/scripts/script.php?script_id=2386 )
NeoBundle 'lilydjwg/colorizer'               " A Vim plugin to colorize all text in the form #rrggbb or #rgb.
NeoBundle 'mattn/gist-vim'                   " vimscript for gist
NeoBundle 'mattn/qiita-vim'
NeoBundle 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin that also handles embedded filetypes

NeoBundle 'nathanaelkane/vim-indent-guides'  " A Vim plugin for visually displaying indent levels in code

NeoBundle 'w0ng/vim-hybrid'                  " A dark colour scheme for Vim & gVim
NeoBundle 'altercation/vim-colors-solarized' " precision colorscheme for the vim text editor
NeoBundle 'chriskempson/vim-tomorrow-theme'  " Tomorrow Theme for Vim

" Ruby Development {{{

" rails.vim: Ruby on Rails power tools
NeoBundleLazy 'tpope/vim-rails', {
      \ 'filetypes' : 'ruby'
      \ }
" Highlight Ruby local variables
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
      \ 'filetypes' : 'ruby'
      \ }

" -------------------------------------------------------------------------- }}}

" Swift Development {{{

if has('mac')
  " Adds Swift support to vim. It covers syntax, intenting, and more.
  NeoBundleLazy 'toyamarinyon/vim-swift', {
        \ 'filetypes' : 'swift'
        \ }
endif

" -------------------------------------------------------------------------- }}}

call neobundle#end()

filetype plugin indent on

" Disable default plugins {{{
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_gzip = 1
let g:loaded_getscriptPlugin = 1

" -------------------------------------------------------------------------- }}}

" Disable kaoriya plugins {{{
if has('kaoriya')
  let plugin_autodate_disable = 1
endif

" -------------------------------------------------------------------------- }}}

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Color Settings {{{
"-------------------------------------------------------------------------------

syntax enable
colorscheme Tomorrow-Night-Eighties

" Display full-width space
highlight ZenkakuSpace term=underline cterm=underline ctermbg=White guibg=White
match ZenkakuSpace /　/

" nathanaelkane/vim-indent-guides {{{

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size=shiftwidth()-1
let g:indent_guides_exclude_filetypes=['help', 'vimfiler', 'unite', 'voomtree']
hi IndentGuidesOdd  ctermbg=4
hi IndentGuidesEven ctermbg=6

" }}}

" }}}
"-------------------------------------------------------------------------------

" vim: foldmethod=marker
