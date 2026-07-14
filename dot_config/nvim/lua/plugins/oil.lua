return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 1,
      max_width = 0.80,
    },
    keymaps = {
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<ESC>'] = { 'actions.close', mode = 'n' },
      -- Default g keybinds: ~ s x . \
      ['gC'] = { function() require('oil').open(vim.fn.expand('$HOME/.config')) end, desc = 'Change to HOME .config directory' },
      ['gH'] = { function() require('oil').open(vim.fn.expand('$HOME')) end, desc = 'Change to HOME directory' },
      ['gK'] = { function() require('oil').open(vim.fn.expand('/srv/docker')) end, desc = 'Change to /srv/docker' },
      ['gL'] = { function() require('oil').open(vim.fn.expand('$HOME/.local')) end, desc = 'Change to ~/.local directory' },
      ['gR'] = { function() require('oil').open(vim.fn.expand('/srv/scripts')) end, desc = 'Change to /srv/scripts' },
      ['gS'] = { function() require('oil').open(vim.fn.expand('$HOME/src')) end, desc = 'Change to src directory' },
      ['gT'] = { function() require('oil').open(vim.fn.expand('$HOME/.local/share/Syncthing')) end, desc = 'Change to Syncthing directory' },
      ['gV'] = { function() require('oil').open(vim.fn.expand('$HOME/.config/nvim')) end, desc = 'Change to nvim directory' },
      ['go'] = {
        desc = 'Prompt for directory to change to',
        function()
          vim.ui.input({ prompt = 'Directory: ', completion = 'dir' }, function(dir)
            if dir and dir ~= '' then
              require('oil').open(vim.fn.expand(dir))
            end
          end)
        end,
      },
    },
  },
  keys = {
    { "-", "<CMD>Oil --preview --float<CR>", desc = "Use Oil file manager" },
    { "<leader>e", ":Oil --float<CR>", desc = "Open file explorer" },
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
