require("lazy").setup({
  spec = {
    { "RRethy/base16-nvim", enabled = false },
    { import = "plugins" }
  },
  install = { colorscheme = { "nightfly" } },
  change_detection = {
    enabled = true,
    notify  = true, -- get a notification when changes are found
  },
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |
