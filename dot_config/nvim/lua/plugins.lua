vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/bluz71/vim-nightfly-colors',
  'https://github.com/folke/noice.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/windwp/nvim-autopairs',
}

require('guess-indent').setup {}
require('nvim-autopairs').setup {}
require('todo-comments').setup { signs = false }

-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup {}
require('mini.icons').setup {}
MiniIcons.mock_nvim_web_devicons()

require("noice").setup {
  lsp = {
    messages = { enabled = true },
  },
  messages = { enabled = true },
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
  },
  routes = {
    {
      view = "notify",
      filter = { event = "msg_showmode" },
    },
  },
}

require("snacks").setup {
  lazygit = { enabled = true },
  picker = {
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  },
  profiler = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  toggle = { enabled = true },
  util = { enabled = true },
}

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_picker_input',
  callback = function(event)
    vim.o.autocomplete = false
    vim.api.nvim_create_autocmd('BufLeave', {
      buffer = event.buf,
      once = true,
      callback = function() vim.o.autocomplete = true end,
    })
  end,
})

-- require('gitsigns').setup {
--   signs = {
--     add = { text = '+' }, ---@diagnostic disable-line: missing-fields
--     change = { text = '~' }, ---@diagnostic disable-line: missing-fields
--     delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
--     topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
--     changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
--   },
-- }

require('which-key').setup {
  preset = "helix",
  delay = 0,
  spec = {
    { "<leader>c", group = "code" },
    { "<leader>f", group = "file/find" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "git hunk", mode = { 'n', 'v' } },
    { "<leader>s", group = "search", mode = { 'n', 'v' } },
    { "<leader>t", group = "toggle" },
    { "<leader>u", group = "ui" },
    { "[", group = "previous" },
    { "]", group = "next" },
    { "g", group = "goto" },
    { "gr", group = "lsp actions" },
    { "sa", group = "surround" },
  }
}

vim.g.nightflyTransparent = true
vim.cmd "colorscheme nightfly"
