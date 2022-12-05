" Tab関係の設定

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()
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
endfunction
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
"""set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap [Tab] <Nop>
nmap <Space>t [Tab]

" Tab jump
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" 新しいタブを一番右に作る
nnoremap <silent> [Tab]c :tablast <bar> tabnew<CR>
" タブを閉じる
nnoremap <silent> [Tab]q :tabclose<CR>
" 次のタブ
nnoremap <silent> [Tab]n :tabnext<CR>
" 前のタブ
nnoremap <silent> [Tab]p :tabprevious<CR>
