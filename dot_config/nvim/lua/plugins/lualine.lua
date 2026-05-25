return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    options = {
      theme = "nightfly",
      icons_enabled        = vim.g.use_glyphs == 1,
      section_separators   = vim.g.use_glyphs == 1
          and { left = '', right = '' }
          or  { left = '',  right = '' },
      component_separators = vim.g.use_glyphs == 1
          and { left = '', right = '' }
          or  { left = '|', right = '|' },
    },
}
