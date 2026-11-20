" Plugin settings that must exist BEFORE the plugins load (pack/*/start loads
" after this directory). Mappings and anything calling plugin functions go in
" after/plugin/plugins.vim.

" vim-surround: use mini.surround's gs* keys instead of ys/ds/cs
let g:surround_no_mappings = 1

" vim-sneak: label mode is the closest thing to flash.nvim
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" auto-pairs (LunarWatcher fork): <leader>up toggles, as the Snacks
" autopairs toggle did, so drop the plugin's own <M-p> toggle key
let g:AutoPairsShortcutToggle = ''

" vim-vsnip: reuse the Neovim snippets (VS Code JSON format, global.json
" applies to every filetype)
let g:vsnip_snippet_dir = g:config_dir . '/snippets'
let g:vsnip_filetypes = {'bash': ['sh']}

" vim-gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_removed_first_line = ''
let g:gitgutter_sign_modified_removed = '▎'

" fzf.vim: Snacks-like layout
let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8, 'border': 'rounded'}}
let g:fzf_vim = {'preview_window': ['right,50%', 'ctrl-/']}

" lightline (statusline; lualine replacement). Components defined in
" after/plugin/plugins.vim.
let g:lightline = {
      \ 'active': {
      \   'left':  [['mode', 'paste'], ['gitbranch'], ['readonly', 'filename', 'modified', 'diagnostics', 'githunks']],
      \   'right': [['position'], ['recording'], ['fileencoding', 'fileformat', 'filetype']],
      \ },
      \ 'component': {'position': '%l/%L:%c'},
      \ 'component_function': {
      \   'gitbranch': 'StatuslineGitBranch',
      \   'githunks': 'StatuslineGitHunks',
      \   'diagnostics': 'StatuslineDiagnostics',
      \   'recording': 'StatuslineRecording',
      \ },
      \ }
if !empty(globpath(&packpath, 'pack/*/start/*/autoload/lightline/colorscheme/nightfly.vim'))
  let g:lightline.colorscheme = 'nightfly'
endif
