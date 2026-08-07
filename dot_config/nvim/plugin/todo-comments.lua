---@diagnostic disable: undefined-global

local ok, plugin_config = pcall(require, "todo-comments")
if ok then
  plugin_config.setup({ signs = false })
  local snacks_loaded, _ = pcall(require, "snacks")
  if snacks_loaded then
    vim.keymap.set("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Todo" })
    vim.keymap.set("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })
  end
  vim.keymap.set("n", "]n", function() plugin_config.jump_next() end, { desc = "Next Note/Todo Comment" })
  vim.keymap.set("n", "[n", function() plugin_config.jump_prev() end, { desc = "Previous Note/Todo Comment" })
end
