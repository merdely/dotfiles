vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.shiftround = true
vim.o.signcolumn = "yes"
vim.o.undofile = true
vim.o.autoread = true
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.confirm = true
vim.o.cursorline = true
vim.o.colorcolumn = "80"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.scrolloff = 3
vim.o.wrap = true
vim.o.showmatch = true
vim.o.inccommand = "split"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undolevels = 1000
-- vim.o.wildmode = "noselect"

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
  if vim.env.SSH_TTY then
    vim.g.clipboard = "osc52"
  end
end)

