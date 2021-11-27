filetype off
syntax on

" set autoindent
set background=dark
"set backspace=indent,eol,start
"set clipboard=unnamedplus
set colorcolumn=80
set cursorline
set expandtab
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
set t_Co=256
"set wildignore+=**/node_modules/**
set wildmenu

highlight CursorLine cterm=NONE ctermbg=235
highlight CursorLineNr cterm=NONE ctermbg=235
highlight Normal guibg=black guifg=white ctermbg=NONE
highlight ColorColumn ctermbg=darkgrey guibg=darkgrey

" Don't load Vundle if directory doesn't exist
if isdirectory($HOME . "/.vim/bundle/Vundle.vim")
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'gmarik/Vundle.vim'               " Vundle plugin manager
  Plugin 'vim-airline/vim-airline'         " Airline status bar
  Plugin 'vim-airline/vim-airline-themes'  " Airline status bar themes
  Plugin 'ycm-core/YouCompleteMe'          " Code completion engine
  Plugin 'prettier/vim-prettier'           " Code linter
  Plugin 'tpope/vim-repeat'                " Enable repeating plugins
  Plugin 'tpope/vim-surround'              " Delete/change/add parens/quotes/tags
  Plugin 'juneedahamed/vc.vim'             " Support for SCM
  "Plugin 'iamcco/markdown-preview.vim'     " Markdown preview
  call vundle#end()
  filetype plugin indent on

  "let g:airline#extensions#syntastic#enabled=10
  let g:airline_powerline_fonts = 1
  let g:airline_theme='papercolor'
  "let g:Powerline_symbols = 'fancy'
  "let g:Powerline_symbols='unicode'
  let g:prettier#autoformat = 0
  let g:prettier#config#single_quote = "false"
  let g:prettier#config#trailing_comma = "none"

  "if !exists('g:airline_symbols')
  "    let g:airline_symbols = {}
  "endif
  " autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
  autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier
endif

" Set tab spacing for python & php
autocmd FileType python set tabstop=4 shiftwidth=4
autocmd FileType php    set tabstop=4 shiftwidth=4

" Use ',' as leader key and create some shortcuts
let mapleader=","
nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>
" Toggle numbers and tab/end of line characters for copying (default: on)
nnoremap <leader>cp :set list! number!<CR>
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
  return ""
endfunction

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("gui_running")
  set lines=45 columns=150
  " map <C-X> "+x
  " map <C-C> "+y
  " map <C-V> "+gP
endif

