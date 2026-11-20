" Fuzzy finding: fzf.vim replaces the Snacks pickers. Without fzf.vim, the
" same keys fall back to built-in :find / :buffer / :grep.

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ -g\ '!.git'
  set grepformat=%f:%l:%c:%m
endif

" :Grep runs 'grepprg' silently and opens the quickfix list
command! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redraw! | botright cwindow

let s:config = fnameescape(g:config_dir)

if exists(':Files') == 2
  nnoremap <silent> <leader><space> :Files<CR>
  nnoremap <silent> <leader>ff :Files<CR>
  nnoremap <silent> <leader>fg :GFiles<CR>
  execute 'nnoremap <silent> <leader>fc :Files ' . s:config . '<CR>'
  nnoremap <silent> <leader>fG :Files ~/git<CR>
  nnoremap <silent> <leader>fs :Files ~/src<CR>
  nnoremap <silent> <leader>fr :History<CR>
  nnoremap <silent> <leader>,  :Buffers<CR>
  nnoremap <silent> <leader>bb :Buffers<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>/  :Rg<CR>
  nnoremap <silent> <leader>sg :Rg<CR>
  nnoremap <silent> <leader>sG :call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -- ""', fzf#vim#with_preview({'dir': expand('%:p:h')}))<CR>
  execute 'nnoremap <silent> <leader>sv :call fzf#vim#grep(''rg --column --line-number --no-heading --color=always --smart-case -- ""'', fzf#vim#with_preview({''dir'': ' . string(g:config_dir) . '}))<CR>'
  nnoremap <silent> <leader>sw :Rg <C-r><C-w><CR>
  xnoremap <silent> <leader>sw y:Rg <C-r>=escape(@", '\\')<CR><CR>
  nnoremap <silent> <leader>sb :BLines<CR>
  nnoremap <silent> <leader>sB :Lines<CR>
  nnoremap <silent> <leader>:  :History:<CR>
  nnoremap <silent> <leader>sc :History:<CR>
  nnoremap <silent> <leader>s/ :History/<CR>
  nnoremap <silent> <leader>sC :Commands<CR>
  nnoremap <silent> <leader>sh :Helptags<CR>
  nnoremap <silent> <leader>sj :Jumps<CR>
  nnoremap <silent> <leader>sk :Maps<CR>
  nnoremap <silent> <leader>sm :Marks<CR>
  nnoremap <silent> <leader>uC :Colors<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  if !exists('g:loaded_fugitive')
    nnoremap <silent> <leader>gf :BCommits<CR>
  endif
else
  " Built-in fallbacks
  set path=.,**
  set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*
  nnoremap <leader><space> :find<Space>
  nnoremap <leader>ff :find<Space>
  execute 'nnoremap <leader>fc :find ' . s:config . '/**/'
  nnoremap <leader>fr :browse oldfiles<CR>
  nnoremap <leader>,  :ls<CR>:buffer<Space>
  nnoremap <leader>bb :ls<CR>:buffer<Space>
  nnoremap <leader>fb :ls<CR>:buffer<Space>
  nnoremap <leader>/  :Grep<Space>
  nnoremap <leader>sg :Grep<Space>
  execute 'nnoremap <leader>sv :Grep  ' . s:config . '<C-Left><Left>'
  nnoremap <silent> <leader>sw :Grep <C-r><C-w><CR>
  nnoremap <leader>sb :global//#<Left><Left>
  nnoremap <silent> <leader>:  q:
  nnoremap <silent> <leader>sc q:
  nnoremap <silent> <leader>s/ q/
  nnoremap <leader>sh :help<Space>
  nnoremap <silent> <leader>sj :jumps<CR>
  nnoremap <silent> <leader>sk :map<CR>
  nnoremap <silent> <leader>sm :marks<CR>
endif

nnoremap <silent> <leader>s" :registers<CR>
nnoremap <silent> <leader>sa :autocmd<CR>
nnoremap <silent> <leader>sH :highlight<CR>
