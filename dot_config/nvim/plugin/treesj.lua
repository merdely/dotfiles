local ok, plugin_config = pcall(require, "treesj")
if ok then
  plugin_config.setup({use_default_keymaps = false,})
  vim.keymap.set("n", "<leader>m", plugin_config.toggle, { desc = "Toggle Split/Join Block" })
end
