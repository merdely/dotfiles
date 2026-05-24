" ===============================
" Plugins
" ===============================
" Auto-install vim-plug if not present
let s:plug_path = g:vim_data_dir . '/autoload/plug.vim'
if empty(glob(s:plug_path))
  silent execute '!curl -fsLo ' . s:plug_path . ' --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . s:plug_path
endif

if executable('git')
  if !isdirectory(g:vim_data_dir . '/plugged')
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | doautocmd ColorScheme
  endif
  call plug#begin(g:vim_data_dir . '/plugged')
    Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
    Plug 'liuchengxu/vim-which-key'
    " Plug 'itchyny/lightline.vim'
    Plug 'lambdalisue/vim-suda'
    Plug 'machakann/vim-highlightedyank'
    Plug 'tpope/vim-vinegar'
    Plug 'junegunn/fzf', executable('fzf') ? {} : { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
  call plug#end()

  let g:highlightedyank_highlight_duration = 150

  if has_key(g:plugs, 'lightline.vim') && isdirectory(g:plugs['lightline.vim'].dir)
    set laststatus=2
    let g:lightline = {
          \ 'colorscheme': 'selenized_black',
          \ 'separator':    { 'left': "\ue0b0", 'right': "\ue0b2" },
          \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
          \ }
  endif
  if has_key(g:plugs, 'nightfly') && isdirectory(g:plugs['nightfly'].dir)
    colorscheme nightfly
  endif
endif

" WhichKey
if exists('g:plugs') && has_key(g:plugs, 'vim-which-key')
  " nnoremap <silent> <leader>      :WhichKey      '<Space>'<CR>
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
endif

