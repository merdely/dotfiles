local ok, plugin_config = pcall(require, "trouble")
if ok then
  plugin_config.setup({
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  })
end
