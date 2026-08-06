local ok, plugin_config = pcall(require, "snacks")
if ok then
  plugin_config.setup({
    bufdelete = { enabled = true },
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil }, -- requires lazy.vim
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", limit = 10, indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", limit = 10, indent = 2, padding = 1 },
        -- { section = "startup" }, -- requires lazy.vim
      },
    },
    debug = { enabled = true },
    -- explorer = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    -- picker = {
    --   enabled = true,
    --   sources = {
    --     files = { hidden = true },
    --
    --   },
    --   -- win = {
    --   --   input = {
    --   --     keys = {
    --   --       ["<Esc>"] = { "close", mode = { "n", "i" } },
    --   --       ["<C-c>"] = { "cancel", mode = { "n", "i" } },
    --   --     },
    --   --   },
    --   -- },
    -- },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-w><C-h>", "<c-\\><c-n><c-w>h", desc = "Go to left window", expr = true, mode = "t" },
          nav_j = { "<C-w><C-j>", "<c-\\><c-n><c-w>j", desc = "Go to lower window", expr = true, mode = "t" },
          nav_k = { "<C-w><C-k>", "<c-\\><c-n><c-w>k", desc = "Go to upper window", expr = true, mode = "t" },
          nav_l = { "<C-w><C-l>", "<c-\\><c-n><c-w>l", desc = "Go to right window", expr = true, mode = "t" },
          term_normal = { "<esc><esc>", "<c-\\><c-n>", desc = "Escape from terminal buffer", expr = true, mode = "t" },
          hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
    toggle = { enabled = true },
    util = { enabled = true },
    win = { enabled = true },
  })

  _G.dd = function(...)
    Snacks.debug.inspect(...)
  end
  _G.bt = function()
    Snacks.debug.backtrace()
  end
  if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
      dd(...)
    end
  else
    vim.print = dd
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function(event)
      vim.o.autocomplete = false
      vim.api.nvim_create_autocmd("BufLeave", {
        buffer = event.buf,
        once = true,
        callback = function()
          vim.o.autocomplete = true
        end,
      })
    end,
  })
end
