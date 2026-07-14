-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.colorcolumn = "80"
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.showmatch = true
vim.g.autoformat = false
vim.opt.autowrite = false
vim.opt.inccommand = "split"
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 0
vim.opt.wrap = true
vim.opt.listchars = {
    tab = '󰌒 ',
    trail = '·',
    extends = '»',
    precedes = '«',
}

vim.opt.showtabline = 0
