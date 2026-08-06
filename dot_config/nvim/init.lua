vim.g.mapleader = " "

-- Allow for when user may not be able to write to $HOME
if vim.env.NVIM_NO_PERSIST then
  vim.o.shadafile  = "NONE"   -- no shada/viminfo
  vim.o.swapfile   = false
  vim.o.undofile   = false
  vim.o.backup     = false
  vim.o.writebackup= false
end
