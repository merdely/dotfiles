return {
  {
    {
      "saghen/blink.cmp",
      dependencies = { 'saghen/blink.lib' },
      -- Make blink.cmp toogleable
      -- build = function() require('blink.cmp').build():pwait() end,
      opts = function(_, opts)
        opts.completion = { list = { selection = { preselect = false } } }
        opts.fuzzy = { implementation = "lua" }
        vim.b.completion = false

        Snacks.toggle({
          name = "Completion",
          get = function()
            return vim.b.completion
          end,
          set = function(state)
            vim.b.completion = state
          end,
        }):map("<leader>uk")

        opts.enabled = function()
          return vim.b.completion ~= false
        end
        return opts
      end,
    },
  },
}
