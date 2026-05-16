require("lazy").setup({
  spec = {
    { "RRethy/base16-nvim", enabled = false },
    { import = "plugins" }
  },
  install = { colorscheme = { "nightfly" } },
  change_detection = {
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
})
