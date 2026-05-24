-- ================================================================================================
-- title : Basic Neovim config
-- author: Michael Erdely
-- inspiration: https://github.com/radleylewis/nvim-lite
-- ================================================================================================

-- ============================================================================
-- BOOTSTRAP lazy.nvim
-- ============================================================================
pcall(require, "lazy_bootstrap")

-- ============================================================================
-- PATHS
-- ============================================================================
local undodir = vim.fn.expand("~/.local/state/nvim/undodir")  -- define undodir
vim.opt.undodir = undodir                          -- Undo directory
-- Create undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- ============================================================================
-- COLORSCHEME DEFAULTS
-- ============================================================================
-- Highlight customizations moved into a ColorScheme autocmd so they persist
-- when a plugin colorscheme (e.g. catppuccin) loads and re-fires the event,
-- instead of being silently clobbered at startup.
local function apply_highlights()
  vim.api.nvim_set_hl(0, "SignColumn",  { bg = "NONE", ctermbg = "NONE" })    -- Adjust the background to be transparent
  vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "NONE", bg = "#182e3f" }) -- Adjust the color column to be blue
  vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = "NONE", bg = "#081e2f" })  -- Adjust the cursor line to be a slightly lighter blue
  local hl = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })    -- Copy CursorLine settings
  vim.api.nvim_set_hl(0, "CursorLineSign", hl)                                -- Match CursorLine
  vim.api.nvim_set_hl(0, "CursorLineNr", hl)                                  -- Match CursorLine
  vim.api.nvim_set_hl(0, "StatusLine",     { fg = "#c0c0d0", ctermbg = "NONE", bg = "#081e2f" })

  -- Status Line styles
  vim.api.nvim_set_hl(0, "StatusLineMode", { bold = true,  fg = "#2c3043", bg = "#82aaff" })
  vim.api.nvim_set_hl(0, "StatusLineGit",  { bold = false, fg = "#82aaff", bg = "#2c3043" })
  vim.api.nvim_set_hl(0, "StatusLineIcon", { bold = false, fg = "#2c3043", bg = "#081e2f" })
  vim.api.nvim_set_hl(0, "StatusLinePerc", { bold = false, fg = "#82aaff", bg = "#2c3043" })
  vim.api.nvim_set_hl(0, "StatusLinePos",  { bold = false, fg = "#2c3043", bg = "#82aaff" })

  -- Never have a background color
  vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  --
  -- Setup transparency for floating terminal
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })
end
apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights, })

-- ============================================================================
-- OPTIONS
-- ============================================================================
-- Basic settings
vim.opt.number = true                              -- Line numbers
vim.opt.relativenumber = false                     -- Relative line numbers
vim.opt.cursorline = true                          -- Highlight current line
vim.opt.wrap = true                                -- Line wrapping
vim.opt.scrolloff = 10                             -- Number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8                          -- Number of columns to keep left/right of cursor

-- Indentation
vim.opt.tabstop = 2                                -- Tab width
vim.opt.shiftwidth = 2                             -- Indent width
vim.opt.softtabstop = 2                            -- Soft tab stop
vim.opt.expandtab = true                           -- Use spaces instead of tabs
vim.opt.smartindent = true                         -- Smart auto-indenting
vim.opt.autoindent = true                          -- Copy indent from current line
vim.opt.breakindent = true                         -- Show wrapped lines indented

-- Search settings
vim.opt.ignorecase = true                          -- Case insensitive search
vim.opt.smartcase = true                           -- Case sensitive if uppercase in search
vim.opt.hlsearch = true                            -- Search results highlighting
vim.opt.incsearch = true                           -- Show matches while typing

-- Theme (Can be overridden by plugins)
vim.opt.termguicolors = true                       -- Enable 24-bit colors
vim.opt.background = "dark"                        -- Change colorscheme to handle dark background
vim.cmd.colorscheme('vim')                         -- Load colorscheme: good ones are torte, elflord, wildcharm, vim, catppuccin

-- Visual settings
vim.opt.signcolumn = "yes"                         -- Always show sign column
vim.opt.colorcolumn = "80"                         -- Column number where to show color column
vim.opt.list = true                                -- Show list characters
vim.opt.listchars:append {                         -- Show symbols for tabs and trailing spaces
  tab   = "▸ ",
  trail = "·",
  nbsp  = "␣"
}
vim.opt.showmatch = true                           -- Highlight matching brackets
vim.opt.matchtime = 2                              -- How long to show matching bracket
vim.opt.cmdheight = 1                              -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect"  -- Completion options
vim.opt.showmode = false                           -- Don't show mode in command line
vim.opt.pumheight = 10                             -- Popup menu height
vim.opt.pumblend = 10                              -- Popup menu transparency
vim.opt.winblend = 0                               -- Floating window transparency
vim.opt.winborder = "rounded"                      -- Windows have rounded corners
vim.opt.conceallevel = 0                           -- Don't hide markup
vim.opt.concealcursor = ""                         -- Don't hide cursor line markup
-- vim.opt.lazyredraw = true                          -- Don't redraw during macros (unsafe?)
vim.opt.synmaxcol = 300                            -- Syntax highlighting limit

-- File handling
vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false                           -- Don't create swap files
vim.opt.undofile = true                            -- Persistent undo
vim.opt.updatetime = 300                           -- Faster completion
vim.opt.timeoutlen = 500                           -- Key timeout duration
vim.opt.ttimeoutlen = 50                           -- Key code timeout
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false                          -- Don't auto save
vim.g.netrw_banner = 1                             -- Handle showing netrw banner

-- Behavior settings
vim.opt.hidden = true                              -- Allow hidden buffers
vim.opt.errorbells = false                         -- No error bells
vim.opt.backspace = "indent,eol,start"             -- Better backspace behavior
vim.opt.autochdir = false                          -- Don't auto change directory
-- vim.opt.iskeyword:append("-")                      -- Treat dash as part of word
vim.opt.path:append("**")                          -- Include subdirectories in search
vim.opt.selection = "inclusive"                    -- Include last char in selection
vim.opt.mouse = "a"                                -- Enable mouse support
vim.opt.clipboard:append("unnamedplus")            -- Use system clipboard
vim.opt.modifiable = true                          -- Allow buffer modifications
vim.opt.encoding = "utf-8"                         -- Set encoding

-- Cursor settings
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding settings
vim.opt.foldmethod = "expr"                        -- Fold method (syntax, expr, ...)
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99                             -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true                          -- Horizontal split creation position
vim.opt.splitright = true                          -- Vertical split creation position

-- Command-line completion
vim.opt.wildmenu = true                            -- Enhanced command-line completion
vim.opt.wildmode = "longest:full,full"             -- Completion mode for wildchar
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" }) -- Ignore patterns when expanding wildcards

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000                         -- Time (ms) for redrawing display
vim.opt.maxmempattern = 20000                      -- Max memory (Kb) for pattern matching

-- ============================================================================
-- Load Plugins
-- ============================================================================
-- Leader must be set here for plugins to be able to use it
vim.g.mapleader      = " "                         -- Set leader key
vim.g.maplocalleader = ","                         -- Set local leader key
-- Load plugins (fail silently)
pcall(require, "lazy_setup")

-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================
-- better movement in wrapped text
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Clear highlighted search terms
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Only show one buffer
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Switch to showing only one buffer" })

-- Toggle zoom in on one buffer
local zoomed = false
vim.keymap.set('n', '<leader>z', function()
  if zoomed then
    vim.cmd('wincmd =')
    zoomed = false
  else
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    zoomed = true
  end
end)

-- Yank to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
-- vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
-- vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better paste behavior
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without replacing clipboard content" })
vim.keymap.set({"n", "v" }, "<leader>xx", '"_d', { desc = "Delete without yanking" })

-- Better change behavior
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change without replacing clipboard content", noremap = true, silent = true })

-- Better single delete behavior
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete without replacing clipboard content", noremap = true, silent = true })

-- Swap character with one before it
vim.keymap.set('n', '<leader>sp', function()
  if vim.fn.col('.') == 1 then return end
  vim.cmd('normal! "cxh"cPl')
end, { desc = 'Swap char with previous char'})

-- Swap character with one after it
vim.keymap.set('n', '<leader>sn', function()
  if vim.fn.col('.') == vim.fn.col('$') - 1 then return end
  vim.cmd('normal! "zx"zph')
end, { desc = 'Swap char with next char' })

-- Open netrw
-- vim.g.netrw_banner = 0 -- Hide the Netrw banner on top
-- vim.g.netrw_altv = 1 -- Create the split of the Netrw window to the left
-- vim.g.netrw_browse_split = 4 -- Open files in previous window. This emulates the typical "drawer" behavior
-- vim.g.netrw_liststyle = 4 -- Set the styling of the file list to be one column with files inside
-- vim.g.netrw_winsize = 14 -- Set the width of the "drawer"
if vim.fn.maparg('-', 'n') == '' then
  vim.keymap.set('n', '<leader>e', vim.cmd.Explore, { desc = 'Open netrw Explorer' })
  vim.keymap.set('n', '-',         vim.cmd.Explore, { desc = 'Open netrw Explorer' })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function(ev)
      vim.keymap.set('n', '<Escape>', '<C-^>', { buffer = ev.buf })
    end,
  })
end

-- Writing and quitting
vim.keymap.set('n', '<leader>w', '<Cmd>update<CR>', { desc = 'Write the current buffer' })
vim.keymap.set('n', '<leader>q', '<Cmd>:quit<CR>', { desc = 'Quit the current buffer' })
vim.keymap.set('n', '<leader>Q', '<Cmd>:wqa<CR>', { desc = 'Quit all buffers and write' })

-- Navigate buffers
vim.keymap.set('n', '<leader>;', "<Cmd>e #<CR>", { desc = 'Switch to previous buffer' })
vim.keymap.set("n", "<leader>bn", ':bnext<CR>', { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ':bprevious<CR>', { desc = "Previous buffer" })

-- Manage Splits
vim.keymap.set("n", "<leader>sv", ':vsplit<CR>', { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ':split<CR>', { desc = "Split window horizontally" })

-- Split previous buffer
vim.keymap.set('n', '<leader>sb', '<Cmd>vert sf #<CR>', { desc = 'Split previous buffer vertically' })
vim.keymap.set('n', '<leader>sB', '<Cmd>bot sf #<CR>', { desc = 'Split previous buffer horizontally' })

-- Better split/window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>sr", "<C-w>r", { desc = "Rotate windows downward/right" })
vim.keymap.set("n", "<leader>sR", "<C-w>R", { desc = "Rotate windows upward/left" })
vim.keymap.set("n", "<leader>sx", "<C-w>x", { desc = "Exchange window with next" })
vim.keymap.set("n", "<leader>sH", "<C-w>H", { desc = "Move window to far left" })
vim.keymap.set("n", "<leader>sJ", "<C-w>J", { desc = "Move window to bottom" })
vim.keymap.set("n", "<leader>sK", "<C-w>K", { desc = "Move window to top" })
vim.keymap.set("n", "<leader>sL", "<C-w>L", { desc = "Move window to far right" })

-- Resize splits
vim.keymap.set("n", "<C-Up>",    ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-C-k>",   ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>",  ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-C-j>",   ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-C-h>",   ":vertical resize -2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-C-l>",   ":vertical resize +2<CR>", { desc = "Decrease window width" })

-- Toggle between horizontal and vertical split
vim.keymap.set('n', '<leader>st', function()
  -- Only operate on exactly 2 windows
  if #vim.api.nvim_list_wins() ~= 2 then
    vim.notify('Layout toggle requires exactly 2 windows', vim.log.levels.WARN)
    return
  end

  local wins = vim.api.nvim_list_wins()
  local win1 = vim.api.nvim_win_get_position(wins[1])
  local win2 = vim.api.nvim_win_get_position(wins[2])

  -- If both windows are on the same row → vertical split (side by side)
  -- If they differ in row → horizontal split (stacked)
  if win1[1] == win2[1] then
    -- Currently vertical, switch to horizontal
    vim.cmd('windo wincmd K')
  else
    -- Currently horizontal, switch to vertical
    vim.cmd('windo wincmd H')
  end
end, { desc = 'Toggle split layout' })

-- Move lines up/down
vim.keymap.set("n", "<S-A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<S-A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<S-A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<S-A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Toggles cursor line, list chars, line numbers, break-indent, color column, and sign column.
local function toggle_copy_mode()
  vim.cmd("set cursorline! list! number! breakindent!")
  if vim.o.colorcolumn == '' then
    vim.opt.colorcolumn = "80"
  else
    vim.opt.colorcolumn = ""
  end
  if vim.o.signcolumn == 'number' then
    vim.opt.signcolumn = 'no'
  else
    vim.opt.signcolumn = 'number'
  end
end
vim.keymap.set('n', '<leader>cp', toggle_copy_mode, { silent = true, desc = "Toggle copy-friendly mode" })

-- Make file executable
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })
vim.keymap.set("n", "<leader>x", function()
  local file = vim.fn.expand("%:p")  -- full path, not relative
  if file == "" then
    vim.notify("No file", vim.log.levels.ERROR)
    return
  end
  vim.cmd("write")
  local result = vim.system({ "chmod", "+x", file }):wait()
  if result.code ~= 0 then
    vim.notify("chmod failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit!")
  vim.notify("Made '" .. file .. "' executable")
end, { desc = "Make file executable" })

-- Quickly run macros
vim.keymap.set("n", "<leader>A", "@a", { desc = "Run macro a" })
vim.keymap.set("n", "<leader>S", "@s", { desc = "Run macro s" })
vim.keymap.set("n", "<leader>D", "@d", { desc = "Run macro d" })
vim.keymap.set("n", "<leader>F", "@f", { desc = "Run macro f" })
vim.keymap.set("n", "<leader>H", "@h", { desc = "Run macro h" })
vim.keymap.set("n", "<leader>J", "@j", { desc = "Run macro j" })
vim.keymap.set("n", "<leader>K", "@k", { desc = "Run macro k" })
vim.keymap.set("n", "<leader>L", "@l", { desc = "Run macro k" })

vim.keymap.set("n", "<leader>m", "@m", { desc = "Run macro m" })
vim.keymap.set("n", "<leader>M", "@m", { desc = "Run macro m" })
vim.keymap.set("n", "<leader>n", "@n", { desc = "Run macro n" })
vim.keymap.set("n", "<leader>N", "@n", { desc = "Run macro n" })

-- Redraw screen
vim.keymap.set("n", "<leader>l", ":redraw!<CR>", { desc = "Redraw Screen" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":edit $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":source $MYVIMRC<CR>", { desc = "Reload config" })

-- Reload module
if package.loaded["lazy"] then
  vim.keymap.set("n", "<leader>rp", function()
    local filepath = vim.fn.expand('%:p')
    local module_name = filepath:match('lua/(.+)%.lua$')
    -- local module_name = filepath:match('lua/plugins/(.+)%.lua$')
    if module_name then
      module_name = module_name:gsub('/', '.')
      -- module_name = 'plugins.' .. module_name
      package.loaded[module_name] = nil
      require('lazy.core.loader').reload(module_name)
      print('Reloaded ' .. module_name)
      -- local ok, result = pcall(require, module_name)
      -- if ok then
      --   print('Reloaded ' .. module_name)
      -- else
      --   print('Error reloading ' .. module_name)
      -- end
    else
      print('Not a lua module file')
    end
  end, { desc = 'Reload current Lua Module' })
end

-- ============================================================================
-- USEFUL FUNCTIONS
-- ============================================================================
-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path" })

-- Toggle Diagnostics
vim.keymap.set("n", "<leader>tD", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Prevent '#' from de-indenting in YAML files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "yaml", "yaml.ansible" },
  callback = function()
    vim.opt_local.indentkeys:remove("0#")
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "php", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "css", "html", "javascript", "json", "lua", "typescript" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
if package.loaded["oil"] then
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
      if vim.tbl_contains({ "oil" }, vim.bo.ft) then
        return
      end
      local dir = vim.fn.expand('<afile>:p:h')
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
    end,
  })
end

-- Netrw Key Bindings
local function netrw_open_if_exists(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded) == 1 or vim.fn.filereadable(expanded) == 1 then
    vim.cmd('e ' .. expanded)
    vim.notify("Working directory: " .. expanded)
  else
    vim.notify(expanded .. " does not exist")
  end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local map = function(key, path)
      vim.keymap.set('n', key, function() netrw_open_if_exists(path) end, { buffer = true })
    end

    vim.keymap.set('n', '<Esc>', ':bd<CR>',  { buffer = true })
    -- Can't use gb gd gf gF gg gh gn gp
    map('ga', '$HOME/src/ansible')
    map('gB', '$HOME/.local/bin')
    map('gc', '$HOME/.config')
    map('gd', '$HOME/Downloads')
    map('ge', '/etc')
    map('gG', '$HOME/git')
    map('gH', '$HOME')
    map('gL', '$HOME/.local/share/Syncthing/Logseq/Mike\'s Notes')
    map('gl', '$HOME/.local')
    map('gM', '$HOME/.config/nvim')
    map('gm', '$HOME/.config/DankMaterialShell')
    map('gN', '$HOME/.config/niri')
    map('gP', '$HOME/.config/nvim/lua/plugins')
    map('gR', '/srv/scripts')
    map('gr', '/srv/docker')
    map('gS', '$HOME/src/scripts')
    map('gs', '$HOME/src')
    map('gT', '/run/user/' .. vim.fn.system('id -u'):gsub('\n', '') .. '/tmp')
    map('gv', '$HOME/.config/vim')
    map('gw', '$HOME/Work')
    map('gX', '$HOME/.local/share/Syncthing')
    map('gx', '$HOME/src/scripts/bin')
    map('gy', '$HOME/.config/yazi')
    map('gZ', '%:p:h')
    vim.keymap.set('n', 'gz', function()
      local input = vim.fn.input("cd: ", vim.fn.expand("%:p:h"), "dir")
      if input ~= '' then vim.cmd('e ' .. input) end
    end, { buffer = true })
  end
})

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = terminal_state.buf })
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.api.nvim_set_option_value('winblend', 0, { win = terminal_state.win })

  -- Set transparent background for the window
  vim.api.nvim_set_option_value('winhighlight',
    'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder',
    { win = terminal_state.win })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true  -- once = true prevents duplicate autocmds accumulating on each toggle
  })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

-- Key mappings
vim.keymap.set("n", "<leader>T", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

-- ============================================================================
-- TABS
-- ============================================================================
vim.opt.showtabline = 1  -- Show tabline (0=never, 1=multiple tabs, 2=always)
vim.opt.tabline = ''     -- Use default tabline (empty string uses built-in)

-- Transparent tabline appearance
vim.cmd([[
  hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
]])

-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>tt', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab focus
vim.keymap.set('n', '<leader>tp', ':tabprev<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', { desc = 'Next tab' })
for i = 1, 9 do
  vim.keymap.set({ "n", "t" }, "<leader>t" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })

-- Function to open file in new tab
local function open_file_in_tab()
  vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
    if input and input ~= '' then
      vim.cmd('tabnew ' .. input)
    end
  end)
end

-- Function to duplicate current tab
local function duplicate_tab()
  local current_file = vim.fn.expand('%:p')
  if current_file ~= '' then
    vim.cmd('tabnew ' .. current_file)
  else
    vim.cmd('tabnew')
  end
end

-- Function to close tabs to the right
local function close_tabs_right()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr('$')

  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. 'tabclose')
  end
end

-- Function to close tabs to the left
local function close_tabs_left()
  local current_tab = vim.fn.tabpagenr()

  for i = current_tab - 1, 1, -1 do
    vim.cmd('1tabclose')
  end
end

-- Enhanced keybindings
vim.keymap.set('n', '<leader>tO', open_file_in_tab, { desc = 'Open file in new tab' })
vim.keymap.set('n', '<leader>td', duplicate_tab, { desc = 'Duplicate current tab' })
vim.keymap.set('n', '<leader>tr', close_tabs_right, { desc = 'Close tabs to the right' })
vim.keymap.set('n', '<leader>tL', close_tabs_left, { desc = 'Close tabs to the left' })

-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
  local buffers_in_tab = #vim.fn.tabpagebuflist()
  if buffers_in_tab > 1 then
    vim.cmd('bdelete')
  else
    -- If it's the only buffer in tab, close the tab
    vim.cmd('tabclose')
  end
end
vim.keymap.set('n', '<leader>bd', smart_close_buffer, { desc = 'Smart close buffer/tab' })

-- LSP for Lua
vim.lsp.enable({ "lua_ls" })
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})

-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Check if a status line plugin has already set up a status line
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local has_statusline_plugin = (
        package.loaded["lualine"]      or
        package.loaded["lightline"]    or
        package.loaded["airline"]      or
        package.loaded["heirline"]     or
        package.loaded["feline"]       or
        package.loaded["galaxyline"]   or
        package.loaded["express_line"] or
        package.loaded["mini.statusline"]
    )

    if not has_statusline_plugin then
      -- Git branch function with caching and Nerd Font icon
      -- [FIXED]: vim.loop is deprecated since Neovim 0.10; use vim.uv
      vim.g.cached_branch = ""
      local branch_cache = {}
      local last_check = {}

      local function git_branch()
        local dir = vim.fn.expand('%:p:h')
        local now = os.time()
        if not last_check[dir] or now - last_check[dir] > 5 then
          local result = vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. " branch --show-current 2>/dev/null | tr -d '\n'")
          branch_cache[dir] = result
          last_check[dir]   = now
        end
        vim.g.cached_branch = branch_cache[dir]
        if vim.g.cached_branch ~= '' then
          return ' \u{e725} ' .. vim.g.cached_branch .. ' '
        end
        return ''
      end
      _G.git_branch = git_branch

      -- File type with Nerd Font icon
      local function file_type()
        local ft = vim.bo.filetype
        local icons = {
          lua = "\u{e620} ", -- nf-dev-lua
          python = "\u{e73c} ", -- nf-dev-python
          javascript = "\u{e74e} ", -- nf-dev-javascript
          typescript = "\u{e628} ", -- nf-dev-typescript
          javascriptreact = "\u{e7ba} ",
          typescriptreact = "\u{e7ba} ",
          html = "\u{e736} ", -- nf-dev-html5
          css = "\u{e749} ", -- nf-dev-css3
          scss = "\u{e749} ",
          json = "\u{e60b} ", -- nf-dev-json
          markdown = "\u{e73e} ", -- nf-dev-markdown
          vim = "\u{e62b} ", -- nf-dev-vim
          sh = "\u{f489} ", -- nf-oct-terminal
          bash = "\u{f489} ",
          zsh = "\u{f489} ",
          rust = "\u{e7a8} ", -- nf-dev-rust
          go = "\u{e724} ", -- nf-dev-go
          c = "\u{e61e} ", -- nf-dev-c
          cpp = "\u{e61d} ", -- nf-dev-cplusplus
          java = "\u{e738} ", -- nf-dev-java
          php = "\u{e73d} ", -- nf-dev-php
          ruby = "\u{e739} ", -- nf-dev-ruby
          swift = "\u{e755} ", -- nf-dev-swift
          kotlin = "\u{e634} ",
          dart = "\u{e798} ",
          elixir = "\u{e62d} ",
          haskell = "\u{e777} ",
          sql = "\u{e706} ",
          yaml = "\u{f481} ",
          toml = "\u{e615} ",
          xml = "\u{f05c} ",
          dockerfile = "\u{f308} ", -- nf-linux-docker
          gitcommit = "\u{f418} ", -- nf-oct-git_commit
          gitconfig = "\u{f1d3} ", -- nf-fa-git
          vue = "\u{fd42} ", -- nf-md-vuejs
          svelte = "\u{e697} ",
          astro = "\u{e628} ",
        }

        if ft == "" then
          return " \u{f15b} " -- nf-fa-file_o
        end

        return ((icons[ft] or " \u{f15b} ") .. ft)
      end

      -- File size with Nerd Font icon
      local function file_size()
        local size = vim.fn.getfsize(vim.fn.expand("%"))
        if size < 0 then
          return ""
        end
        local size_str
        if size < 1024 then
          size_str = size .. "B"
        elseif size < 1024 * 1024 then
          size_str = string.format("%.1fK", size / 1024)
        else
          size_str = string.format("%.1fM", size / 1024 / 1024)
        end
        return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
      end

      -- Mode indicators with Nerd Font icons
      local function mode_icon()
        local mode = vim.fn.mode()
        local modes = {
          n       = "NORMAL",
          i       = "INSERT",
          v       = "VISUAL",
          V       = "V-LINE",
          ["\22"] = "V-BLOCK",
          c       = "COMMAND",
          s       = "SELECT",
          S       = "S-LINE",
          ["\19"] = "S-BLOCK",
          R       = "REPLACE",
          r       = "REPLACE",
          ["!"]   = "SHELL",
          t       = "TERMINAL",
        }
        return modes[mode] or (" \u{f059} " .. mode)
      end

      _G.mode_icon = mode_icon
      _G.git_branch = git_branch
      _G.file_type = file_type
      -- _G.file_size = file_size

      -- Function to change statusline based on window focus
      local function setup_dynamic_statusline()
        vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
          callback = function()
            vim.opt_local.statusline = table.concat({
              " ",
              "%#StatusLineBold#",
              "%{v:lua.mode_icon()}",
              "%#StatusLine# ",
              "\u{e0b1}",   -- left divider
              "%{v:lua.git_branch()}",
              " %f %h%m%r", -- filename + flags
              "%=",         -- Right-align everything after this
              "%{&fenc!=''?&fenc:&enc}", -- encoding
              " \u{e0b3}",  -- right divider
              " %{&fileformat}",
              " \u{e0b3}", -- right divider
              " %{&filetype}",
              " \u{e0b3}", -- right divider
              " %P",       -- percentage through file
              " \u{e0b3}", -- right divider
              " %l:%c ",   -- line:col
            })
          end,
        })

        vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
          callback = function()
            vim.opt_local.statusline = " %f %h%m%r \u{e0b1} %= %{v:lua.file_type()} \u{e0b3} %P \u{e0b3} %l:%c "
          end,
        })
      end

      setup_dynamic_statusline()
      vim.cmd("doautocmd BufEnter")
    end
  end
})
