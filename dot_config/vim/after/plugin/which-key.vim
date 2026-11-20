if !exists(':WhichKey') | finish | endif

set timeoutlen=500
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
xnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" Group names, matching your which-key.nvim spec
let g:which_key_map = {
      \ 'b': {'name': '+buffer'},
      \ 'c': {'name': '+code'},
      \ 'f': {'name': '+file/find'},
      \ 'g': {'name': '+git', 'h': {'name': '+hunks'}},
      \ 'q': {'name': '+quit/session'},
      \ 's': {'name': '+search'},
      \ 'u': {'name': '+ui', 'g': {'name': '+git'}},
      \ 'x': {'name': '+diagnostics/quickfix'},
      \ }
call which_key#register('<Space>', 'g:which_key_map')
