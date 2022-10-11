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
  let plugindir = $HOME . '/.local/share/nvim/plugged'
  let pluginconf = $HOME . '/.local/share/nvim/plugin'
  let autoload = $HOME . '/.local/share/nvim/site/autoload'
else
  let configfile = $HOME . '/.vimrc'
  let configdir = $HOME . '/.vim'
  let plugindir = $HOME . '/.vim/plugged'
  let pluginconf = $HOME . '/.vim/plugin'
  let autoload = $HOME . '/.vim/autoload'
endif
if has("win32") || has("win64")
  set guifont=DejaVu_Sans_Mono_for_Powerline:h10
  set encoding=utf-8
endif

" Use ',' as leader key
let mapleader=','

filetype off
syntax on

let g:loaded_perl_provider = 0
let g:loaded_python_provider = 0

" set autoindent
set background=dark
set backupdir=~/.cache/vim_backup
"set backspace=indent,eol,start
"set clipboard=unnamedplus
set colorcolumn=80
set cursorline
set expandtab
set hlsearch
set hidden
set incsearch
set ignorecase
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

" Fix termguicolors
if v:version > 800
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if has("win32") || has("win64")
  set backupdir=~/vimfiles/backups
  let configfile = $HOME . '/_vimrc'
  let configdir = $HOME . '/vimfiles'
  let autoload = $HOME . '/vimfiles/autoload'
  let plugindir = $HOME . '/vimfiles/plugged'
  let pluginconf = $HOME . '/vimfiles/plugin'
endif

if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

highlight CursorLine cterm=NONE ctermbg=235 guibg=#262626
highlight CursorLineNr cterm=NONE ctermbg=235 guibg=#262626
highlight Normal guibg=black guifg=white ctermbg=NONE
highlight ColorColumn ctermbg=234 guibg=#1c1c1c

" Don't load vim-plug if file doesn't exist
if filereadable(autoload . '/plug.vim')
  call plug#begin()
  " Load plugins if there is a file in the plugindir for the plugin
  if filereadable(pluginconf . '/airline.vim')
    Plug 'vim-airline/vim-airline'                     " Airline status bar
    Plug 'vim-airline/vim-airline-themes'              " Airline status bar themes
  endif
  if filereadable(pluginconf . '/coc.vim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}    " Conquer of Completion
  endif
  if filereadable(pluginconf . '/indentLine.vim')
    Plug 'Yggdroot/indentLine'                         " indentLine
  endif
  if filereadable(pluginconf . '/markdown.vim')
    Plug 'iamcco/markdown-preview.nvim'                " Markdown preview
  endif
  if filereadable(pluginconf . '/nerdtree.vim')
    Plug 'preservim/nerdtree'                          " File viewer
  endif
  if filereadable(pluginconf . '/prettier.vim')
    Plug 'prettier/vim-prettier'                       " Code linter
  endif
  if executable('ranger') && filereadable(pluginconf . '/ranger.vim') && has('nvim')
    Plug 'kevinhwang91/rnvimr'                         " Fileviewer (ranger)
  endif
  if executable('ranger') && filereadable(pluginconf . '/ranger.vim') && !has('nvim')
    Plug 'francoiscabrol/ranger.vim'                   " Fileviewer (ranger)
  endif
  if filereadable(pluginconf . '/repeat.vim')
    Plug 'tpope/vim-repeat'                            " Enable repeating plugins
  endif
  if executable('rg') && filereadable(pluginconf . '/ripgrep.vim')
    Plug 'BurntSushi/ripgrep'                          " Fast search (ripgrep)
  endif
  if filereadable(pluginconf . '/suda.vim') && has('nvim')
    Plug 'lambdalisue/suda.vim'                        " Sudo plugin for NeoVim
  endif
  if filereadable(pluginconf . '/surround.vim')
    Plug 'tpope/vim-surround'                          " Delete/change/add parens/quotes/tags
  endif
  if filereadable(pluginconf . '/vc.vim')
    Plug 'juneedahamed/vc.vim'                         " Support for SCM
  endif
  if filereadable(pluginconf . '/ycm.vim') && has('python3')
    Plug 'ycm-core/YouCompleteMe'                      " Code completion engine
  endif
  if filereadable(pluginconf . '/telescope.vim')
    Plug 'nvim-lua/popup.nvim'                         " Needed for Telescope
    Plug 'nvim-lua/plenary.nvim'                       " Needed for Telescope
    Plug 'nvim-telescope/telescope.nvim'               " Telescope
    Plug 'nvim-telescope/telescope-fzy-native.nvim'    " Needed for Telescope
    Plug 'kyazdani42/nvim-web-devicons'                " Optional for Telescope
  endif
  call plug#end()
  filetype plugin indent on

  " If the plugin is loaded and there is a file in the plugindir, set some
  " settings
  if filereadable(pluginconf . '/airline.vim')
    if filereadable(plugindir . '/vim-airline/plugin/airline.vim')
      "let g:airline#extensions#syntastic#enabled=10
      let g:airline_powerline_fonts = 1
      let g:airline_theme='papercolor'
      "let g:Powerline_symbols = 'fancy'
      "let g:Powerline_symbols='unicode'

      if !exists('g:airline_symbols')
          let g:airline_symbols = {}
      endif
    endif
  endif " airline

  " Extensions: coc-tsserver coc-json coc-css coc-perl coc-sh
  "             coc-xml coc-html coc-markdownlint coc-phpls coc-pyright
  "             coc-yaml @yaegassy/coc-ansible @yeagassy/coc-nginx
  if filereadable(pluginconf . '/coc.vim')
    if filereadable(plugindir . '/coc.nvim/plugin/coc.vim')
      " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
      " unicode characters in the file autoload/float.vim
      set encoding=utf-8

      " TextEdit might fail if hidden is not set.
      set hidden

      " Some servers have issues with backup files, see #649.
      "" set nobackup
      "" set nowritebackup

      " Give more space for displaying messages.
      "" set cmdheight=2

      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      " delays and poor user experience.
      set updatetime=300

      " Don't pass messages to |ins-completion-menu|.
      "" set shortmess+=c

      " Always show the signcolumn, otherwise it would shift the text each time
      " diagnostics appear/become resolved.
      if has("nvim-0.5.0") || has("patch-8.1.1564")
        " Recently vim can merge signcolumn and number column into one
        set signcolumn=number
      else
        set signcolumn=yes
      endif

      " Use tab for trigger completion with characters ahead and navigate.
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config.
      inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      inoremap <silent><expr> <c-space> coc#refresh()

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
      elseif v:version > 800
        inoremap <silent><expr> <c-@> coc#refresh()
      endif

      " Make <CR> auto-select the first completion item and notify coc.nvim to
      " format on enter, <cr> could be remapped by other vim plugin
      ""inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      ""                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      " Use `[g` and `]g` to navigate diagnostics
      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " GoTo code navigation.
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
          call CocActionAsync('doHover')
        else
          execute '!' . &keywordprg . " " . expand('<cword>')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')
      highlight CocHighlightText ctermbg=238 guibg=#444444

      " Symbol renaming.
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code.
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region.
      " Example: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap keys for applying codeAction to the current buffer.
      nmap <leader>ac  <Plug>(coc-codeaction)
      " Apply AutoFix to problem on the current line.
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Map function and class text objects
      " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> for scroll float windows/popups.
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges.
      " Requires 'textDocument/selectionRange' support of language server.
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " Add `:Format` command to format current buffer.
      command! -nargs=0 Format :call CocAction('format')

      " Add `:Fold` command to fold current buffer.
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer.
      command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

      " Add (Neo)Vim's native statusline support.
      " NOTE: Please see `:h coc-status` for integrations with external plugins that
      " provide custom statusline: lightline.vim, vim-airline.
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

      " Mappings for CoCList
      " Show all diagnostics.
      nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions.
      nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
      " Show commands.
      nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
      " Find symbol of current document.
      nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
      " Search workspace symbols.
      nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
      " Resume latest coc list.
      nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
    endif
  endif " coc
  if filereadable(pluginconf . '/markdown.vim')
    if has('nvim')
      let mkdpdir = plugindir . '/markdown-preview.nvim/plugin'
    else
      let mkdpdir = plugindir . '/markdown-preview.vim/plugin'
    endif

    if filereadable(mkdpdir . '/mkdp.vim')
      let g:mkdp_auto_start = 0
      let g:mkdp_path_to_chrome = 'xdg-open'
      nnoremap <leader>md :MarkdownPreviewToggle<CR>
    endif
  endif " markdown
  if filereadable(pluginconf . '/nerdtree.vim')
    if filereadable(plugindir . '/nerdtree/plugin/NERD_tree.vim')
      let g:NERDTreeHijackNetrw = 1

      " Start NERDTree when Vim is started without file arguments.
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
      "
      " Exit Vim if NERDTree is the only window remaining in the only tab.
      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

      " Open NERDTree finding current file with ,nt
      nnoremap <silent> <expr> <leader>nt g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
    endif
  endif " nerdtree
  if filereadable(pluginconf . '/prettier.vim')
    if filereadable(plugindir . '/vim-prettier/plugin/prettier.vim')
      " unmap <leader>p
      nnoremap <leader>pp <Plug>(Prettier)
      let g:prettier#autoformat = 0
      let g:prettier#config#single_quote = 'false'
      let g:prettier#config#trailing_comma = 'none'
      " autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
      autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier
    endif
  endif " prettier
  if executable('ranger') && filereadable(pluginconf . '/ranger.vim')
    if filereadable(plugindir . '/rnvimr/plugin/rnvimr.vim') && has('nvim')
      nnoremap <silent> <leader>R :RnvimrResize<CR>
      nnoremap <silent> <leader>r :RnvimrToggle<CR>

      " Make Ranger replace Netrw and be the file explorer
      let g:rnvimr_enable_ex = 1

      " Make Ranger to be hidden after picking a file
      let g:rnvimr_enable_picker = 1

      " Disable a border for floating window
      "let g:rnvimr_draw_border = 0

      " Hide the files included in gitignore
      "let g:rnvimr_hide_gitignore = 1

      " Make Neovim wipe the buffers corresponding to the files deleted by Ranger
      let g:rnvimr_enable_bw = 1
    endif

    if filereadable(plugindir . '/ranger.vim/plugin/ranger.vim') && !has('nvim')
      let g:ranger_replace_netrw = 1  " open ranger when vim open a directory
      nnoremap <silent> <leader>r :Ranger<CR>
    endif
  endif " ranger
  if filereadable(pluginconf . '/suda.vim') && has('nvim')
    if filereadable(plugindir . '/suda.vim/plugin/suda.vim')
      nnoremap <leader>sr :SudaRead<CR>
      nnoremap <leader>sw :SudaWrite<CR>
    endif
  endif " suda
  if filereadable(pluginconf . '/telescope.vim')
    if filereadable(plugindir . '/telescope.nvim/plugin/telescope.vim')
      lua require("telescope_plugin")

      nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
      nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
      nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>

      nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
      nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
      nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>
      nnoremap <leader>vrc :lua require('telescope_plugin').search_dotfiles({ hidden = true })<CR>
      "nnoremap <leader>va :lua require('theprimeagen.telescope').anime_selector()<CR>
      "nnoremap <leader>vc :lua require('theprimeagen.telescope').chat_selector()<CR>
      "nnoremap <leader>gc :lua require('theprimeagen.telescope').git_branches()<CR>
      "nnoremap <leader>gw :lua require('telescope').extensions.git_worktree.git_worktrees()<CR>
      "nnoremap <leader>gm :lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>
      "nnoremap <leader>td :lua require('theprimeagen.telescope').dev()<CR>
    endif
  endif " telescope
endif

" Set tab spacing for python & php
autocmd FileType python   set tabstop=4 shiftwidth=4
autocmd FileType php      set tabstop=4 shiftwidth=4
autocmd FileType markdown set noexpandtab tabstop=4 shiftwidth=4

" Edit and source Vim config file
execute 'nnoremap <leader>ev :aboveleft vsp ' . configfile . '<CR>'
execute 'nnoremap <leader>sv :source ' . configfile . '<CR>'
" Toggle numbers and tab/end of line characters for copying (default: on)
if filereadable(autoload . '/plug.vim')
  nnoremap <silent> <expr> <leader>cp "\:set cursorline! list! number! " . (&colorcolumn == '' ? "colorcolumn=80 " : "colorcolumn= ") . (&signcolumn == 'number' ? "signcolumn=no " : "signcolumn=number "). "<CR>:IndentLinesToggle<CR>" . (g:coc_enabled ? ":CocDisable" : ":CocEnable") . "<CR>"
else
  nnoremap <silent> <expr> <leader>cp "\:set cursorline! list! number! " . (&colorcolumn == '' ? "colorcolumn=80 " : "colorcolumn= ") . (&signcolumn == 'number' ? "signcolumn=no " : "signcolumn=number "). "<CR>"
endif
" Toggle spell checking (default: off)
nnoremap <leader>sp :set spell!<CR>
" Set up search and replace string in command mode
nnoremap S :%s//g<Left><Left>
" Install Vim Plugged
if has('nvim')
  nnoremap <leader>ivp :!curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim<CR>
else
  nnoremap <leader>ivp :!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim<CR>
endif

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

nnoremap <leader>cb :call ClearBuffers()<CR>
function ClearBuffers() " Vim with the 'hidden' option
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
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
