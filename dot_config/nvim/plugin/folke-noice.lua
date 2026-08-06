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
end

