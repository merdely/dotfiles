" ================================================================================================
" Vimscript version of Neovim Lua config
" ================================================================================================

" ===============================
" Plugins
" ===============================
" Install vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()
  Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
  Plug 'liuchengxu/vim-which-key'
  Plug 'itchyny/lightline.vim'
  Plug 'lambdalisue/vim-suda'
call plug#end()

syntax enable
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" ===============================
" Theme & Transparency
" ===============================
colorscheme nightfly
highlight Normal      ctermbg=NONE guibg=NONE
highlight NormalNC    ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight Normal      ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight NormalNC    ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE

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
set breakindent

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
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set background=dark
set signcolumn=yes
set colorcolumn=80
set list
set listchars=tab:▸\ ,trail:·,nbsp:␣
set showmatch
set matchtime=2
set cmdheight=1
set completeopt=menuone,noinsert,noselect
set noshowmode
set pumheight=10
set conceallevel=0
set concealcursor=
set lazyredraw
set synmaxcol=300

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
set backspace=indent,start
set noautochdir
" set iskeyword+=-
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

" Yank to EOL
nnoremap Y y$

" Center screen when jumping
" nnoremap n nzzzv
" nnoremap N Nzzzv
" nnoremap <C-d> <C-d>zz
" nnoremap <C-u> <C-u>zz

" Better paste behavior
xnoremap <leader>p "_dP
vnoremap p "_dP

" Change without replacing clipboard content
nnoremap cw "_cw
vnoremap cw "_cw
nnoremap caw "_caw
vnoremap caw "_caw
nnoremap ciw "_ciw
vnoremap ciw "_ciw
nnoremap C "_C
vnoremap C "_C

" Delete without replacing clipboard content
nnoremap dw "_dw
vnoremap dw "_dw
nnoremap daw "_daw
vnoremap daw "_daw
nnoremap diw "_diw
vnoremap diw "_diw
nnoremap D "_D
vnoremap D "_D

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing Splits
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Move lines up/down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Better indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Quick file navigation
nnoremap <leader>e :Explore<CR>
nnoremap <leader>ff :find 
nnoremap - :Explore<CR>

" Make file executable
nnoremap <leader>x :!chmod +x %<CR>

" Quick config editing
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

