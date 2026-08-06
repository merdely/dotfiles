vim.g.mapleader = " "

-- Allow for when user may not be able to write to $HOME
if vim.env.NVIM_NO_PERSIST then
  vim.o.shadafile  = "NONE"   -- no shada/viminfo
  vim.o.swapfile   = false
  vim.o.undofile   = false
  vim.o.backup     = false
  vim.o.writebackup= false
end

require("options")
require("functions")
require("lsp")
require("treesitter")
require("plugins")
require("colorscheme")
require("autocommands")
require("diagnostics")
require("formatting")
require("keymaps")

-- require("statusline")
-- require("netrw")
-- require("find")
-- require("grep")
