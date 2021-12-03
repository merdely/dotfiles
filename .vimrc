" Explanation of variable scope prefixes:
" g: global
" s: local to script
" l: local to function
"
" Explanation of other prefixes
" w: window
" b: buffer
" t: tab
" v: vim special

if has('nvim')
  let configfile = $HOME . '/.config/nvim/init.vim'
  let configdir = $HOME . '/.config/nvim'
  let plugindir = $HOME . '/.config/nvim/plugged'
  let autoload = $HOME . '/.local/share/nvim/site/autoload'
else
  let configfile = $HOME . '/.vimrc'
  let configdir = $HOME . '/.vim'
  let plugindir = $HOME . '/.vim/plugged'
  let autoload = $HOME . '/.vim/autoload'
endif

" Use ',' as leader key
let mapleader=','

filetype off
syntax on

" set autoindent
set background=dark
"set backspace=indent,eol,start
"set clipboard=unnamedplus
set colorcolumn=80
set cursorline
set expandtab
set hlsearch
set hidden
"set ignorecase
set list
set listchars=tab:▸\ ,eol:¬,trail:·
set modelines=1
set mouse=a
set nocompatible
"set nojoinspaces
set number
set pastetoggle=<F2>
"set path=.
set path+=**
set path+=~/src/ansible/**
set path+=~/src/config/earth/srv/docker/**
set path+=~/src/config/homeassistant/**
set path+=~/src/scripts/**
"set path=.,/usr/include,,
"set relativenumber
set shiftwidth=2
set showcmd
set showmatch
"set smartcase
"set smartindent
set softtabstop=2
"set spell
set spelllang=en_us
set splitbelow
set splitright
set tabstop=2
set timeoutlen=2000
set t_Co=256
"set wildignore+=**/node_modules/**
set wildmenu

highlight CursorLine cterm=NONE ctermbg=235
highlight CursorLineNr cterm=NONE ctermbg=235
highlight Normal guibg=black guifg=white ctermbg=NONE
highlight ColorColumn ctermbg=darkgrey guibg=darkgrey

" Don't load vim-plug if file doesn't exist
if filereadable(autoload . '/plug.vim')
  call plug#begin()
  Plug 'vim-airline/vim-airline'         " Airline status bar
  Plug 'vim-airline/vim-airline-themes'  " Airline status bar themes
  Plug 'prettier/vim-prettier'           " Code linter
  Plug 'tpope/vim-repeat'                " Enable repeating plugins
  Plug 'tpope/vim-surround'              " Delete/change/add parens/quotes/tags
  Plug 'juneedahamed/vc.vim'             " Support for SCM
  Plug 'preservim/nerdtree'
  if !filereadable(configdir . '/nopython')
    Plug 'ycm-core/YouCompleteMe'          " Code completion engine
  endif
  if has('nvim')
    Plug 'iamcco/markdown-preview.nvim'  " Markdown preview
    let mkdpdir = plugindir . '/markdown-preview.nvim/plugin'
  else
    Plug 'iamcco/markdown-preview.vim'   " Markdown preview
    let mkdpdir = plugindir . '/markdown-preview.vim/plugin'
  endif
  call plug#end()

  filetype plugin indent on

  if filereadable(mkdpdir . '/mkdp.vim')
    if has('nvim')
      " Markdown Preview Plugin
      let g:mkdp_auto_start = 1
    else
      " Markdown Preview
      let g:mkdp_path_to_chrome = 'xdg-open'
      " let g:mkdp_path_to_chrome = 'surf'  " Put in ~/.vim/local.vim
      let g:mkdp_auto_start = 1
    endif
  endif

  if filereadable(plugindir . '/nerdtree/autoload/nerdtree.vim')
    " Start NERDTree when Vim is started without file arguments.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
    "
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " Open NERDTree finding current file with ,nt
    nnoremap <silent> <expr> <leader>nt g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
  endif

  if filereadable(plugindir . '/vim-airline/autoload/airline.vim')
    "let g:airline#extensions#syntastic#enabled=10
    let g:airline_powerline_fonts = 1
    let g:airline_theme='papercolor'
    "let g:Powerline_symbols = 'fancy'
    "let g:Powerline_symbols='unicode'
    let g:prettier#autoformat = 0
    let g:prettier#config#single_quote = 'false'
    let g:prettier#config#trailing_comma = 'none'

    "if !exists('g:airline_symbols')
    "    let g:airline_symbols = {}
    "endif
  endif

  if filereadable(plugindir . '/vim-prettier/autoload/prettier.vim')
    " autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier
  endif
endif

" Set tab spacing for python & php
autocmd FileType python set tabstop=4 shiftwidth=4
autocmd FileType php    set tabstop=4 shiftwidth=4

" Edit and source Vim config file
execute 'nnoremap <leader>ev :aboveleft vsp ' . configfile . '<CR>'
execute 'nnoremap <leader>sv :source ' . configfile . '<CR>'
" Toggle numbers and tab/end of line characters for copying (default: on)
nnoremap <silent> <expr> <leader>cp "\:set list! number! " . (&colorcolumn == '' ? "colorcolumn=80" : "colorcolumn=") . "<CR>"
" Toggle spell checking (default: off)
nnoremap <leader>sp :set spell!<CR>
" Set up search and replace string in command mode
nnoremap S :%s//g<Left><Left>

" Auto paste mode
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction

if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has('gui_running')
  set lines=45 columns=150
  " map <C-X> "+x
  " map <C-C> "+y
  " map <C-V> "+gP
endif

if filereadable(configdir . '/local.vim')
  exec 'source' configdir . '/local.vim'
endif
