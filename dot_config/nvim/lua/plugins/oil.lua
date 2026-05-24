return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["gv"]    = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["gh"]    = { "actions.select", opts = { horizontal = true } },
      ["<ESC>"] = { "actions.close", mode = "n" },
      -- default g keybinds
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
      -- My keybinds
      ["GA"] = { function() require("oil").open(vim.fn.expand("$HOME/src/ansible")) end, desc = "Change to ansible directory" },
      ["GB"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/bin")) end, desc = "Change to ~/.local/bin" },
      ["Gb"] = { function() require("oil").open(vim.fn.expand("$HOME/src/scripts/bin")) end, desc = "Change to ~/src/scripts/bin" },
      ["GC"] = { function() require("oil").open(vim.fn.expand("$HOME/.config")) end, desc = "Change to HOME .config directory" },
      ["GD"] = { desc = "Prompt for directory to change to", function()
        vim.ui.input({ prompt = "Directory: ", completion = "dir" }, function(dir)
          if dir and dir ~= "" then
            require("oil").open(vim.fn.expand(dir))
          end
        end)
      end },
      ["Gd"] = { function() require("oil").open(vim.fn.expand("$HOME/Downloads")) end, desc = "Change to Downloads directory" },
      ["GE"] = { function() require("oil").open(vim.fn.expand("/etc")) end, desc = "Change to /etc" },
      ["GF"] = { function() require("oil").open(vim.fn.expand("#:p:h")) end, desc = "Change to directory of file opened in original buffer" },
      ["GG"] = { function() require("oil").open(vim.fn.expand("$HOME/git")) end, desc = "Change to ~/git" },
      ["GH"] = { function() require("oil").open(vim.fn.expand("$HOME")) end, desc = "Change to HOME directory" },
      ["GL"] = { function() require("oil").open(vim.fn.expand("$HOME/.local")) end, desc = "Change to ~/.local directory" },
      ["Gl"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/share/Syncthing/Logseq/Mike\\'s\\ Notes")) end, desc = "Change to logseq directory" },
      ["GM"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim")) end, desc = "Change to nvim directory" },
      ["Gm"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/DankMaterialShell")) end, desc = "Change to dms config directory" },
      ["GN"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/niri")) end, desc = "Change to niri directory" },
      ["GO"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim/lua/plugins"), {}, function() vim.fn.search("oil\\.lua", "wc") end) end, desc = "Open Oil Config" },
      ["GP"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim/lua/plugins")) end, desc = "Change to nvim plugins directory" },
      ["GR"] = { function() require("oil").open(vim.fn.expand("/srv/scripts")) end, desc = "Change to /srv/scripts" },
      ["Gr"] = { function() require("oil").open(vim.fn.expand("/srv/docker")) end, desc = "Change to /srv/docker" },
      ["GS"] = { function() require("oil").open(vim.fn.expand("$HOME/src")) end, desc = "Change to src directory" },
      ["Gs"] = { function() require("oil").open(vim.fn.expand("$HOME/src/scripts")) end, desc = "Change to scripts src directory" },
      ["GT"] = { function() require("oil").open(vim.fn.expand("/run/user/$EUID/tmp")) end, desc = "Change to ~tmp" },
      ["GV"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/vim")) end, desc = "Change to vim directory" },
      ["GW"] = { function() require("oil").open(vim.fn.expand("$HOME/Work")) end, desc = "Change to ~/Work" },
      ["GX"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/share/Syncthing")) end, desc = "Change to Syncthing directory" },
      ["GY"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/yazi")) end, desc = "Change to Yazi directory" },
    },
  },
  keys = {
    { "-", "<CMD>Oil --float<CR>", desc = "Use Oil file manager" },
    { "<leader>e", ":Oil --float<CR>", desc = "Open file explorer" },
  },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}

