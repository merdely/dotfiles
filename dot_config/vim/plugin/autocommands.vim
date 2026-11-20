augroup user_autocommands
  autocmd!

  " Highlight selection on yank (Vim has no vim.highlight.on_yank)
  if exists('##TextYankPost')
    autocmd TextYankPost * call s:HighlightYank()
  endif

  " Restore cursor to last edit position, then center
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line('$') && &filetype !~# 'commit'
        \ |   execute 'normal! g`"zz'
        \ | endif

  " Resize splits when the terminal is resized (all tabs, then return)
  autocmd VimResized * let s:t = tabpagenr() | tabdo wincmd = | execute 'tabnext' s:t

  " 4-space indents for some filetypes
  autocmd FileType python,php,markdown setlocal tabstop=4 shiftwidth=4 softtabstop=4

  " Prevent '#' from de-indenting in YAML
  autocmd FileType yaml,yaml.ansible setlocal indentkeys-=0#

  " Big files: drop syntax and other slow features (Snacks bigfile)
  autocmd BufReadPre * if getfsize(expand('<afile>')) > 1536 * 1024
        \ | setlocal syntax=OFF noundofile foldmethod=manual | endif
augroup END

function! s:HighlightYank() abort
  if v:event.operator !=# 'y' || empty(v:event.regcontents) | return | endif
  let [l1, c1] = getpos("'[")[1:2]
  let [l2, c2] = getpos("']")[1:2]
  if v:event.regtype ==# 'V'
    let pos = range(l1, l2)
  elseif v:event.regtype ==# 'v'
    if l1 == l2
      let pos = [[l1, c1, c2 - c1 + 1]]
    else
      let pos = [[l1, c1, 9999]] + range(l1 + 1, l2 - 1) + [[l2, 1, c2]]
    endif
  else
    let pos = map(range(l1, l2), {_, l -> [l, c1, c2 - c1 + 1]})
  endif
  let ids = []
  " matchaddpos takes at most 8 positions per call
  while !empty(pos)
    call add(ids, matchaddpos('IncSearch', pos[:7]))
    let pos = pos[8:]
  endwhile
  let winid = win_getid()
  call timer_start(200, {-> s:ClearMatches(winid, ids)})
endfunction

function! s:ClearMatches(winid, ids) abort
  for id in a:ids
    silent! call matchdelete(id, a:winid)
  endfor
endfunction
