# Portable Vim Config (port of ~/.config/nvim)

Needs **Vim 9.0+** (the LSP plugin is Vim9 script). Vim 9.1.0375+ is best:
it ships the `comment` package (gc/gcc), so vim-commentary isn't needed.

## Where it lives

- Vim 9.1.0327+ reads `~/.config/vim/vimrc` **only if `~/.vimrc` and `~/.vim/`
  don't exist**.
- On older Vims, symlink it: `ln -s ~/.config/vim ~/.vim`

The vimrc adds its own directory to `runtimepath`/`packpath`, so either works.

## Layout and load order

| Step | Path | Contents |
|------|------|----------|
| 1 | `vimrc` | leader, state dirs, no-persist mode |
| 2 | `plugin/*.vim` | options, keymaps, autocmds, functions, netrw, plugin variables |
| 3 | `pack/plugins/start/*` | the plugins |
| 4 | `after/plugin/*.vim` | plugin config (each block checks the plugin is installed) |

The order matters in Vim. Unlike Neovim's `require()`, Vim loads the
`pack/*/start` plugins **after** `plugin/`, so anything that calls a plugin
lives in `after/plugin/`.

Environment variables:
- `VIM_NO_PERSIST=1` (or `NVIM_NO_PERSIST`) turns off viminfo, swap, undo and
  backup.
- `VIM_DISABLE_PLUGINS=1` turns off all plugins.

## Plugins

Plugin installs work the same way as before. Create an empty directory, then
run `:UpdatePlugins`, which is now mapped to `<leader>uP`:

```sh
cd ~/.config/vim && mkdir -p pack/plugins/start && cd pack/plugins/start
for r in \
  yegappan/lsp hrsh7th/vim-vsnip hrsh7th/vim-vsnip-integ \
  junegunn/fzf junegunn/fzf.vim \
  tpope/vim-fugitive tpope/vim-rhubarb airblade/vim-gitgutter \
  tpope/vim-surround tpope/vim-repeat tpope/vim-unimpaired \
  justinmk/vim-sneak LunarWatcher/auto-pairs wellle/targets.vim \
  AndrewRadev/splitjoin.vim AndrewRadev/sideways.vim \
  itchyny/lightline.vim bluz71/vim-nightfly-colors
do mkdir -p "github.com%${r%%/*}%${r#*/}"; done
# Optional: mhinz/vim-startify mbbill/undotree catppuccin/vim
# Only on Vim < 9.1.0375: tpope/vim-commentary
```

Then run `vim +UpdatePlugins` and restart Vim. fzf.vim also needs the `fzf`
binary (`apt install fzf`), and `rg` is used for grep when it's installed.

## Neovim → Vim mapping

| Neovim | Vim | Notes |
|--------|-----|-------|
| vim.lsp + lsp/*.lua | yegappan/lsp (`after/plugin/lsp.vim`) | Servers are registered only if their binary is on `$PATH`. `:UpdateLspConfigs` is gone because the server list now lives in that file. |
| mini.completion, mini.keymap | yegappan/lsp autocomplete + Tab/S-Tab maps | |
| mini.snippets | vim-vsnip (+ vsnip-integ) | The same `snippets/*.json` files are reused unchanged. `<C-j>` expands a snippet. |
| tabout.nvim | `<Tab>` jumps over `)]}"'` | |
| Trouble, diagnostics.lua | quickfix/loclist, `:LspDiag` | `]d`/`[d` jump to a diagnostic and show its message. |
| Snacks picker | fzf.vim | Falls back to `:find`/`:Grep` without it. |
| Snacks terminal / lazygit | `:terminal`, popup terminal | `<C-/>` toggles a terminal; `<leader>gg` opens lazygit. |
| Snacks bufdelete, toggles, zoom, indent, bigfile | built-in functions and options | Indent guides use `listchars` `leadmultispace`. |
| Snacks dashboard | vim-startify (optional) | |
| oil.nvim | netrw | Your `gA`…`gcH` shortcuts are kept. `oil-ssh://` paths become `scp://`. You can't edit a listing like a buffer; use `%` `d` `R` `D` instead. |
| lualine | lightline | Plain statusline fallback if lightline isn't installed. |
| gitsigns | vim-gitgutter | `]h`/`[h`, `<leader>ghs`/`ghr`/`ghp`. |
| Snacks git pickers / gitbrowse | vim-fugitive + rhubarb | |
| mini.surround (gsa/gsd/gsr) | vim-surround on the same keys | |
| flash.nvim | vim-sneak (label mode on `s`/`S`) | No remote or treesitter modes. |
| nvim-autopairs | LunarWatcher/auto-pairs | |
| treesj | splitjoin.vim on `<leader>m` | |
| treesitter swap (`<leader>a`/`A`) | sideways.vim | |
| mini.ai | targets.vim | |
| mini.bracketed | vim-unimpaired | |
| mini.comment | built-in `comment` package / vim-commentary | |
| hlslens | built-in `[n/m]` search count | |
| todo-comments | built-in highlight, `]n`/`[n`, `<leader>st` quickfix | |
| vim.highlight.on_yank | built-in function | |
| clipboard osc52 | built-in OSC 52 function | Also used whenever Vim lacks `+clipboard`. |
| nightfly / catppuccin | vim-nightfly-colors | Falls back to `habamax`. |

### No Vim equivalent (dropped)

- Treesitter highlighting, text objects and moves. Vim's regex syntax is used
  instead. `v`/`V` in visual mode expand or shrink the selection through the
  LSP.
- noice, Snacks notifier, statuscolumn and profiler.
- `cmdheight=0` and `inccommand`.
- which-key. `liuchengxu/vim-which-key` exists, but it needs every mapping
  registered by hand.
- mini.icons.

## Keymap changes

- **Clear search highlight** is now `<Esc><Esc>` in terminal Vim. Mapping a
  bare `<Esc>` breaks arrow keys and other escape sequences there. The GUI
  still uses `<Esc>`.
- **`:UpdatePlugins`** moved to `<leader>uP`. In the Neovim config, `snacks.lua`
  loaded after `functions.lua` and replaced `<leader>up` with the autopairs
  toggle, and `<leader>ul` with the line-number toggle. Those are the bindings
  you actually had, so they're kept.
- **`<leader>gl`** opens `:Commits`. The second Neovim definition of this key
  called `LazyVim.root.git()`, which doesn't exist in that config.

## Issues found in the Neovim config

These are still there if you keep using Neovim:

- `plugin/keymaps.lua`: `<leader>bD`, `<leader>bp` and `<leader>bn` are
  missing `<CR>`, so they leave the command half-typed. `<leader>bp` is also
  described as "Next Buffer".
- `plugin/functions.lua`:
  - The helptags check is inverted (`if helpok then` reports a failure).
  - `tar` runs twice per plugin.
- `plugin/treesitter.lua`: `pcall(require "nvim-treesitter-textobjects")`
  calls `require` *before* `pcall`, so it throws an error when the plugin is
  missing. It should be `pcall(require, "...")`.
- `plugin/snacks.lua`: `<leader>gb`, `<leader>gl`, `<leader>gf` and
  `<leader>sb` are each defined twice. `<leader>st` is also defined in
  `todo-comments.lua`, which loads later and wins.
- `plugin/lsp.lua` sets `vim.diagnostic.config({ virtual_text = true })`,
  which `diagnostics.lua` already sets.
