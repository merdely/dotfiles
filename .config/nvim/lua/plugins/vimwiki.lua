return {
  'vimwiki/vimwiki',
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/Logseq/Mike's Notes/",
        ext = '.md',
        syntax = 'markdown',
        index = 'pages/VimWiki',
        diary_rel_path = 'journals',
      },
    }
  end,
}
