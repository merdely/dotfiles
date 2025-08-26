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
  },
}
