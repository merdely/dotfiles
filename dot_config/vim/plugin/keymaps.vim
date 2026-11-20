" Keymaps that need no plugins. LSP maps live in after/plugin/lsp.vim and
" picker/git maps in after/plugin/picker.vim.

" Indent and reselect
xnoremap < <gv
xnoremap > >gv

" Change/delete without clobbering the clipboard
nnoremap c "_c
xnoremap c "_c
nnoremap C "_C
xnoremap C "_C
nnoremap x "_x
xnoremap x "_x

" Window resizing
nnoremap <silent> <C-Up>    :resize +2<CR>
nnoremap <silent> <C-Down>  :resize -2<CR>
nnoremap <silent> <C-Left>  :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" Move lines with Alt-. and Alt-,  — terminals send Alt as an ESC prefix, so
" teach Vim those sequences first (harmless in the GUI).
if !has('gui_running')
  execute "set <M-.>=\e."
  execute "set <M-,>=\e,"
endif
nnoremap <silent> <M-.> :<C-u>execute 'move .+' . v:count1<CR>==
nnoremap <silent> <M-,> :<C-u>execute 'move .-' . (v:count1 + 1)<CR>==
inoremap <silent> <M-.> <Esc>:m .+1<CR>==gi
inoremap <silent> <M-,> <Esc>:m .-2<CR>==gi
xnoremap <silent> <M-.> :<C-u>execute "'<,'>move '>+" . v:count1<CR>gv=gv
xnoremap <silent> <M-,> :<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<CR>gv=gv

" Clear search highlight. Mapping a bare <Esc> in terminal Vim breaks
" arrow keys/escape sequences, so the terminal gets <Esc><Esc> instead.
if has('gui_running')
  nnoremap <silent> <Esc> :nohlsearch<CR>
else
  nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
endif

" Run macros h/j/k/l
for s:key in ['h', 'j', 'k', 'l']
  execute 'nnoremap <leader>' . s:key . ' @' . s:key
endfor

" Buffers
nnoremap <silent> <leader>; :e #<CR>
nnoremap <silent> <leader>bc :call SetClipboard(expand('%:p'))<CR>
nnoremap <silent> <leader>bC :call SetClipboard(expand('%:p:h'))<CR>
nnoremap <silent> <leader>bE :cd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>bD :bdelete<CR>
nnoremap <silent> <leader>bp :bprevious<CR>
nnoremap <silent> <leader>bn :bnext<CR>
nnoremap <silent> <leader>bx :call BufDeleteAlternate()<CR>
nnoremap <silent> <leader>bd :call BufDelete()<CR>
nnoremap <silent> <leader>bo :call BufDeleteOthers()<CR>
nnoremap <silent> <leader>bi :call BufDeleteHidden()<CR>
nnoremap <silent> <leader>fn :enew<CR>

" Misc
nnoremap <silent> <leader>ur :nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
nnoremap <leader>ui :echo map(synstack(line('.'), col('.')), {_, id -> synIDattr(id, 'name')})<CR>
nnoremap <silent> <leader>qq :qa<CR>
nnoremap <silent> <leader>X :call MakeExecutable()<CR>
nnoremap <leader>cR :call RenameFile()<CR>
nnoremap <silent> <leader>F :FormatBuffer<CR>

" Add a comment line below/above (uses gcc from the comment plugin)
nmap gco ox<Esc>gccfxa<BS>
nmap gcO Ox<Esc>gccfxa<BS>

" Quickfix / location list (Trouble replacement: plain quickfix)
nnoremap <silent> ]q :<C-u>execute 'silent! ' . v:count1 . 'cnext'<CR>
nnoremap <silent> [q :<C-u>execute 'silent! ' . v:count1 . 'cprevious'<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]l :<C-u>execute 'silent! ' . v:count1 . 'lnext'<CR>
nnoremap <silent> [l :<C-u>execute 'silent! ' . v:count1 . 'lprevious'<CR>
nnoremap <silent> <leader>xQ :call ToggleList('c')<CR>
nnoremap <silent> <leader>xL :call ToggleList('l')<CR>
nnoremap <silent> <leader>sq :copen<CR>
nnoremap <silent> <leader>sl :lopen<CR>

" UI toggles (Snacks.toggle replacements)
nnoremap <silent> <leader>us :setlocal spell! spell?<CR>
nnoremap <silent> <leader>uw :setlocal wrap! wrap?<CR>
nnoremap <silent> <leader>uL :setlocal relativenumber! relativenumber?<CR>
nnoremap <silent> <leader>ul :setlocal number! number?<CR>
nnoremap <silent> <leader>uc :let &l:conceallevel = &l:conceallevel ? 0 : 2<CR>:set conceallevel?<CR>
nnoremap <silent> <leader>ub :let &background = &background ==# 'dark' ? 'light' : 'dark'<CR>
nnoremap <silent> <leader>uG :setlocal list! list?<CR>
nnoremap <silent> <leader>uT :execute exists('g:syntax_on') ? 'syntax off' : 'syntax enable'<CR>
nnoremap <silent> <leader>uz :call ZoomToggle()<CR>
nnoremap <silent> <leader>wm :call ZoomToggle()<CR>
nnoremap <silent> <leader>uC :colorscheme <C-d>

" Window prefix (which-key proxied <leader>w to <C-w>)
nnoremap <leader>w <C-w>

" Diff helpers
nnoremap <leader>co do
nnoremap <leader>cp dp

" Terminals (Snacks.terminal replacements)
nnoremap <silent> <leader>ft :call SmartTerminal(0)<CR>
nnoremap <silent> <leader>fT :call SmartTerminal(1)<CR>
nnoremap <silent> <C-_> :call TerminalToggle()<CR>
inoremap <silent> <C-_> <Esc>:call TerminalToggle()<CR>
if has('terminal')
  tnoremap <silent> <C-_> <C-w>:call TerminalToggle()<CR>
  tnoremap <C-w><C-h> <C-w>h
  tnoremap <C-w><C-j> <C-w>j
  tnoremap <C-w><C-k> <C-w>k
  tnoremap <C-w><C-l> <C-w>l
  tnoremap <Esc><Esc> <C-w>N
endif
nnoremap <silent> <leader>gg :call FloatTerminal('lazygit')<CR>

" Plugin updater (was <leader>up, which snacks.lua overrode with the
" autopairs toggle — see README)
nnoremap <silent> <leader>uP :UpdatePlugins<CR>
