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
      ["gA"] = { function() require("oil").open(vim.fn.expand("$HOME/src/ansible")) end, desc = "Change to ansible directory" },
      ["gB"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/bin")) end, desc = "Change to ~/.local/bin" },
      ["gb"] = { function() require("oil").open(vim.fn.expand("$HOME/src/scripts/bin")) end, desc = "Change to ~/src/scripts/bin" },
      ["gC"] = { function() require("oil").open(vim.fn.expand("$HOME/.config")) end, desc = "Change to HOME .config directory" },
      ["gc"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/DankMaterialShell")) end, desc = "Change to dms config directory" },
      ["gD"] = { desc = "Prompt for directory to change to", function()
        vim.ui.input({ prompt = "Directory: ", completion = "dir" }, function(dir)
          if dir and dir ~= "" then
            require("oil").open(vim.fn.expand(dir))
          end
        end)
      end },
      ["gd"] = { function() require("oil").open(vim.fn.expand("$HOME/Downloads")) end, desc = "Change to Downloads directory" },
      ["gE"] = { function() require("oil").open(vim.fn.expand("/etc")) end, desc = "Change to /etc" },
      ["gF"] = { function() require("oil").open(vim.fn.expand("#:p:h")) end, desc = "Change to directory of file opened in original buffer" },
      ["gG"] = { function() require("oil").open(vim.fn.expand("$HOME/git")) end, desc = "Change to ~/git" },
      ["gH"] = { function() require("oil").open(vim.fn.expand("$HOME")) end, desc = "Change to HOME directory" },
      ["gL"] = { function() require("oil").open(vim.fn.expand("$HOME/.local")) end, desc = "Change to ~/.local directory" },
      ["gl"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/share/Syncthing/Logseq/Mike\\'s\\ Notes")) end, desc = "Change to logseq directory" },
      ["gN"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim")) end, desc = "Change to nvim directory" },
      ["gn"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/niri")) end, desc = "Change to niri directory" },
      ["gO"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim/lua/plugins"), {}, function() vim.fn.search("oil\\.lua", "wc") end) end, desc = "Open Oil Config" },
      ["gP"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/nvim/lua/plugins")) end, desc = "Change to nvim plugins directory" },
      ["gR"] = { function() require("oil").open(vim.fn.expand("/srv/scripts")) end, desc = "Change to /srv/scripts" },
      ["gr"] = { function() require("oil").open(vim.fn.expand("/srv/docker")) end, desc = "Change to /srv/docker" },
      ["gS"] = { function() require("oil").open(vim.fn.expand("$HOME/src")) end, desc = "Change to ~/src" },
      ["gs"] = { function() require("oil").open(vim.fn.expand("$HOME/.local/share/Syncthing")) end, desc = "Change to Syncthing directory" },
      ["gT"] = { function() require("oil").open(vim.fn.expand("/run/user/$EUID/tmp")) end, desc = "Change to ~tmp" },
      ["gt"] = { function() require("oil").open(vim.fn.expand("$HOME/src/scripts")) end, desc = "Change to scripts src directory" },
      ["gW"] = { function() require("oil").open(vim.fn.expand("$HOME/src")) end, desc = "Change to ~/Work" },
      ["gY"] = { function() require("oil").open(vim.fn.expand("$HOME/.config/yazi")) end, desc = "Change to Yazi directory" },
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

