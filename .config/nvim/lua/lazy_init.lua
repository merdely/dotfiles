-- ============================================================================
-- BOOTSTRAP lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- SETUP lazy.nvim
-- ============================================================================
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "nightfly" } },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
})

-- theme & transparency
vim.cmd.colorscheme("nightfly")                       -- added by mwe
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- require('mini.statusline').setup()
require('lualine').setup({
  options = {
    THEME = "NIGHTFLY",
  }
})

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Use Oil file manager" })

