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
    theme = "nightfly",
  }
})

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Use Oil file manager" })

