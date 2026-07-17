local trouble = require('trouble')
local symbols = trouble.statusline {
  mode = 'symbols',
  groups = {},
  title = false,
  filter = { range = true },
  format = '{kind_icon}{symbol.name:Normal}',
  hl_group = 'lualine_c_normal',
}

require("lualine").setup {
  options = {
    theme = "auto",
    globalstatus = false,
  },
  sections = {
    lualine_b = { "branch" },
    lualine_c = {
      { 'filename' },
      {
        "diagnostics",
        -- symbols = {
        --   error = LazyVim.config.icons.diagnostics.Error,
        --   warn = LazyVim.config.icons.diagnostics.Warn,
        --   info = LazyVim.config.icons.diagnostics.Info,
        --   hint = LazyVim.config.icons.diagnostics.Hint,
        -- },
      },
      {
        "diff",
        -- symbols = {
        --   added = LazyVim.config.icons.git.added,
        --   modified = LazyVim.config.icons.git.modified,
        --   removed = LazyVim.config.icons.git.removed,
        -- },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
      {
        symbols.get,
        cond = symbols.has,
      },
    },
    lualine_x = {
      Snacks.profiler.status(),
      {
        function() return require("noice").api.status.command.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
        color = function() return { fg = Snacks.util.color("Statement") } end,
      },
      -- stylua: ignore
      {
        function() return require("noice").api.status.mode.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        color = function() return { fg = Snacks.util.color("Constant") } end,
      },
      -- stylua: ignore
      {
        function() return "  " .. require("dap").status() end,
        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
        color = function() return { fg = Snacks.util.color("Debug") } end,
      },
      -- stylua: ignore
      -- {
      --   require("lazy.status").updates,
      --   cond = require("lazy.status").has_updates,
      --   color = function() return { fg = Snacks.util.color("Special") } end,
      -- },
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_z = {
      { '%l/%L:%c' },
    },
  },
}
