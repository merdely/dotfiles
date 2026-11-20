" Format the buffer with an external formatter (stdin -> stdout), falling
" back to the language server. `%` in a command is replaced by the file path.
let g:formatters = {
      \ 'lua': 'stylua -',
      \ 'javascript': 'prettier --stdin-filepath %',
      \ 'typescript': 'prettier --stdin-filepath %',
      \ 'typescriptreact': 'prettier --stdin-filepath %',
      \ 'json': 'prettier --stdin-filepath %',
      \ }

function! FormatBuffer() abort
  let cmd = get(g:formatters, &filetype, '')
  if !empty(cmd)
    let resolved = substitute(cmd, '%', escape(shellescape(expand('%:p')), '\&'), 'g')
    let output = systemlist(resolved, getline(1, '$'))
    if v:shell_error
      echohl ErrorMsg | echo 'Formatter failed: ' . join(output[:2], ' ') | echohl None
      return
    endif
    if output ==# getline(1, '$') | return | endif
    let view = winsaveview()
    call setline(1, output)
    if line('$') > len(output)
      silent execute (len(output) + 1) . ',$delete _'
    endif
    call winrestview(view)
  elseif exists(':LspFormat') == 2
    LspFormat
  else
    echo 'No formatter for ' . &filetype
  endif
endfunction

command! FormatBuffer call FormatBuffer()
" Format on save (disabled, as in the Neovim config):
" autocmd BufWritePre * call FormatBuffer()
