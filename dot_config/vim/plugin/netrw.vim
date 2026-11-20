" netrw as the oil.nvim replacement. Oil's "edit the listing like a buffer"
" has no Vim equivalent; netrw uses commands instead:
"   %  new file    d  new dir    R  rename    D  delete    -  parent dir
"   v  open in vsplit    o  open in split    t  open in tab    gh  toggle dotfiles
" Remote dirs work over scp: :e scp://host//abs/path/   (note the // for absolute)

let g:netrw_banner = 1
let g:netrw_hide = 0                 " show hidden files (oil show_hidden)
let g:netrw_altv = 1                 " v splits to the right
let g:netrw_alto = 1                 " o splits below
let g:netrw_preview = 1              " p previews in a vertical split
let g:netrw_winsize = 25
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_keepdir = 1              " don't change cwd while browsing

" - opens the directory of the current file with the cursor on that file
nnoremap <silent> - :call <SID>OpenParent()<CR>
function! s:OpenParent() abort
  let file = expand('%:t')
  if &filetype ==# 'netrw' | execute "normal \<Plug>NetrwBrowseUpDir" | return | endif
  execute 'Explore' (empty(expand('%')) ? '.' : '%:p:h')
  if !empty(file) | call search('\V\^' . escape(file, '\') . '\$', 'cw') | endif
endfunction
nnoremap <silent> <leader>e :Lexplore<CR>
nnoremap <silent> <leader>fe :Lexplore %:p:h<CR>

" Directory shortcuts from oil.lua, available inside netrw buffers
let g:netrw_shortcuts = {
      \ 'gA': '~/src/ansible',
      \ 'gB': '~/.local/bin',
      \ 'gC': '~/.config',
      \ 'gD': '~/Downloads',
      \ 'gE': '/etc',
      \ 'gG': '~/git',
      \ 'gH': '~',
      \ 'gJ': "~/.local/share/Syncthing/Logseq/Mike's Notes",
      \ 'gK': '/srv/docker',
      \ 'gL': '~/.local',
      \ 'gN': '~/.config/nvim',
      \ 'gQ': '~/src/scripts/bin',
      \ 'gR': '/srv/scripts',
      \ 'gP': '~/src/scripts',
      \ 'gS': '~/src',
      \ 'gT': '/run/user/' . system('id -u')[:-2] . '/tmp',
      \ 'gV': '~/.config/vim',
      \ 'gX': '~/.local/share/Syncthing',
      \ 'gO': '/home/mike.old/.config/nvim-test',
      \ 'geD': 'scp://earth.erdely.in//srv/docker/',
      \ 'geH': 'scp://earth.erdely.in//home/mike/',
      \ 'gjD': 'scp://jupiter.erdely.in//srv/docker/',
      \ 'gjH': 'scp://jupiter.erdely.in//home/mike/',
      \ 'gpH': 'scp://pluto.erdelynet.com//home/mike/',
      \ 'gcD': 'scp://ceres.erdelynet.com//srv/docker/',
      \ 'gcH': 'scp://ceres.erdelynet.com//home/mike/',
      \ }

function! s:NetrwGo(path) abort
  let path = a:path =~# '^scp://' ? a:path : expand(a:path)
  execute 'edit' fnameescape(path)
endfunction

function! s:NetrwMaps() abort
  for [lhs, path] in items(g:netrw_shortcuts)
    execute printf('nnoremap <buffer><silent> %s :call <SID>NetrwGo(%s)<CR>', lhs, string(path))
  endfor
  nnoremap <buffer> go :call <SID>NetrwGo(input('Directory: ', '', 'dir'))<CR>
  nmap <buffer> <C-s> v
  nmap <buffer> g. gh
  nmap <buffer> g~ cd
  nmap <buffer> gs s
  nnoremap <buffer><silent> q :Rexplore<CR>
endfunction

augroup netrw_maps
  autocmd!
  autocmd FileType netrw call s:NetrwMaps()
augroup END
