" Options. The first block restores Neovim defaults that Vim doesn't have.

" --- Neovim defaults ---------------------------------------------------------
set encoding=utf-8
set autoindent
set backspace=indent,eol,start
set belloff=all
set display=lastline
set formatoptions+=j
set hidden
set history=10000
set hlsearch
set incsearch
set mouse=a
set nrformats-=octal
set ruler
set sessionoptions-=options
set shortmess-=S                    " show [n/m] search count (replaces hlslens)
set shortmess+=c                    " quieter completion messages
set showcmd
set smarttab
set switchbuf=uselast
set tabpagemax=50
set ttimeout ttimeoutlen=50
set viewoptions-=options
set wildmenu
set wildoptions=pum                 " popup command-line completion (mini.cmdline-ish)
if has('patch-9.0.1921') | set wildoptions+=fuzzy | endif
set listchars=tab:>\ ,trail:-,nbsp:+

" Cursor shape: bar in insert, underline in replace, block in normal
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" --- Your options ------------------------------------------------------------
set number relativenumber
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
set smartindent breakindent shiftround
set signcolumn=yes
set autoread
set laststatus=2
set confirm
set cursorline
set colorcolumn=80
set noshowmode                      " statusline shows the mode
set splitbelow splitright
set scrolloff=3
set wrap
set showmatch
set ignorecase smartcase
set nowritebackup noswapfile
set undolevels=1000
set completeopt=menuone,noselect
if has('patch-9.0.1052') | set completeopt+=popup | endif
" cmdheight=0 and inccommand=split have no Vim equivalent.

if !exists('g:no_persist')
  set undofile
  let &undodir = g:state_dir . '/undo//'
  if !isdirectory(&undodir) | call mkdir(&undodir, 'p', 0700) | endif
endif

" True colour. The t_8f/t_8b lines make it work inside tmux too.
if has('termguicolors')
  let &t_8f = "\e[38;2;%lu;%lu;%lum"
  let &t_8b = "\e[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Clipboard. Needs a Vim built with +clipboard (vim-gtk3 / vim-gui-common on
" Debian; plain `vim` is -clipboard). Over SSH, OSC 52 is set up in
" after/plugin/plugins.vim.
if has('clipboard') && (empty($SSH_TTY) || !empty($DISPLAY) || !empty($WAYLAND_DISPLAY))
  set clipboard=unnamedplus
endif

" Indent guides without a plugin (replaces Snacks indent): a bar at each
" shiftwidth of leading space. Toggled with <leader>uG.
function! s:IndentGuides() abort
  if !has('patch-8.2.5066') | return | endif
  let sw = shiftwidth()
  let &l:listchars = &g:listchars . ',leadmultispace:│' . repeat(' ', sw - 1)
endfunction
augroup indent_guides
  autocmd!
  autocmd OptionSet shiftwidth,tabstop call s:IndentGuides()
  autocmd BufWinEnter,FileType * call s:IndentGuides()
augroup END
set list
