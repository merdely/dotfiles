do
  local ok = pcall(require, 'gitsigns')
  if ok then
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

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
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Jump to next git change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Jump to previous git change' })

        -- map("n", "[h", function() gitsigns.nav_hunk("prev") end, { desc = "Previous Hunk" })
        -- map("n", "]h", function() gitsigns.nav_hunk("next") end, { desc = "Next Hunk" })
        map("n", "[H", function() gitsigns.nav_hunk("first") end, { desc = "First Hunk" })
        map("n", "]H", function() gitsigns.nav_hunk("last") end, { desc = "Last Hunk" })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git stage hunk' })
        map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git reset hunk' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
        map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk inline' })
        map('n', '<leader>ghb', function() gitsigns.blame_line { full = true } end, { desc = 'git blame line' })
        map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>ghD', function() gitsigns.diffthis '@' end, { desc = 'git Diff against last commit' })
        map('n', '<leader>ghQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk Quickfix list (all files in repo)' })
        map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'git hunk quickfix list (all changes in this file)' })
        -- map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        -- Toggles
        map('n', '<leader>uB', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
        map('n', '<leader>uW', gitsigns.toggle_word_diff, { desc = 'Toggle git intra-line word diff' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    }
  end
end
