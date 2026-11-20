" Plugin configuration. This runs after pack/*/start plugins have loaded, so
" every block checks that its plugin is actually installed.

" --- Built-in optional packages ----------------------------------------------
silent! packadd matchit
silent! packadd cfilter
silent! packadd editorconfig          " Neovim enables EditorConfig by default
if !exists('g:loaded_commentary')
  silent! packadd comment             " gc/gcc, Vim 9.1.0375+; else install vim-commentary
endif
runtime ftplugin/man.vim              " :Man and K in man pages
nnoremap <leader>sM :Man<Space>

" --- Colorscheme --------------------------------------------------------------
augroup transparent_bg
  autocmd!
  autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
augroup END
for s:scheme in ['nightfly', 'catppuccin_mocha', 'habamax', 'desert']
  try
    execute 'colorscheme' s:scheme
    break
  catch /E185/
  endtry
endfor

" --- Statusline (lightline, or a plain fallback) -----------------------------
function! StatuslineGitBranch() abort
  if exists('*FugitiveHead')
    let head = FugitiveHead()
    return empty(head) ? '' : ' ' . head
  endif
  return get(b:, 'gitsigns_head', '')
endfunction

function! StatuslineGitHunks() abort
  if !exists('*GitGutterGetHunkSummary') | return '' | endif
  let [a, m, r] = GitGutterGetHunkSummary()
  let parts = []
  if a | call add(parts, '+' . a) | endif
  if m | call add(parts, '~' . m) | endif
  if r | call add(parts, '-' . r) | endif
  return join(parts)
endfunction

function! StatuslineDiagnostics() abort
  try
    let c = lsp#lsp#ErrorCount()
  catch
    return ''
  endtry
  let parts = []
  for [key, sym] in [['Error', 'E'], ['Warn', 'W'], ['Info', 'I'], ['Hint', 'H']]
    if get(c, key, 0) | call add(parts, sym . ':' . c[key]) | endif
  endfor
  return join(parts)
endfunction

function! StatuslineRecording() abort
  let r = reg_recording()
  return empty(r) ? '' : 'recording @' . r
endfunction

if !exists('g:loaded_lightline')
  function! StatuslineMode() abort
    let modes = {'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL',
          \ 'V': 'V-LINE', "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 't': 'TERMINAL',
          \ 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK'}
    return get(modes, mode(), mode())
  endfunction
  set statusline=%#PmenuSel#\ %{StatuslineMode()}\ %*
  set statusline+=\ %{StatuslineGitBranch()}\ %f\ %m%r
  set statusline+=\ %{StatuslineDiagnostics()}\ %{StatuslineGitHunks()}
  set statusline+=%=%{StatuslineRecording()}\ \ %{&fenc}\ %{&ff}\ %y\ %l/%L:%c\
endif

" --- Surround (mini.surround keys on vim-surround) ---------------------------
if exists('g:loaded_surround')
  nmap gsa <Plug>Ysurround
  nmap gsA <Plug>Yssurround
  xmap gsa <Plug>VSurround
  nmap gsd <Plug>Dsurround
  nmap gsr <Plug>Csurround
endif

" --- Auto pairs toggle (Snacks toggle on <leader>up) -------------------------
nnoremap <silent> <leader>up :call <SID>AutoPairsToggle()<CR>
function! s:AutoPairsToggle() abort
  try
    call autopairs#AutoPairsToggle()       " LunarWatcher/auto-pairs
  catch /E117/
    if exists('*AutoPairsToggle')          " jiangmiao/auto-pairs
      call AutoPairsToggle()
    endif
  endtry
endfunction

" --- Split/join (treesj) and argument swapping (treesitter swap) -------------
if exists(':SplitjoinSplit') == 2
  nnoremap <silent> <leader>m :call <SID>SplitJoinToggle()<CR>
  function! s:SplitJoinToggle() abort
    if getline('.') =~# '[\[{(]\s*$'
      SplitjoinJoin
    else
      SplitjoinSplit
    endif
  endfunction
endif
if exists(':SidewaysRight') == 2
  nnoremap <silent> <leader>a :SidewaysRight<CR>
  nnoremap <silent> <leader>A :SidewaysLeft<CR>
endif

" --- Git: gitgutter (gitsigns) and fugitive ----------------------------------
if exists('g:loaded_gitgutter')
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)
  nmap <leader>ghs <Plug>(GitGutterStageHunk)
  nmap <leader>ghr <Plug>(GitGutterUndoHunk)
  nmap <leader>ghp <Plug>(GitGutterPreviewHunk)
  omap ih <Plug>(GitGutterTextObjectInnerPending)
  xmap ih <Plug>(GitGutterTextObjectInnerVisual)
  nnoremap <silent> <leader>ugg :GitGutterToggle<CR>
  nnoremap <silent> <leader>ghq :GitGutterQuickFix<Bar>copen<CR>
endif
if exists('g:loaded_fugitive')
  nnoremap <silent> <leader>gs :Git<CR>
  nnoremap <silent> <leader>gb :Git blame<CR>
  nnoremap <silent> <leader>gd :Gdiffsplit<CR>
  nnoremap <silent> <leader>gD :Git diff @{upstream}<CR>
  nnoremap <silent> <leader>gf :0Gclog<CR>
  nnoremap <silent> <leader>gL :.Gclog<CR>
  nnoremap <silent> <leader>gS :Git stash list<CR>
  nnoremap <silent> <leader>gB :GBrowse<CR>
  xnoremap <silent> <leader>gB :GBrowse<CR>
  nnoremap <silent> <leader>gY :GBrowse!<CR>
  xnoremap <silent> <leader>gY :GBrowse!<CR>
  if !exists(':Commits')
    nnoremap <silent> <leader>gl :Git log --oneline --decorate --graph<CR>
  endif
endif

" --- TODO jumps: vim-unimpaired takes ]n/[n for conflict markers -------------
nnoremap <silent> ]n :call TodoJump(1)<CR>
nnoremap <silent> [n :call TodoJump(0)<CR>

" --- Completion keys (mini.keymap + tabout + snippets) -----------------------
function! NextCharIsCloser() abort
  return getline('.')[col('.') - 1] =~# '[)\]}>"''`]'
endfunction
function! VsnipJumpable(dir) abort
  return exists('g:loaded_vsnip') && vsnip#jumpable(a:dir)
endfunction
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : VsnipJumpable(1) ? "\<Plug>(vsnip-jump-next)" : NextCharIsCloser() ? "\<Right>" : "\<Tab>"
smap <expr> <Tab>   VsnipJumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : VsnipJumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<S-Tab>"
smap <expr> <S-Tab> VsnipJumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<S-Tab>"
if exists('g:loaded_vsnip')
  imap <expr> <C-j> vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-j>"
  smap <expr> <C-j> vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-j>"
endif

" Command-line completion as you type (needs a recent Vim with wildtrigger())
if exists('*wildtrigger')
  set wildmode=noselect:lastused,full
  augroup cmdline_autocomplete
    autocmd!
    autocmd CmdlineChanged [:/\?] call wildtrigger()
  augroup END
endif

" --- Dashboard (Snacks dashboard -> vim-startify, optional) ------------------
if exists('g:loaded_startify')
  let g:startify_lists = [
        \ {'type': 'files',     'header': ['   Recent Files']},
        \ {'type': 'dir',       'header': ['   Recent in ' . getcwd()]},
        \ {'type': 'sessions',  'header': ['   Sessions']},
        \ {'type': 'bookmarks', 'header': ['   Bookmarks']},
        \ ]
  let g:startify_bookmarks = [{'c': g:config_dir . '/vimrc'}]
  nnoremap <silent> <leader>D :Startify<CR>
endif

" --- Undo tree (Snacks undo picker -> undotree, optional) --------------------
if exists(':UndotreeToggle') == 2
  nnoremap <silent> <leader>su :UndotreeToggle<CR>
endif
