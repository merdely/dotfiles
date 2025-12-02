require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "nightfly" } },
  change_detection = {
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
})
