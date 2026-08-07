local ok, plugin_config = pcall(require, 'nvim-autopairs')
if ok then
  plugin_config.setup({})
end
