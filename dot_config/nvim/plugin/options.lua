vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftround = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 3
vim.opt.wrap = true
vim.opt.showmatch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undolevels = 1000
-- vim.opt.wildmode = "noselect"

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
  if vim.env.SSH_TTY then
    vim.g.clipboard = "osc52"
  end
end)

