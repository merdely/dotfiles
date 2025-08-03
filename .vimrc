" ================================================================================================
" Vimscript version of Neovim Lua config
" ================================================================================================

" ===============================
" Plugins
" ===============================
call plug#begin()
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
Plug 'liuchengxu/vim-which-key'
" Plug 'itchyny/lightline.vim'
call plug#end()

syntax enable
set laststatus=2
" let g:lightline = { 'colorscheme': 'one', }

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" ===============================
" Theme & Transparency
" ===============================
colorscheme nightfly
highlight Normal     ctermbg=NONE guibg=NONE
highlight NormalNC   ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" ===============================
" Basic Settings
" ===============================
set number
set norelativenumber
set cursorline
set wrap
set scrolloff=10
set sidescrolloff=8

" ===============================
" Indentation
" ===============================
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent

" ===============================
" Search
" ===============================
set ignorecase
set smartcase
set hlsearch
set incsearch

" ===============================
" Visuals
" ===============================
set termguicolors
set background=dark
set signcolumn=yes
set colorcolumn=80
set list
set listchars=tab:▸\ ,trail:·
set showmatch
set matchtime=2
set cmdheight=1
set completeopt=menuone,noinsert,noselect
set noshowmode
set pumheight=10
" set pumblend=10
" set winblend=0
set conceallevel=0
set concealcursor=
set lazyredraw
set synmaxcol=300
if !has('gui_running')
    set t_Co=256
endif

" ===============================
" File Handling
" ===============================
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vim/undodir
set updatetime=300
set timeoutlen=500
set ttimeoutlen=0
set autoread
set noautowrite

" ===============================
" Behavior
" ===============================
set hidden
set noerrorbells
set backspace=indent,eol,start
set noautochdir
set iskeyword+=-
set path+=**
set selection=exclusive
set mouse=a
set clipboard+=unnamedplus
set modifiable
set encoding=utf-8

" ===============================
" Cursor
" ===============================
set guicursor=n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" ===============================
" Folding
" ===============================
set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" ===============================
" Splits
" ===============================
set splitbelow
set splitright

" ===============================
" Leader Key
" ===============================
let mapleader = " "
let maplocalleader = " "

" ===============================
" Key Mappings
" ===============================
nnoremap <leader>c :nohlsearch<CR>
nnoremap <Esc> :nohlsearch<CR>
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap <leader>p "_dP
vnoremap p "_dP
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>e :Explore<CR>
nnoremap <leader>ff :find 
nnoremap - :Explore<CR>

" nnoremap J mzJ`z
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>rc :e ~/.vimrc<CR>

" ===============================
" Autocommands
" ===============================
if !isdirectory(expand("~/.vim/undodir"))
  call mkdir(expand("~/.vim/undodir"), "p")
endif

augroup UserConfig
  autocmd!
  " autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
  autocmd FileType lua,python,php,markdown setlocal tabstop=4 shiftwidth=4
  autocmd FileType javascript,typescript,json,html,css setlocal tabstop=2 shiftwidth=2
  " autocmd TermClose * if v:event.status == 0 | execute 'bdelete!' | endif
  " autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
  autocmd VimResized * tabdo wincmd =
  autocmd BufWritePre * call mkdir(expand('<afile>:p:h'), 'p')
augroup END

" ===============================
" Wildmenu and Performance
" ===============================
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.pyc,*.class,*.jar
" set diffopt+=linematch:60
set redrawtime=10000
set maxmempattern=20000

" ===============================
" Status Line
" ===============================
" disabled for lightline -- " " set statusline=%f\ %h%m%r%=%y\ [%{&fileencoding}]\ %l,%c\ %P
" disabled for lightline -- " " set statusline=%{mode()}\ \ %f\ %h%m%r%=%{&filetype}\[%{&fileencoding}]\ %l:%c\ %P
function! ModeStr()
  let l:mode_map = {
        \ 'n': 'NORMAL',
        \ 'i': 'INSERT',
        \ 'v': 'VISUAL',
        \ 'V': 'V-LINE',
        \ "\<C-v>": 'V-BLOCK',
        \ 'c': 'COMMAND',
        \ 's': 'SELECT',
        \ 'S': 'S-LINE',
        \ "\<C-s>": 'S-BLOCK',
        \ 'R': 'REPLACE',
        \ 't': 'TERMINAL'
        \ }
  return get(l:mode_map, mode(), mode())
endfunction

function! FileSize()
  let size = getfsize(expand('%'))
  if size < 0
    return ''
  elseif size < 1024
    return size . 'B'
  elseif size < 1024 * 1024
    return printf('%.1fK', size / 1024.0)
  else
    return printf('%.1fM', size / (1024.0 * 1024))
  endif
endfunction

function! GitBranch()
  let l:gitdir = finddir('.git', expand('%:p:h') . ';')
  if empty(l:gitdir)
    return ''
  endif
  let l:repo = fnamemodify(l:gitdir, ':h')
  let l:branch = system('git -C ' . fnameescape(l:repo) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  let l:branch = substitute(l:branch, '\n\+$', '', '')
  if empty(l:branch) || v:shell_error != 0
    return ''
  endif
  return '(' . l:branch . ')'
endfunction

set statusline=%#StatusLine#%{ModeStr()}\ \|\ %f\ %h%m%r\ %{GitBranch()}%=%{&filetype}\ \|\ %{&fileencoding}\[%{&fileformat}]\ \|\ %{FileSize()}\ \|\ %l:%c\ %P

