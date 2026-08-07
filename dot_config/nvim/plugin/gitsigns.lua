local ok, plugin_config = pcall(require, 'gitsigns')
if ok then
  plugin_config.setup {
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          plugin_config.nav_hunk('next')
        end
      end, { desc = 'Jump to next git change' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          plugin_config.nav_hunk('prev')
        end
      end, { desc = 'Jump to previous git change' })

      -- map("n", "[h", function() plugin_config.nav_hunk("prev") end, { desc = "Previous Hunk" })
      -- map("n", "]h", function() plugin_config.nav_hunk("next") end, { desc = "Next Hunk" })
      map("n", "[H", function() plugin_config.nav_hunk("first") end, { desc = "First Hunk" })
      map("n", "]H", function() plugin_config.nav_hunk("last") end, { desc = "Last Hunk" })

      -- Actions
      -- visual mode
      map('v', '<leader>ghs', function() plugin_config.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git stage hunk' })
      map('v', '<leader>ghr', function() plugin_config.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git reset hunk' })
      -- normal mode
      map('n', '<leader>ghs', plugin_config.stage_hunk, { desc = 'git stage hunk' })
      map('n', '<leader>ghr', plugin_config.reset_hunk, { desc = 'git reset hunk' })
      map('n', '<leader>ghS', plugin_config.stage_buffer, { desc = 'git Stage buffer' })
      map('n', '<leader>ghR', plugin_config.reset_buffer, { desc = 'git Reset buffer' })
      map('n', '<leader>ghp', plugin_config.preview_hunk, { desc = 'git preview hunk' })
      map('n', '<leader>ghi', plugin_config.preview_hunk_inline, { desc = 'git preview hunk inline' })
      map('n', '<leader>ghb', function() plugin_config.blame_line { full = true } end, { desc = 'git blame line' })
      map('n', '<leader>ghd', plugin_config.diffthis, { desc = 'git diff against index' })
      map('n', '<leader>ghD', function() plugin_config.diffthis '@' end, { desc = 'git Diff against last commit' })
      map('n', '<leader>ghQ', function() plugin_config.setqflist 'all' end, { desc = 'git hunk Quickfix list (all files in repo)' })
      map('n', '<leader>ghq', plugin_config.setqflist, { desc = 'git hunk quickfix list (all changes in this file)' })
      -- map("n", "<leader>ghu", plugin_config.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      -- Toggles
      map('n', '<leader>ugB', plugin_config.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
      map('n', '<leader>ugW', plugin_config.toggle_word_diff, { desc = 'Toggle git intra-line word diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', plugin_config.select_hunk)
    end,
  }
end
