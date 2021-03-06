set encoding=utf-8
scriptencoding utf-8

"-------------------------------------------------------------------------------
" 初期設定 {{{
"-------------------------------------------------------------------------------

" vimrc グループのautocmdを初期化
augroup vimrc
  autocmd!
augroup END

" Set mapleader
let g:mapleader = ","

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" プラグインの設定 {{{
"-------------------------------------------------------------------------------

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

" To install dein.vim if dein.vim is not installed.
let s:dein_dir = '~/.vim/dein/repos/github.com/Shougo/dein.vim'
if !isdirectory(expand(s:dein_dir))
  if executable('git')
    echo 'install dein.vim ...'
    call system('git clone https://github.com/Shougo/dein.vim ' . s:dein_dir)
  endif
endif

if (has("vim_starting"))
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
endif

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')

if !((has("win32") || has("win64")) && has("kaoriya"))
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
endif

" Shougo/vimshell {{{
call dein#add('Shougo/vimshell')

" プロンプトの設定
let g:vimshell_user_prompt = 'getcwd()'

" -------------------------------------------------------------------------- }}}

" Shougo/vimfiler {{{
call dein#add('Shougo/vimfiler')

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

" Shougo/deoplete.nvim or Shougo/neocomplcache or Shougo/neocomplete  {{{
if has('nvim')
  call dein#add('Shougo/deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
elseif has('lua')
  call dein#add('Shougo/neocomplete')

  " neocomplete用設定
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_ignore_case = 1
  let g:neocomplete#enable_smart_case = 1
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
else
  call dein#add('Shougo/neocomplcache')

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
call dein#add('Shougo/unite.vim')

" MRU plugin includes unite.vim MRU sources
call dein#add('Shougo/neomru.vim')

" outline source for unite.vim http://d.hatena.ne.jp/h1mesuke/20101107/p1
call dein#add('Shougo/unite-outline')

" set prefix of unite
nnoremap [Unite] <Nop>
nmap <Space>u [Unite]

" Unite起動用のショートカット
nnoremap <silent>[Unite]b :Unite buffer<CR>
nnoremap <silent>[Unite]f :Unite file<CR>
nnoremap <silent>[Unite]m :Unite file_mru<CR>
nnoremap <silent>[Unite]o :Unite -no-quit -vertical -winwidth=60 outline<CR>
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

" basyura/unite-rails {{{

" a unite.vim plugin for rails ( http://basyura.org )
call dein#add('basyura/unite-rails')

" set prefix of unite-rails
nnoremap [Rails] <Nop>
nmap <Space>r [Rails]

" unite-rails keymap
nnoremap <silent>[Rails], :Unite rails/config<CR>
nnoremap <silent>[Rails]a :Unite rails/asset<CR>
nnoremap <silent>[Rails]c :Unite rails/controller<CR>
nnoremap <silent>[Rails]d :Unite rails/db<CR>
nnoremap <silent>[Rails]h :Unite rails/helper<CR>
nnoremap <silent>[Rails]j :Unite rails/job<CR>
nnoremap <silent>[Rails]l :Unite rails/lib<CR>
nnoremap <silent>[Rails]m :Unite rails/model<CR>
nnoremap <silent>[Rails]s :Unite rails/spec<CR>
nnoremap <silent>[Rails]v :Unite rails/view<CR>

" -------------------------------------------------------------------------- }}}

" Shougo/neosnippet.vim {{{
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')

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

" junegunn/vim-easy-align {{{

" A Vim alignment plugin
call dein#add('junegunn/vim-easy-align')

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" -------------------------------------------------------------------------- }}}

" thinca/vim-quickrun {{{
call dein#add('thinca/vim-quickrun')

" デフォルトのキーマッピングを無効にする
let g:quickrun_no_default_key_mappings = 1

" Keymap
nnoremap [QuickRun] <Nop>
nmap <silent><Leader>r [QuickRun]

nnoremap <silent>[QuickRun]e :QuickRun<CR>
nnoremap <silent>[QuickRun]r :QuickRun ruby.rspec<CR>
nnoremap <silent>[QuickRun]q :bw! \[quickrun\ output\]<CR>

" Default Settings
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error' : 'quickfix',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ 'outputter/buffer/split' : ':botright 10sp',
      \ }

" Markdown Viewer Settings for Mac
if (has('mac'))
  let g:quickrun_config.markdown = {
        \   'outputter' : 'null',
        \   'command': 'open',
        \   'cmdopt': '-a',
        \   'args': 'Marked\ 2',
        \   'exec': '%c %o %a %s'
        \ }
endif

" Ruby RSpec
let g:quickrun_config['ruby.rspec'] = {
      \ 'runner': 'terminal',
      \ 'command': 'rspec',
      \ 'cmdopt': '--colour --format progress',
      \ 'exec': '%c %o %s:.',
      \ }

" -------------------------------------------------------------------------- }}}

" mattn/emmet-vim {{{

" emmet for vim ( http://emmet.io/ )
call dein#add('mattn/emmet-vim')

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

" -------------------------------------------------------------------------- }}}

" tyru/open-browser.vim {{{
call dein#add('tyru/open-browser.vim')

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" -------------------------------------------------------------------------- }}}

" vim-scripts/sudo.vim {{{

" Allows one to edit a file with prevledges from an unprivledged session.
call dein#add('vim-scripts/sudo.vim')

" -------------------------------------------------------------------------- }}}

" haya14busa/vim-migemo {{{

if executable('cmigemo')
  call dein#add('haya14busa/vim-migemo')
endif

" -------------------------------------------------------------------------- }}}

" thinca/vim-qfreplace {{{

" Perform the replacement in quickfix.
" ref. http://d.hatena.ne.jp/thinca/20081107/1225997310
call dein#add('thinca/vim-qfreplace')

" -------------------------------------------------------------------------- }}}

" tpope/vim-fugitive {{{

" fugitive.vim: a Git wrapper so awesome, it should be illegal
call dein#add('tpope/vim-fugitive')

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

" tpope/vim-endwise {{{

" endwise.vim: wisely add 'end' in ruby, endfunction/endif/more in vim script, etc
" http://www.vim.org/scripts/script.php?script_id=2386
call dein#add('tpope/vim-endwise')

" -------------------------------------------------------------------------- }}}

" str2numchar.vim {{{

" String convert to Numeric Character Reference
" http://www.vim.org/scripts/script.php?script_id=1646
call dein#add('vim-scripts/str2numchar.vim')

" -------------------------------------------------------------------------- }}}

" bronson/vim-trailing-whitespace {{{

" Highlights trailing whitespace in red and provides :FixWhitespace to fix it.
call dein#add('bronson/vim-trailing-whitespace')

let g:extra_whitespace_ignored_filetypes = ['unite', 'markdown', 'vimfiler', 'ref-refe', '']

" -------------------------------------------------------------------------- }}}

call dein#add('vim-scripts/surround.vim')
call dein#add('mattn/webapi-vim')
call dein#add('rking/ag.vim')
call dein#add('tomtom/tcomment_vim')
call dein#add('nathanaelkane/vim-indent-guides')

" text object {{{
call dein#add('kana/vim-textobj-user')
call dein#add('kana/vim-textobj-jabraces')

" -------------------------------------------------------------------------- }}}

" color schemes {{{

" call dein#add('w0ng/vim-hybrid')
" call dein#add('altercation/vim-colors-solarized')
" call dein#add('chriskempson/vim-tomorrow-theme')
" call dein#add('jpo/vim-railscasts-theme')
call dein#add('mizoki/dracula-vim')

" -------------------------------------------------------------------------- }}}

" Syntax Check {{{

call dein#add('w0rp/ale')

let g:ale_open_list = 1
let g:ale_linters = {
      \ 'ruby': ['rubocop'],
      \ }

let g:ale_lint_on_text_changed = 'never'

" -------------------------------------------------------------------------- }}}

" Ruby Development {{{

" rails.vim: Ruby on Rails power tools
call dein#add('tpope/vim-rails')

" Make text objects with various ruby block structures.
call dein#add('rhysd/vim-textobj-ruby')

" -------------------------------------------------------------------------- }}}

" Go Development {{{

call dein#add('fatih/vim-go')

let g:go_fmt_command = "goimports"

" -------------------------------------------------------------------------- }}}

" Swift Development {{{

if has('mac')
  " Adds Swift support to vim. It covers syntax, intenting, and more.
  call dein#add('toyamarinyon/vim-swift')
endif

" -------------------------------------------------------------------------- }}}

" Markdown {{{

call dein#add('godlygeek/tabular')
call dein#add('plasticboy/vim-markdown')

let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1

" -------------------------------------------------------------------------- }}}

call dein#end()

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

filetype plugin indent on

" Disable default plugins {{{
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

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

" MacVim-KaoriYaはvimrc_example.vimを読み込むので実行しない
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

  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.
  " Only define it when not defined already.
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
  endif

endif

" -------------------------------------------------------------------------- }}}

" 全てのモードでマウスを有効にする
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

" 行番号を表示
set number
" Toggle Line Number
nnoremap <Leader>m :<C-u>setlocal relativenumber!<CR>

" バックアップファイルを作成しない
set nobackup

" do not create a swap file
set noswapfile

" vimgrepを標準のgrepプログラムに指定する
set grepprg=internal

" viminfoの設定を変更
set viminfo='50,<50,s10,:200,@200,/200,h,rA:,rB:"

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
set statusline+=%r%h%w
if dein#is_sourced('ale')
  function! LinterStatus() abort
      let l:counts = ale#statusline#Count(bufnr(''))

      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors

      return l:counts.total == 0 ? '[OK]' : printf(
      \   '[W(%d),E(%d)]',
      \   all_non_errors,
      \   all_errors
      \)
  endfunction

  set statusline+=%=%{LinterStatus()}
endif
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

" 120桁目にラインを入れる
set colorcolumn=120

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

"日本語の行の連結時には空白を入力しない。
set formatoptions+=mM

"□や○の文字があってもカーソル位置がずれないようにする。
set ambiwidth=double

"画面最後の行をできる限り表示する。
set display+=lastline

" バッファの内容が変更されていても、バッファの切り替えができるようにする
set hidden

" 矩形ビジュアルモードで仮想編集を有効にする
set virtualedit=block

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

" 縦分割スクロールの高速化
" ref.
" http://qiita.com/kefir_/items/c725731d33de4d8fb096
" http://slashdot.jp/~doda/journal/572013/

" Use vsplit mode
if has("vim_starting") && !has('gui_running') && has('vertsplit')
  function! g:EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6h\e[?69h" ], "/dev/tty", "a")
  endfunction

  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R g:EnableVsplitMode()
  set t_F9=[3;3R
  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" Use highlight search
set hlsearch

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

if has('kaoriya')
  " 作業用バッファの作成
  nnoremap <silent><Leader>s :Scratch<CR>
  " カレントディレクトリの変更
  nnoremap <silent><Space>cd :CdCurrent<CR>
else
  " Markdown用の作業バッファの作成
  nnoremap <silent><Leader>s :OpenTempBuffer markdown<CR>
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

" increment, decrement of multiple lines
" ref.
" http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
"
" memo.
" g<C-a> or g<C-x> : Create a serial number
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" location list
nnoremap <silent><Leader>K :lfirst<CR>
nnoremap <silent><Leader>J :llast<CR>
nnoremap <silent><Leader>j :lnext<CR>
nnoremap <silent><Leader>k :lprevious<CR>
nnoremap <silent><Leader>q :lclose<CR>

" fuzzy finder
" if fzf is installed, 'FZF' command should be usable.
if executable('fzf')
  nnoremap <C-p> :FZF<CR>
endif

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
nmap <silent><Leader>t [Tab]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

" 新しいタブを一番右に作る
nnoremap <silent> [Tab]c :tablast <bar> tabnew<CR>
" タブを閉じる
nnoremap <silent> [Tab]q :tabclose<CR>
" 次のタブ
nnoremap <silent> [Tab]n :tabnext<CR>
" 前のタブ
nnoremap <silent> [Tab]p :tabprevious<CR>

" -------------------------------------------------------------------------- }}}

" Capture コマンドの設定 {{{
" Ref. http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

"----------------------------------------------------------------------------}}}


" Terminal {{{

nnoremap [Terminal] <Nop>
nmap <Space>t [Terminal]

if has('nvim')
  nnoremap <silent>[Terminal]t :20split term://$SHELL<CR>
else
  nnoremap <silent>[Terminal]t :terminal ++close ++rows=20<CR>
endif

if (executable('pry'))
  if has('nvim')
    nnoremap <silent>[Terminal]p :20split term://pry<CR>
  else
    nnoremap <silent>[Terminal]p :terminal ++close ++rows=20 pry<CR>
  endif
endif

"----------------------------------------------------------------------------}}}

" create temp buffer {{{

command! -bar -nargs=1 OpenTempBuffer new | setlocal buftype=nofile bufhidden=hide filetype=<args> noswapfile

"----------------------------------------------------------------------------}}}

" }}}
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" 外部アプリケーションの設定 {{{
"-------------------------------------------------------------------------------

" set prefix of execute of external applications
nnoremap [App] <Nop>
nmap <space>a [App]

if (has("win32") || has("win64"))
elseif (has("mac"))

  " search documents using the Dash {{{
  " ref . http://qiita.com/yuyuchu3333/items/292e99a521a9653e75fb
  if isdirectory('/Applications/Dash.app/')
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
  " }}}

  " open the parent directory {{{
  nnoremap <silent>[App]p :!open %:p:h<CR>:redraw!<CR>
  " }}}

elseif (has('unix') && !has('mac'))

  " open the parent directory {{{
  if executable('thunar')
    nnoremap <silent>[App]p :!thunar %:p:h<CR>:redraw!<CR>
  endif
  " }}}

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
  if has('mac')
    autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>o :!open %<CR><CR>
  elseif executable('exo-open')
    autocmd FileType html,xhtml,css,perl nnoremap <silent><Leader>o :!exo-open --launch WebBrowser %<CR>
  endif

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

if dein#is_sourced('vim-hybrid')
  set background=dark
  colorscheme hybrid
elseif dein#is_sourced('vim-colors-solarized')
  set background=dark
  colorscheme solarized
elseif dein#is_sourced('vim-tomorrow-theme')
  colorscheme Tomorrow-Night-Eighties
elseif dein#is_sourced('vim-railscasts-theme')
  colorscheme railscasts
elseif dein#is_sourced('dracula-vim')
  colorscheme dracula
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
