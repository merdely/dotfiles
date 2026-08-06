---@diagnostic disable: undefined-global

local ok, plugin_config = pcall(require, "lualine")
if ok then
  local dap_loaded,     dap     = pcall(require, 'dap')
  local noice_loaded,   noice   = pcall(require, 'noice')
  local snacks_loaded,  snacks  = pcall(require, 'snacks')
  local trouble_loaded, trouble = pcall(require, 'trouble')
  if trouble_loaded then
    local symbols = trouble.statusline {
      mode = 'symbols',
      groups = {},
      title = false,
      filter = { range = true },
      format = '{kind_icon}{symbol.name:Normal}',
      hl_group = 'lualine_c_normal',
    }

    local recording     = vim.fn.reg_recording() ~= "" and ("\u{eba7} @"..vim.fn.reg_recording()) or ""

    plugin_config.setup {
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
          {
            function() Snacks.profiler.status()() end,
            cond = function() return snacks_loaded end,
          },
          {
            function() return noice.api.status.command.get() end,
            cond = function() return noice_loaded and noice.api.status.command.has() end,
            color = function() if snacks_loaded then return { fg = Snacks.util.color("Statement") } end end,
          },
          -- stylua: ignore
          {
            function() return noice.api.status.mode.get() end,
            cond = function() return noice_loaded and noice.api.status.mode.has() end,
            color = function() if snacks_loaded then return { fg = Snacks.util.color("Constant") } end end,
          },
          -- stylua: ignore
          {
            function() return "  " .. dap.status() end,
            cond = function() return dap_loaded and dap.status() ~= "" end,
            color = function() if snacks_loaded then return { fg = Snacks.util.color("Debug") } end end,
          },
          -- stylua: ignore
          -- {
          --   require("lazy.status").updates,
          --   cond = require("lazy.status").has_updates,
          --   color = function() if snacks_loaded then return { fg = Snacks.util.color("Special") } end end,
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
  else
    plugin_config.setup {
      options = {
        theme = "auto",
        globalstatus = false,
      },
    }
  end
end
