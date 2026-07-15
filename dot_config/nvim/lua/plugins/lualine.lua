return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local trouble = require('trouble')
      local symbols = trouble.statusline {
        mode = 'symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      }
      local opts = {
        sections = {
          lualine_b = { "branch" },
          lualine_c = {
            { 'filename' },
            {
              "diagnostics",
              symbols = {
                error = LazyVim.config.icons.diagnostics.Error,
                warn = LazyVim.config.icons.diagnostics.Warn,
                info = LazyVim.config.icons.diagnostics.Info,
                hint = LazyVim.config.icons.diagnostics.Hint,
              },
            },
            {
              "diff",
              symbols = {
                added = LazyVim.config.icons.git.added,
                modified = LazyVim.config.icons.git.modified,
                removed = LazyVim.config.icons.git.removed,
              },
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
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            'encoding',
            'fileformat',
            'filetype'
          },
          lualine_z = {
            { '%l/%L:%c' },
          },
        },
      }
      return opts
    end
  }
}
-- return {
--   {
--     "nvim-lualine/lualine.nvim",
--     opts = function(_, opts)
--       -- Remove last two components
--       table.remove(opts.sections.lualine_c, #opts.sections.lualine_c)
--       table.remove(opts.sections.lualine_c, #opts.sections.lualine_c)
--       for i, component in ipairs(opts.sections.lualine_x) do
--         if component[1] == "" then
--           opts.sections.lualine_x[i] = { LazyVim.lualine.pretty_path() }
--           break
--         end
--       end
--       table.insert(opts.sections.lualine_x, {
--         { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
--       })
--       opts.sections.lualine_y = {
--         { "progress", separator = " ", padding = { left = 1, right = 0 } },
--       }
--       opts.sections.lualine_z = {
--         { "location", padding = { left = 0, right = 1 } },
--       }
--       -- opts.sections.lualine_c = {
--       --   -- LazyVim.lualine.root_dir(),
--       --   { LazyVim.lualine.pretty_path() },
--       --   {
--       --     "diagnostics",
--       --     symbols = {
--       --       error = LazyVim.config.LazyVim.config.icons.diagnostics.Error,
--       --       warn = LazyVim.config.LazyVim.config.icons.diagnostics.Warn,
--       --       info = LazyVim.config.LazyVim.config.icons.diagnostics.Info,
--       --       hint = LazyVim.config.LazyVim.config.icons.diagnostics.Hint,
--       --     },
--       --   },
--       -- }
--       -- opts.sections.lualine_x = {
--       --   Snacks.profiler.status(),
--       --   -- stylua: ignore
--       --   {
--       --     function() return require("noice").api.status.command.get() end,
--       --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
--       --     color = function() return { fg = Snacks.util.color("Statement") } end,
--       --   },
--       --   -- stylua: ignore
--       --   {
--       --     function() return require("noice").api.status.mode.get() end,
--       --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
--       --     color = function() return { fg = Snacks.util.color("Constant") } end,
--       --   },
--       --   -- stylua: ignore
--       --   {
--       --     function() return "  " .. require("dap").status() end,
--       --     cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
--       --     color = function() return { fg = Snacks.util.color("Debug") } end,
--       --   },
--       --   -- stylua: ignore
--       --   {
--       --     require("lazy.status").updates,
--       --     cond = require("lazy.status").has_updates,
--       --     color = function() return { fg = Snacks.util.color("Special") } end,
--       --   },
--       --   {
--       --     "diff",
--       --     symbols = {
--       --       added = LazyVim.config.LazyVim.config.icons.git.added,
--       --       modified = LazyVim.config.LazyVim.config.icons.git.modified,
--       --       removed = LazyVim.config.LazyVim.config.icons.git.removed,
--       --     },
--       --     source = function()
--       --       local gitsigns = vim.b.gitsigns_status_dict
--       --       if gitsigns then
--       --         return {
--       --           added = gitsigns.added,
--       --           modified = gitsigns.changed,
--       --           removed = gitsigns.removed,
--       --         }
--       --       end
--       --     end,
--       --   },
--       --   { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
--       -- }
--     end,
--   }
-- }
--
