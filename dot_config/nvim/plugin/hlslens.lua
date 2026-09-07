local ok, plugin_config = pcall(require, "hlslens")
if ok then
  plugin_config.setup {}
end
