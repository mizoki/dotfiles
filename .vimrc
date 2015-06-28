set encoding=utf-8
scriptencoding utf-8

"-------------------------------------------------------------------------------
" 初期設定 {{{
"-------------------------------------------------------------------------------

" 初期化処理中のみ（再読み込み時に実行しない）
if has("vim_starting")
  if has('gui_running')
    if has('gui_macvim') && executable('powerline-daemon')
      set guifont=Source\ Code\ Pro\ for\ Powerline:h14
    endif
    set columns=9999
    set lines=999
  endif
endif

" vimrc グループのautocmdを初期化
augroup vimrc
  autocmd!
augroup END

" Set mapleader
let g:mapleader = ","

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
NeoBundleLazy "Shougo/vimshell", { 'autoload' : { 'commands' :  [ "VimShell", "VimShellPop" ] } }

let s:bundle = neobundle#get("vimshell")
function! s:bundle.hooks.on_source(bundle)
  " プロンプトの設定
  let g:vimshell_user_prompt = 'getcwd()'
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" Shougo/vimfiler {{{
NeoBundleLazy 'Shougo/vimfiler', {
  \ 'depends' : ["Shougo/unite.vim"],
  \ 'autoload' : {
  \   'commands' : [ "VimFilerTab", "VimFiler", "VimFilerExplorer", "VimFilerBufferDir" ],
  \   'mappings' : ['<Plug>(vimfiler_switch)'],
  \   'explorer' : 1,
  \ }}

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
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'commands' : [{ 'name' : 'Unite',
      \                 'complete' : 'customlist,unite#complete_source'}],
      \ 'depends' : 'Shougo/neomru.vim',
      \ }

" set prefix of unite
nnoremap [Unite] <Nop>
nmap <Space>u [Unite]

" Unite起動用のショートカット
nnoremap <silent>[Unite]b :Unite buffer<CR>
nnoremap <silent>[Unite]f :Unite file<CR>
nnoremap <silent>[Unite]m :Unite file_mru<CR>
nnoremap <silent>[Unite]r :Unite register<CR>
nnoremap <silent>[Unite]t :Unite tab<CR>

"ref. http://kannokanno.hatenablog.com/entry/20120429/1335679101
nnoremap <silent>[Unite]w :UniteWithCursorWord -no-quit line<CR>

" Uniteのオプション設定
let g:unite_enable_start_insert = 1 " 絞り込みモードで起動する
let g:unite_winheight = 20          " 起動時のウインドウの高さ（def:20）

" ref. http://blog.monochromegane.com/blog/2013/09/18/ag-and-unite/
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep検索
nnoremap <silent>[Unite]gg  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent>[Unite]gc :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W><CR>

" grep検索結果の再呼出
nnoremap <silent>[Unite]gr  :<C-u>UniteResume search-buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" -------------------------------------------------------------------------- }}}

" Shougo/neomru.vim {{{

" MRU plugin includes unite.vim MRU sources
NeoBundleLazy 'Shougo/neomru.vim', {
      \ 'filetypes' : 'all'
      \ }

" -------------------------------------------------------------------------- }}}

" basyura/unite-rails {{{

" a unite.vim plugin for rails ( http://basyura.org )
NeoBundleLazy 'basyura/unite-rails' , {
      \ 'filetypes' : 'ruby'
      \ }

let s:bundle = neobundle#get('unite-rails')
function! s:bundle.hooks.on_source(bundle)
  " set prefix of unite-rails
  nnoremap [Rails] <Nop>
  nmap <Space>r [Rails]

  " unite-rails keymap
  nnoremap <silent>[Rails]m :Unite rails/model<CR>
  nnoremap <silent>[Rails]v :Unite rails/view<CR>
  nnoremap <silent>[Rails]c :Unite rails/controller<CR>
  nnoremap <silent>[Rails]s :Unite rails/spec<CR>
  nnoremap <silent>[Rails], :Unite rails/config<CR>
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

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

" junegunn/vim-easy-align {{{

" A Vim alignment plugin
NeoBundleLazy 'junegunn/vim-easy-align', {
      \ 'filetypes' : 'all'
      \ }

let s:bundle = neobundle#get('vim-easy-align')
function! s:bundle.hooks.on_source(bundle)
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" ctrlpvim/ctrlp.vim {{{
NeoBundle 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file, buffer, mru, tag, etc finder. http://ctrlpvim.github.com/ctrlp.vim

" Save every MRU file path
let g:ctrlp_tilde_homedir = 1
" Enable per-session caching
let g:ctrlp_use_caching = 1

" ref. http://celt.hatenablog.jp/entry/2014/07/11/205308
" ag入ってたらagで検索させる
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g ""'
endif

" -------------------------------------------------------------------------- }}}

" thinca/vim-quickrun {{{
NeoBundle 'thinca/vim-quickrun'              " Run commands quickly.

" デフォルトのキーマッピングを無効にする
let g:quickrun_no_default_key_mappings = 1

" Keymap
nnoremap <silent><Leader>rr :QuickRun<CR>

" Default Settings
let g:quickrun_config = {
      \ '_' : {
      \   'outputter/buffer/split' : ':botright 10sp',
      \ },
      \}

" Markdown Viewer Settings for Mac
if (has('mac'))
  let g:quickrun_config.markdown = {
        \
        \   'outputter' : 'null',
        \   'command': 'open',
        \   'cmdopt': '-a',
        \   'args': 'Marked\ 2',
        \   'exec': '%c %o %a %s'
        \ }
endif

" -------------------------------------------------------------------------- }}}

" mattn/emmet-vim {{{

" emmet for vim ( http://emmet.io/ )
NeoBundleLazy 'mattn/emmet-vim', {
      \ 'filetypes' : 'all'
      \ }

let s:bundle = neobundle#get('emmet-vim')
function! s:bundle.hooks.on_source(bundle)
  let g:user_emmet_settings = {
        \  'lang' : 'ja',
        \  'html' : {
        \    'indentation' : '  ',
        \    'snippets' : {
        \      'bt' : "<script type=\"text/javascript\" src=\"files/bower_components/jquery/dist/jquery.min.js\"></script>\n<script type=\"text/javascript\" src=\"files/bower_components/bootstrap/dist/js/bootstrap.min.js\"></script>\n<link rel=\"stylesheet\" href=\"files/bower_components/bootstrap/dist/css/bootstrap.min.css\">",
        \      'jq' : "<script type=\"text/javascript\" src=\"files/bower_components/jquery/dist/jquery.min.js\"></script>\n<script>\n\\$(function() {\n\t|\n})\n</script>",
        \      'st' : "<style type=\"text/css\">\n\t<!--\n\t${cursor}\n\t-->\n</style>",
        \      'hs' : "<script type=\"text/javascript\" src=\"files/highslide/highslide.js\"></script>\n<link rel=\"stylesheet\" href=\"files/highslide/highslide.css\" type=\"text/css\">\n<script type=\"text/javascript\">\n\ths.graphicsDir = 'files/highslide/graphics/';\n\ths.outlineType = '';\n\ths.captionEval = 'this.thumb.alt';\n</script>",
        \      'hs:rw' : "<script type=\"text/javascript\" src=\"files/highslide/highslide.js\"></script>\n<link rel=\"stylesheet\" href=\"files/highslide/highslide.css\" type=\"text/css\">\n<script type=\"text/javascript\">\n\ths.graphicsDir = 'files/highslide/graphics/';\n\ths.outlineType = 'rounded-white';\n\ths.captionEval = 'this.thumb.alt';\n</script>",
        \    },
        \    'default_attributes': {
        \      'a:ttl' : {'href': '', 'title': ''},
        \      'a:ttg' : {'href': '', 'target': '_blank'},
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
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" mattn/gist-vim {{{

" vimscript for gist
NeoBundleLazy 'mattn/gist-vim'

" -------------------------------------------------------------------------- }}}

" mattn/qiita-vim {{{

NeoBundleLazy 'mattn/qiita-vim'

" -------------------------------------------------------------------------- }}}

" tyru/open-browser.vim {{{

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'functions' : 'openbrowser#open',
      \ }

let s:bundle = neobundle#get('open-browser.vim')
function! s:bundle.hooks.on_source(bundle)
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" Shougo/vinarise.vim {{{

" Ultimate hex editing system with Vim
NeoBundleLazy 'Shougo/vinarise.vim', {
      \ 'commands' : [{ 'name' : 'Vinarise', 'complete' : 'file' }]
      \ }

" -------------------------------------------------------------------------- }}}

" vim-scripts/sudo.vim {{{

" Allows one to edit a file with prevledges from an unprivledged session.
NeoBundleLazy 'vim-scripts/sudo.vim', {
      \ 'filetypes' : 'all'
      \ }

" -------------------------------------------------------------------------- }}}

" powerline/powerline {{{

if executable('powerline-daemon')
  NeoBundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

  " Hide the default mode text (e.g. -- INSERT -- below the statusline)
  set noshowmode
endif

" -------------------------------------------------------------------------- }}}

" glidenote/memolist.vim {{{

NeoBundleLazy 'glidenote/memolist.vim', {
      \ 'autoload' : {
      \   'commands' : [ 'MemoNew', 'MemoList', 'MemoGrep' ]},
      \ }

" set prefix of memolist
nnoremap [Memo] <Nop>
nmap <Space>m [Memo]

" memolist keymap
nnoremap <silent>[Memo]c :MemoNew<CR>
nnoremap <silent>[Memo]l :MemoList<CR>
nnoremap <silent>[Memo]g :MemoGrep<CR>
nnoremap <silent>[Memo]f :execute 'CtrlP' '~/Dropbox/Documents'<CR>

let s:bundle = neobundle#get('memolist.vim')
function! s:bundle.hooks.on_source(bundle)
  " memo directory
  let g:memolist_path = '~/Dropbox/Documents'

  " template directory
  let g:memolist_template_dir_path = '~/Dropbox/Documents/memolist/template'

  " suffix type (default markdown)
  let g:memolist_memo_suffix = 'md'

  " date format (default %Y-%m-%d %H:%M)
  let g:memolist_memo_date = '%Y/%m/%d %H:%M'

  " use vimfler (default 0)
  let g:memolist_vimfiler = 1

  " use arbitrary vimfler option (default -split -winwidth=50)
  let g:memolist_vimfiler_option = "-horizontal -sort-type=Filename"
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" haya14busa/vim-migemo {{{

if executable('cmigemo')
  NeoBundleLazy 'haya14busa/vim-migemo', {
      \ 'filetypes' : 'all'
      \ }
endif

" -------------------------------------------------------------------------- }}}

" VOoM {{{

" Vim two-pane outliner
NeoBundleLazy 'VOoM', {
      \ 'filetypes' : [ 'html', 'markdown' ]
      \ }

let s:bundle = neobundle#get('VOoM')
function! s:bundle.hooks.on_source(bundle)
  " Set VoomToggle for markdown
  nnoremap <Leader>m :VoomToggle markdown<CR>
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

" kana/vim-textobj-user {{{

" Vim plugin: Create your own text objects
NeoBundleLazy 'kana/vim-textobj-user', {
      \ 'filetypes' : 'all'
      \ }

" -------------------------------------------------------------------------- }}}

" kana/vim-textobj-jabraces {{{

" Vim plugin: Text objects for Japanese braces
NeoBundleLazy 'kana/vim-textobj-jabraces', {
      \ 'filetypes' : 'all'
      \ }

" -------------------------------------------------------------------------- }}}

" thinca/vim-qfreplace {{{

" Perform the replacement in quickfix.
" ref. http://d.hatena.ne.jp/thinca/20081107/1225997310
NeoBundleLazy 'thinca/vim-qfreplace', {
      \ 'filetypes' : 'all'
      \ }

" -------------------------------------------------------------------------- }}}

" tpope/vim-fugitive {{{

" fugitive.vim: a Git wrapper so awesome, it should be illegal
NeoBundle 'tpope/vim-fugitive'

" set prefix of vim-fugitive
nnoremap [Git] <Nop>
nmap <space>g [Git]

" keymaps
nnoremap <silent>[Git]b :Gblame<CR>
nnoremap <silent>[Git]d :Gdiff<CR>
nnoremap <silent>[Git]f :Gfetch<CR>
nnoremap <silent>[Git]s :Gstatus<CR>
nnoremap <silent>[Git]w :Gbrowse<CR>

if executable('tig')
  nnoremap <silent>[Git]t :silent !tig --all<CR>:redraw!<CR>
endif

" -------------------------------------------------------------------------- }}}

NeoBundle 'surround.vim'                     " 1.6   Delete/change/add parentheses/quotes/XML-tags/much more with ease ( http://www.vim.org/scripts/script.php?script_id=1697 )
NeoBundle 'str2numchar.vim'                  " 0.1   String convert to Numeric Character Reference ( http://www.vim.org/scripts/script.php?script_id=1646 )
NeoBundle 'mattn/webapi-vim'                 " vim interface to Web API
NeoBundle 'rking/ag.vim'                     " Vim plugin for the_silver_searcher, 'ag', a replacement for the Perl module / CLI script 'ack'
NeoBundle 'rhysd/committia.vim'              " A Vim plugin for more pleasant editing on commit messages
NeoBundle 'tpope/vim-endwise'                " endwise.vim: wisely add 'end' in ruby, endfunction/endif/more in vim script, etc ( http://www.vim.org/scripts/script.php?script_id=2386 )
NeoBundle 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin that also handles embedded filetypes

NeoBundle 'nathanaelkane/vim-indent-guides'  " A Vim plugin for visually displaying indent levels in code


" color schemes {{{

" NeoBundle 'w0ng/vim-hybrid'                  " A dark colour scheme for Vim & gVim
" NeoBundle 'altercation/vim-colors-solarized' " precision colorscheme for the vim text editor
" NeoBundle 'chriskempson/vim-tomorrow-theme'  " Tomorrow Theme for Vim
NeoBundle 'jpo/vim-railscasts-theme'         " A vim color scheme based on the Railscasts Textmate theme.

" -------------------------------------------------------------------------- }}}

" Ruby Development {{{

" rails.vim: Ruby on Rails power tools
NeoBundleLazy 'tpope/vim-rails', {
      \ 'filetypes' : ['ruby', 'eruby']
      \ }
" Highlight Ruby local variables
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
      \ 'filetypes' : 'ruby'
      \ }

" thinca/vim-ref {{{
" ref. https://github.com/kaosf/dotfiles/commit/efb7250ca9a7d3727a8fcec91581642cc89a491d
"
" Commands to setup
"   gem install refe2
"   rbenv rehash
"   bitclust setup
" ref. http://qiita.com/masa2sei/items/85a2c2cc3721c79a5322

NeoBundleLazy 'thinca/vim-ref', {
      \ 'filetypes' : 'ruby'
      \ }

let s:bundle = neobundle#get('vim-ref')
function! s:bundle.hooks.on_source(bundle)
  let g:ref_refe_cmd = $HOME . '/.rbenv/shims/refe'
endfunction
unlet s:bundle

" -------------------------------------------------------------------------- }}}

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
" 設定の変更 {{{
"-------------------------------------------------------------------------------

" vimrc_example.vimから設定をコピー {{{

" MacVimはvimrc_example.vimを読み込むので実行しない
if !has("kaoriya")

  " allow backspacing over everything in insert mode
  set backspace=indent,eol,start

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd vimrc BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " always set autoindenting on
  set autoindent

endif

" -------------------------------------------------------------------------- }}}

" 全てのモードでマウスを有効にする
set mouse=a

" 行番号を表示
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

" Powerline is not installed
if !(executable('powerline-daemon'))
  " ステータス行の設定
  set statusline=[%02n]%f%m\ %y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%r%h%w
  set statusline+=%=%{fugitive#statusline()}[\%04b]\[\0x%04B]\ \ %02l,%02c\ \ %4P
endif

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

" 80桁目にラインを入れる
set colorcolumn=80

" タブと改行を可視化
set list
set listchars=tab:»-,trail:␣,eol:⏎,extends:»,precedes:«,nbsp:%

" クリップボードの設定
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
" 選択時にクリップボードレジスタに値をコピーする
"set guioptions+=a
"set clipboard+=autoselect

" ツールバーを削除
set guioptions-=T

" メニューを削除
"""set guioptions-=m

"日本語の行の連結時には空白を入力しない。
set formatoptions+=mM

" Powerline is not installed
if !(executable('powerline-daemon'))
  "□や○の文字があってもカーソル位置がずれないようにする。
  set ambiwidth=double
else
  set ambiwidth=single
endif

"画面最後の行をできる限り表示する。
set display+=lastline

" バッファの内容が変更されていても、バッファの切り替えができるようにする
set hidden

" 矩形ビジュアルモードで仮想編集を有効にする
set virtualedit=block

" カーソルがある画面上の行をCursorLineで強調する
set cursorline

" Enable undofile
set undofile
" Undoファイルの保存場所を変更
set undodir=~/.vim/undo

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=10

" ref. http://itchyny.hatenablog.com/entry/2014/12/25/090000
" Determines the maximum number of items to show in the popup menu for Insert mode completion.
set pumheight=10

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

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

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" キーマップの変更 {{{
"-------------------------------------------------------------------------------

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

" Ctrl+C でクリップボードへコピー
" ref. http://qiita.com/kseta/items/ba1754ec74254863e9ec
if executable('pbcopy')
  vnoremap <C-c> :w !pbcopy<CR><CR>
elseif executable('xsel')
  vnoremap <C-c> :w !xsel -ib<CR><CR>
endif

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

" 作業用バッファの作成
nnoremap <silent><Leader>s :Scratch<CR>
" カレントディレクトリの変更
nnoremap <silent><Space>cd :CdCurrent<CR>

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

" ref.
" http://qiita.com/inodev/items/4f4d5412e65c2564b273
"検索語が画面の真ん中に来るようにする
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Cursor movement in insert mode
" ref. http://qiita.com/y_uuki/items/14389dbaaa43d25f3254
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" 日本語入力がオンのままでも挿入モードに移行する
" ref. http://qiita.com/ssh0/items/9e7f0d8b8f033183dd0b
nnoremap あ a
nnoremap い i
nnoremap お o

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" コマンドの定義 {{{
"-------------------------------------------------------------------------------

" Tab関係の設定 {{{
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

" -------------------------------------------------------------------------- }}}

" Capture コマンドの設定 {{{
" Ref. http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

"----------------------------------------------------------------------------}}}

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" 外部アプリケーションの設定 {{{
"-------------------------------------------------------------------------------

if (has("win32") || has("win64"))
elseif (has("mac"))
  if isdirectory('/Applications/Dash.app/')
    " search documents using the Dash
    " ref . http://qiita.com/yuyuchu3333/items/292e99a521a9653e75fb
    function! s:dash(...)
      let ft = &filetype
      if &filetype == 'python'
        let ft = ft.'2'
      endif
      let ft = ft.':'
      let word = len(a:000) == 0 ? input('Dash search: ', ft.expand('<cword>')) : ft.join(a:000, ' ')
      call system(printf("open dash://'%s'", word))
    endfunction
    command! -nargs=* Dash call <SID>dash(<f-args>)
  endif
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
  if executable('w3m')
    autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>w :!w3m %<CR><CR>
  endif

  " HTMLを編集するときはタブをスペースに変換する
  autocmd FileType html,xhtml,css,perl set expandtab
augroup END

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" Color Settings {{{
"-------------------------------------------------------------------------------

syntax enable

if neobundle#is_installed('vim-hybrid') && neobundle#is_sourced('vim-hybrid')
  colorscheme hybrid
elseif neobundle#is_installed('vim-colors-solarized') && neobundle#is_sourced('vim-colors-solarized')
  set background=dark
  colorscheme solarized
elseif neobundle#is_installed('vim-tomorrow-theme') && neobundle#is_sourced('vim-tomorrow-theme')
  colorscheme Tomorrow-Night-Eighties
elseif neobundle#is_installed('vim-railscasts-theme') && neobundle#is_sourced('vim-railscasts-theme')
  colorscheme railscasts
else
  colorscheme desert
endif

" Display full-width space
highlight ZenkakuSpace term=underline cterm=underline ctermbg=White guibg=White
match ZenkakuSpace /　/

" nathanaelkane/vim-indent-guides {{{

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size=shiftwidth()-1
let g:indent_guides_exclude_filetypes=[
      \ 'diff',
      \ 'help',
      \ 'unite',
      \ 'vimfiler',
      \ 'vimshell',
      \ 'voomtree',
      \ ]
hi IndentGuidesOdd  ctermbg=4, guibg=darkblue
hi IndentGuidesEven ctermbg=6, guibg=darkcyan

" }}}

" }}}
"-------------------------------------------------------------------------------

" vim: foldmethod=marker
