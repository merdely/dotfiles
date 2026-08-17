local ok, plugin_config = pcall(require, "oil")
if ok then
  plugin_config.setup({
    default_file_explorer = false,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 1,
      max_width = 0.80,
    },
    keymaps = {
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<ESC>"] = { "actions.close", mode = "n" },
      -- default g keybinds
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
      -- My keybinds
      ["gA"] = { function() plugin_config.open(vim.fn.expand("$HOME/src/ansible")) end, desc = "Change to ansible directory" },
      ["gB"] = { function() plugin_config.open(vim.fn.expand("$HOME/.local/bin")) end, desc = "Change to ~/.local/bin" },
      ["gC"] = { function() plugin_config.open(vim.fn.expand("$HOME/.config")) end, desc = "Change to HOME .config directory" },
      ["gD"] = { function() plugin_config.open(vim.fn.expand("$HOME/Downloads")) end, desc = "Change to Downloads directory" },
      ["gE"] = { function() plugin_config.open(vim.fn.expand("/etc")) end, desc = "Change to /etc" },
      ["gG"] = { function() plugin_config.open(vim.fn.expand("$HOME/git")) end, desc = "Change to ~/git" },
      ["gH"] = { function() plugin_config.open(vim.fn.expand("$HOME")) end, desc = "Change to HOME directory" },
      ["gJ"] = { function() plugin_config.open(vim.fn.expand("$HOME/.local/share/Syncthing/Logseq/Mike\\'s\\ Notes")) end, desc = "Change to logseq directory" },
      ["gK"] = { function() plugin_config.open(vim.fn.expand("/srv/docker")) end, desc = "Change to /srv/docker" },
      ["gL"] = { function() plugin_config.open(vim.fn.expand("$HOME/.local")) end, desc = "Change to ~/.local directory" },
      ["gN"] = { function() plugin_config.open(vim.fn.expand("$HOME/.config/nvim")) end, desc = "Change to nvim directory" },
      ["gQ"] = { function() plugin_config.open(vim.fn.expand("$HOME/src/scripts/bin")) end, desc = "Change to ~/src/scripts/bin" },
      ["gR"] = { function() plugin_config.open(vim.fn.expand("/srv/scripts")) end, desc = "Change to /srv/scripts" },
      ["gP"] = { function() plugin_config.open(vim.fn.expand("$HOME/src/scripts")) end, desc = "Change to scripts src directory" },
      ["gS"] = { function() plugin_config.open(vim.fn.expand("$HOME/src")) end, desc = "Change to src directory" },
      ["gT"] = { function() plugin_config.open(vim.fn.expand("/run/user/$EUID/tmp")) end, desc = "Change to ~tmp" },
      ["gV"] = { function() plugin_config.open(vim.fn.expand("$HOME/.config/vim")) end, desc = "Change to vim directory" },
      ["gX"] = { function() plugin_config.open(vim.fn.expand("$HOME/.local/share/Syncthing")) end, desc = "Change to Syncthing directory" },
      ["gO"] = { function() plugin_config.open(vim.fn.expand("/home/mike.old/.config/nvim-test")) end, desc = "Change to nvim directory" },
      ["geD"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://earth.erdely.in//srv/docker/")) end, desc = "Change to nvim directory" },
      ["geH"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://earth.erdely.in//home/mike/")) end, desc = "Change to nvim directory" },
      ["gjD"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://jupiter.erdely.in//srv/docker/")) end, desc = "Change to nvim directory" },
      ["gjH"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://jupiter.erdely.in//home/mike/")) end, desc = "Change to nvim directory" },
      ["gpH"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://pluto.erdelynet.com//home/mike/")) end, desc = "Change to nvim directory" },
      ["gcD"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://ceres.erdelynet.com//srv/docker/")) end, desc = "Change to nvim directory" },
      ["gcH"] = { function() plugin_config.open(vim.fn.expand("oil-ssh://ceres.erdelynet.com//home/mike/")) end, desc = "Change to nvim directory" },
      ["go"] = {
        desc = "Prompt for directory to change to",
        function()
          vim.ui.input({ prompt = "Directory: ", completion = "dir" }, function(dir)
            if dir and dir ~= "" then
              plugin_config.open(vim.fn.expand(dir))
            end
          end)
        end,
      },
    },
  })
  vim.keymap.set("n", "-", ":Oil --preview --float<CR>", { silent = true, desc = "Open Oil file manager" })
end
