local nui_installed = pcall(require, 'nui.popup')
local ok, plugin_config = pcall(require, 'noice')
if nui_installed and ok then
  plugin_config.setup({
    lsp = {
      messages = { enabled = true },
    },
    messages = { enabled = true },
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
  })

  vim.keymap.set('n', "<leader>snL", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
  vim.keymap.set('n', "<leader>snH", function() require("noice").cmd("history") end, { desc = "Noice History" })
  vim.keymap.set('n', "<leader>sna", function() require("noice").cmd("all") end, { desc = "Noice All" })
  vim.keymap.set("n", "<leader>snD", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })
  vim.keymap.set('n', "<leader>snt", function() require("noice").cmd("pick") end, { desc = "Noice Picker (Telescope/FzfLua)" })
end

