" Helper functions (ports of functions.lua plus small Snacks replacements)

" --- UpdatePlugins -----------------------------------------------------------
" Same scheme as the Neovim config: create an empty directory named
"   pack/plugins/{start,opt}/github.com%OWNER%REPO
" then run :UpdatePlugins. Each plugin is (re)downloaded as a GitHub tarball.
function! s:UpdatePlugins() abort
  let pack_root = g:config_dir . '/pack/plugins'
  let [updated, failed] = [0, 0]
  for container in ['start', 'opt']
    for plugin_dir in glob(pack_root . '/' . container . '/github.com%*', 1, 1)
      if !isdirectory(plugin_dir) | continue | endif
      let dirname = fnamemodify(plugin_dir, ':t')
      let m = matchlist(dirname, '^github\.com%\([^%]\+\)%\(.\+\)$')
      if empty(m) | continue | endif
      let [owner, repo] = m[1:2]
      let staging = pack_root . '/' . container . '/.tmp-' . dirname
      let tarball = tempname() . '.tar.gz'
      let url = printf('https://codeload.github.com/%s/%s/tar.gz/HEAD', owner, repo)
      call delete(staging, 'rf')
      echo printf('Fetching %s/%s...', owner, repo)
      redraw

      " 1. download
      let code = system('curl -fsSL -o ' . shellescape(tarball) . ' -w "%{http_code}" ' . shellescape(url))
      if v:shell_error || code !~# '200' || getfsize(tarball) <= 0
        echohl ErrorMsg | echom printf('[%s] download failed (http %s)', dirname, code) | echohl None
        let failed += 1
        call delete(tarball)
        continue
      endif

      " 2. extract to staging dir on the same filesystem
      call mkdir(staging, 'p')
      let out = system('tar -xzf ' . shellescape(tarball) . ' -C ' . shellescape(staging))
      call delete(tarball)
      let roots = filter(glob(staging . '/*', 1, 1), 'isdirectory(v:val)')
      if v:shell_error || len(roots) != 1
        echohl ErrorMsg | echom printf('[%s] extraction failed: %s', dirname, out) | echohl None
        let failed += 1
        call delete(staging, 'rf')
        continue
      endif

      " 3. swap old for new
      call delete(plugin_dir, 'rf')
      let ok = rename(roots[0], plugin_dir) == 0
      call delete(staging, 'rf')
      if ok
        let updated += 1
        if isdirectory(plugin_dir . '/doc')
          try
            execute 'helptags' fnameescape(plugin_dir . '/doc')
          catch
            echom printf('helptags failed for %s: %s', dirname, v:exception)
          endtry
        endif
        echom printf('Updated %s/%s', container, dirname)
      else
        echohl ErrorMsg | echom printf('[%s] failed to move new content into place', dirname) | echohl None
        let failed += 1
      endif
    endfor
  endfor
  echom printf('plugin update: %d updated, %d failed (restart Vim to load changes)', updated, failed)
endfunction
command! UpdatePlugins call s:UpdatePlugins()

" --- Buffers -----------------------------------------------------------------
" Delete a buffer but keep the window layout (Snacks.bufdelete)
function! BufDelete(...) abort
  let buf = a:0 ? a:1 : bufnr('%')
  if getbufvar(buf, '&modified')
    let choice = confirm('Save changes to "' . bufname(buf) . '"?', "&Yes\n&No\n&Cancel")
    if choice == 1
      execute 'buffer' buf | write
    elseif choice != 2
      return
    endif
  endif
  for winid in win_findbuf(buf)
    call win_execute(winid, 'if buflisted(bufnr("#")) && bufnr("#") != ' . buf . ' | buffer # | else | bprevious | endif')
    if winbufnr(winid) == buf
      call win_execute(winid, 'enew')
    endif
  endfor
  execute 'silent! bdelete!' buf
endfunction

function! BufDeleteAlternate() abort
  let alt = bufnr('#')
  if alt != -1 && bufloaded(alt)
    execute 'bdelete' alt
  else
    echohl WarningMsg | echo 'No previous buffer' | echohl None
  endif
endfunction

function! BufDeleteOthers() abort
  for buf in getbufinfo({'buflisted': 1})
    if buf.bufnr != bufnr('%') && !buf.changed
      execute 'silent! bdelete' buf.bufnr
    endif
  endfor
endfunction

function! BufDeleteHidden() abort
  for buf in getbufinfo({'buflisted': 1})
    if empty(buf.windows) && !buf.changed
      execute 'silent! bdelete' buf.bufnr
    endif
  endfor
endfunction

" --- Files -------------------------------------------------------------------
function! MakeExecutable() abort
  let file = expand('%:p')
  if empty(file)
    echohl ErrorMsg | echo 'No file' | echohl None
    return
  endif
  write
  let out = system('chmod +x ' . shellescape(file))
  if v:shell_error
    echohl ErrorMsg | echo 'chmod failed: ' . out | echohl None
    return
  endif
  edit!
  echo "Made '" . file . "' executable"
endfunction

function! RenameFile() abort
  let old = expand('%:p')
  let new = input('New name: ', old, 'file')
  if empty(new) || new ==# old | return | endif
  if filereadable(new)
    echohl ErrorMsg | echo "\n" . new . ' already exists' | echohl None
    return
  endif
  call mkdir(fnamemodify(new, ':h'), 'p')
  execute 'saveas' fnameescape(new)
  if filereadable(old) | call delete(old) | endif
  execute 'silent! bwipeout' fnameescape(old)
  redraw | echo 'Renamed to ' . new
endfunction

" --- Windows -----------------------------------------------------------------
function! ToggleList(kind) abort
  let key = a:kind ==# 'c' ? 'quickfix' : 'loclist'
  for win in getwininfo()
    if win.tabnr == tabpagenr() && get(win, key, 0)
      execute a:kind ==# 'c' ? 'cclose' : 'lclose'
      return
    endif
  endfor
  execute 'silent! botright ' . (a:kind ==# 'c' ? 'copen' : 'lopen')
endfunction

" Zoom current window into its own tab, toggle back
function! ZoomToggle() abort
  if exists('t:zoomed')
    tabclose
  elseif winnr('$') > 1
    tab split
    let t:zoomed = 1
  endif
endfunction

" --- Terminals ---------------------------------------------------------------
function! s:OpenTerminal(cmd, cwd) abort
  let opts = {'term_finish': 'close'}
  if !empty(a:cwd) | let opts.cwd = a:cwd | endif
  botright new
  call term_start(empty(a:cmd) ? &shell : ['sh', '-c', a:cmd], extend(opts, {'curwin': 1}))
endfunction

" use_cwd=1: Vim's cwd; 0: the buffer's directory. scp:// buffers (netrw)
" open an ssh session in the remote directory instead.
function! SmartTerminal(use_cwd) abort
  let name = expand('%')
  let m = matchlist(name, '^scp://\%(\([^@/]\+\)@\)\?\([^/:]\+\)\%(:\d\+\)\?/\(.*\)$')
  if !empty(m)
    let dest = empty(m[1]) ? m[2] : m[1] . '@' . m[2]
    let path = m[3] =~# '^/' ? m[3] : '~/' . m[3]
    if path !~# '/$' | let path = fnamemodify(path, ':h') | endif
    call s:OpenTerminal(printf("ssh -t %s 'cd %s && exec $SHELL -l'", dest, shellescape(path)), '')
    return
  endif
  let dir = ''
  if !a:use_cwd && !empty(name) && empty(&buftype)
    let dir = expand('%:p:h')
  endif
  call s:OpenTerminal('', dir)
endfunction

" <C-/>: toggle a bottom terminal, reusing it if it's still running
function! TerminalToggle() abort
  if exists('s:term_buf') && bufexists(s:term_buf)
    let wins = win_findbuf(s:term_buf)
    if !empty(wins)
      call win_execute(wins[0], 'hide')
      return
    endif
    execute 'botright sbuffer' s:term_buf
    resize 15
    return
  endif
  botright 15new
  let s:term_buf = term_start(&shell, {'curwin': 1, 'term_finish': 'close'})
endfunction

" Floating terminal (popup window) for full-screen tools like lazygit
function! FloatTerminal(cmd) abort
  if !executable(split(a:cmd)[0])
    echohl ErrorMsg | echo a:cmd . ' not found' | echohl None
    return
  endif
  let buf = term_start(a:cmd, {'hidden': 1, 'term_finish': 'close'})
  let w = float2nr(&columns * 0.9)
  let h = float2nr(&lines * 0.9)
  call popup_create(buf, {'minwidth': w, 'maxwidth': w, 'minheight': h, 'maxheight': h,
        \ 'border': [], 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰']})
endfunction

" --- TODO comments (todo-comments.nvim replacement) --------------------------
let g:todo_keywords = ['TODO', 'FIX', 'FIXME', 'HACK', 'WARN', 'WARNING', 'NOTE', 'PERF', 'BUG', 'XXX']
let s:todo_pattern = '\v<(' . join(g:todo_keywords, '|') . ')>:'

function! TodoJump(dir) abort
  if !search(s:todo_pattern, a:dir ? 'w' : 'bw')
    echo 'No todo comments'
  endif
endfunction

function! s:TodoList(keywords) abort
  let kw = empty(a:keywords) ? g:todo_keywords : a:keywords
  let pat = '\b(' . join(kw, '|') . '):'
  if executable('rg')
    cexpr system('rg --vimgrep --hidden -g "!.git" ' . shellescape(pat))
  else
    execute 'silent! vimgrep /\v<(' . join(kw, '|') . ')>:/gj **/*'
  endif
  botright cwindow
endfunction

command! -nargs=* TodoQuickFix call s:TodoList([<f-args>])
" ]n/[n are mapped in after/plugin/plugins.vim so vim-unimpaired can't take them
nnoremap <silent> <leader>st :TodoQuickFix<CR>
nnoremap <silent> <leader>sT :TodoQuickFix TODO FIX FIXME<CR>

augroup todo_highlight
  autocmd!
  autocmd ColorScheme * highlight default link TodoComment Todo
  autocmd WinEnter,BufWinEnter * if !exists('w:todo_match')
        \ | let w:todo_match = matchadd('TodoComment', s:todo_pattern) | endif
augroup END
highlight default link TodoComment Todo

" --- Clipboard over OSC 52 -----------------------------------------------------
" Used when Vim has no +clipboard (e.g. Debian's plain `vim`, or over SSH):
" yanks are sent to the terminal, which puts them on the system clipboard.
" In tmux this needs `set -g set-clipboard on`.
function! Osc52(text) abort
  if !exists('*echoraw') | return | endif
  let b64 = substitute(system('base64', a:text), '\n', '', 'g')
  call echoraw("\e]52;c;" . b64 . "\x07")
endfunction

" Put text on the clipboard whichever way works
function! SetClipboard(text) abort
  if has('clipboard') && (empty($SSH_TTY) || !empty($DISPLAY) || !empty($WAYLAND_DISPLAY))
    let @+ = a:text
  else
    let @" = a:text
    call Osc52(a:text)
  endif
endfunction

if !has('clipboard') || (!empty($SSH_TTY) && empty($DISPLAY))
  augroup osc52_yank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' && index(['', '+', '*'], v:event.regname) >= 0
          \ | call Osc52(join(v:event.regcontents, "\n") . (v:event.regtype ==# 'V' ? "\n" : ''))
          \ | endif
  augroup END
endif
