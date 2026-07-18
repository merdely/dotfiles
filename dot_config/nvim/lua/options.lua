vim.opt.confirm = true -- ask about unsaved changes (default: false)
vim.opt.updatetime = 300 -- time in ms to write swap on idle (default: 4000)
vim.opt.timeoutlen = 500 -- time in ms to wait for mapped sequence (default: 1000)
vim.opt.ttimeoutlen = 50 -- time in ms to wait for a key code (default: 50)
vim.opt.splitbelow = true -- open horizontal splits below (default: false)
vim.opt.splitright = true -- open vertical splits to right (default: false)
vim.opt.termguicolors = true -- 24-bit RGB colors (default: false)
vim.opt.background = 'dark' -- background can be 'dark' or 'light' (default: dark)
vim.opt.scrolloff = 3 -- num lines above/below when scrolling (default: 0)
vim.opt.sidescrolloff = 0 -- num columns left/right when scrolling with nowrap (default: 0)
vim.opt.number = true -- show line numbers (default: false)
vim.opt.relativenumber = true -- show relative line numbers (default: false)
vim.opt.cursorline = true -- highlight line cursor is on (default: false)
vim.opt.wrap = true -- when on, do not scroll for long lines (default: true)
vim.opt.colorcolumn = '80' -- list of columns to highlight (default: '')
vim.opt.signcolumn = 'yes' -- controls display of sign column (default: auto)
vim.opt.showmatch = true -- show matching paired characters (default: false)
vim.opt.showmode = false -- If using status line, set showmode to false (default: true)
vim.opt.inccommand = 'split' -- show of commands as preview (default: nosplit)
vim.opt.ignorecase = true -- ignore case for searches (default: false)
vim.opt.smartcase = true -- override ignorecase if search contains upper (default: false)
vim.opt.writebackup = false -- make backup before overwriting (default: true)
vim.opt.swapfile = false -- use swap for buffer (default: true)
vim.opt.undofile = true -- save undo history (default: false)
vim.opt.undolevels = 1000 -- number of undos (default: 1000)
vim.opt.tabstop = 2 -- num columns for tab character (default: 8)
vim.opt.softtabstop = 2 -- create soft tabs, separated by softtabstop num chars (default: 0)
vim.opt.shiftwidth = 2 -- num columns make up one level of (auto)indent (default: 8)
vim.opt.expandtab = true -- use spaces instead of tab (default: false)
vim.opt.smartindent = true -- try to figure out indenting when starting new line (default: false)
vim.opt.breakindent = true -- wrapped lines with indent (default: false)
vim.opt.autoindent = true -- copy indent of current line when starting new line (default: true)
vim.opt.shiftround = true -- round indent to multple of shiftwidth (default: false)
vim.opt.selection = 'inclusive' -- whether to include last char of selection (default: inclusive)
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
vim.opt.list = true -- show special characters (spaces, etc) with other characters (default: false)
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- override list chars (default: 'tab:> ,trail:-,nbsp:+')

-- second stage diff to align lines (default: 40)
-- internal, filler, closeoff, indent-heuristic, inline:char, linematch
-- vim.opt.diffopt:append("linematch:60")

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

