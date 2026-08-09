---@diagnostic disable: undefined-global

local plugins = {
  "mini.ai",
  "mini.extra",
  "mini.bracketed",
  "mini.cmdline",
  "mini.colors",
  "mini.comment",
  "mini.completion",
  "mini.diff",
  -- "mini.git",
  -- "mini.indentscope",
  "mini.input",
  "mini.jump",
  "mini.jump2d",
}
for _, plugin in ipairs(plugins) do
  local ok, plugin_config = pcall(require, plugin)
  if ok then plugin_config.setup {} end
end

do
  local ok, plugin_config = pcall(require, "mini.icons")
  if ok then
    plugin_config.setup { }
    MiniIcons.mock_nvim_web_devicons()
  end
end

do
  local ok, plugin_config = pcall(require, "mini.keymap")
  if ok then
    plugin_config.setup { }
    MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
    MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
    MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept" })
    -- MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
    -- MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
  end
end

-- do
--   local ok, plugin_config = pcall(require, "mini.notify")
--   if ok then
--     plugin_config.setup { }
--     vim.keymap.set("n", "<leader>sn", function() MiniNotify.show_history() end, { desc = "Show Notification History" })
--     vim.keymap.set("n", "<leader>un", function() MiniNotify.clear() end, { desc = "Clear notifications" })
--   end
-- end

-- do
--   local ok, plugin_config = pcall(require, "mini.pairs")
--   if ok then plugin_config.setup { modes = { command = true } } end
-- end

do
  local ok, plugin_config = pcall(require, "mini.snippets")
  if ok then
    plugin_config.setup({
      snippets = {
        require("mini.snippets").gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
        require("mini.snippets").gen_loader.from_lang({
          lang_patterns = {
            bash = { "sh.json" },
          },
        }),
      },
    })
    MiniSnippets.start_lsp_server()
  end
end

