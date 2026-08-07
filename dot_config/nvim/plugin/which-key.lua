local ok, plugin_config = pcall(require, 'which-key')
if ok then
  plugin_config.setup({
    preset = "helix",
    delay = 250,
    spec = {
      {
        mode = { "n", "x" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>ug", group = "git" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gr", group = "lsp actions" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  })
  vim.keymap.set('n', '<leader>?', function() plugin_config.show { global = false } end, { desc = 'Buffer Local Keymaps (which-key)' })
  -- vim.keymap.set('n', '<leader>?', function() plugin_config.show { global = true } end, { desc = 'Buffer Local Keymaps (which-key)' })
  vim.keymap.set("n", "<c-w><space>", function() plugin_config.show({ keys = "<c-w>", loop = true }) end, { desc = "Window Hydra Mode (which-key)" })
  -- if vim.wo.diff then
    -- plugin_config.add({
    --   { "]c", desc = "Next diff hunk", buffer = 0 },
    --   { "[c", desc = "Prev diff hunk", buffer = 0 },
    --   { "d", desc = "delete/diff"},
    --   { "do", desc = "Diff obtain", buffer = 0 },
    --   { "dp", desc = "Diff put", buffer = 0 },
    -- })
  -- end
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    callback = function()
      do
        if vim.wo.diff then
          plugin_config.add({
            { "]c", desc = "Next diff hunk", buffer = 0 },
            { "[c", desc = "Prev diff hunk", buffer = 0 },
          })
        end
        vim.keymap.set("n", "<leader>co", "do", { desc = "Diff obtain" })
        vim.keymap.set("n", "<leader>cp", "dp", { desc = "Diff put" })
      end
    end,
  })
end
