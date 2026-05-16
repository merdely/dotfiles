return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "<leader>ff", ":FzfLua files<CR>", desc = "Find files (current)" },
    { "<leader>fc", ":FzfLua files cwd=~/.config<CR>", desc = "Find file (.config)" },
    { "<leader>fh", ":FzfLua files cwd=~<CR>", desc = "Find file (home)" },
    { "<leader>fg", ":FzfLua live_grep cwd=~<CR>", desc = "Live Grep" },
    { "<leader>fb", ":FzfLua buffers cwd=~<CR>", desc = "Find buffers" },
    { "<leader>fh", ":FzfLua help_tags cwd=~<CR>", desc = "Find help" },
    -- { "<leader>fx", ":FzfLua diagnostics_document cwd=~<CR>", desc = "Find diagnostics document" },
    -- { "<leader>fX", ":FzfLua diagnostics_workspace cwd=~<CR>", desc = "Find diagnostics workspace" },
  },
}
