-- Ensure basic parsers are installed
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown',
  'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local indent_blocklist = { bash = true }
  local has_indent_query = not indent_blocklist[language]
    and vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

require("nvim-treesitter-textobjects").setup {
  move = {
    set_jumps = true,
  },
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      ["@class.outer"] = "<c-v>", -- blockwise
    },
    include_surrounding_whitespace = false,
  },
}
local ts_move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({"n","x","o"}, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end, { desc = "Jump to Next Function Start" })
vim.keymap.set({"n","x","o"}, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end, { desc = "Jump to Next Class Start" })
vim.keymap.set({"n","x","o"}, "]o", function() ts_move.goto_next_start({ "@loop.outer", "@loop.inner" }, "textobjects") end, { desc = "Jump to Next Loop Start" })
vim.keymap.set({"n","x","o"}, "]s", function() ts_move.goto_next_start("@local.scope", "locals") end, { desc = "Jump to Next Scope Start" })
vim.keymap.set({"n","x","o"}, "]z", function() ts_move.goto_next_start("@fold", "folds") end, { desc = "Jump to Next Fold Start" })
vim.keymap.set({"n","x","o"}, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end, { desc = "Jump to Next Function End" })
vim.keymap.set({"n","x","o"}, "][", function() ts_move.goto_next_end("@class.outer", "textobjects") end, { desc = "Jump to Next Class End" })
vim.keymap.set({"n","x","o"}, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Jump to Previous Function Start" })
vim.keymap.set({"n","x","o"}, "[]", function() ts_move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Jump to Previous Class Start" })
vim.keymap.set({"n","x","o"}, "[o", function() ts_move.goto_previous_start({ "@loop.outer", "@loop.inner" }, "textobjects") end, { desc = "Jump to Previous Loop Start" })
vim.keymap.set({"n","x","o"}, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Jump to Previous Function End" })
vim.keymap.set({"n","x","o"}, "[[", function() ts_move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Jump to Previous Class end" })
vim.keymap.set({"n","x","o"}, "]c", function() ts_move.goto_next("@conditional.outer", "textobjects") end, { desc = "Jump to Next Conditional" })
vim.keymap.set({"n","x","o"}, "[c", function() ts_move.goto_previous("@conditional.outer", "textobjects") end, { desc = "Jump to Previous Conditional" })
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
vim.keymap.set({"n","x","o"}, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat Last Move Next" })
vim.keymap.set({"n","x","o"}, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat Last Move Previous" })
vim.keymap.set({"n","x","o"}, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({"n","x","o"}, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({"n","x","o"}, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({"n","x","o"}, "T", ts_repeat_move.builtin_T_expr, { expr = true })
vim.keymap.set({"n","x","o"}, "<home>", function() ts_repeat_move.repeat_last_move({ forward = false, start = true }) end, { desc = "Repeat Last Move with Previous Direction" })
vim.keymap.set({"n","x","o"}, "<end>", function() ts_repeat_move.repeat_last_move({ forward = true, start = false }) end, { desc = "Repeat Last Move with Next Direction" })

local ts_select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({"x","o"}, "am", function() ts_select.select_textobject("@function.outer", "textobjects") end, { desc = "function" })
vim.keymap.set({"x","o"}, "im", function() ts_select.select_textobject("@function.inner", "textobjects") end, { desc = "function" })
vim.keymap.set({"x","o"}, "ac", function() ts_select.select_textobject("@class.outer", "textobjects") end, { desc = "class" })
vim.keymap.set({"x","o"}, "ic", function() ts_select.select_textobject("@class.inner", "textobjects") end, { desc = "class" })
vim.keymap.set({"x","o"}, "aS", function() ts_select.select_textobject("@local.scope", "locals") end, { desc = "scope" })
vim.keymap.set({"x","o"}, "aC", function() ts_select.select_textobject("@comment.outer", "textobjects") end, { desc = "comment" })
vim.keymap.set({"x","o"}, "iC", function() ts_select.select_textobject("@comment.inner", "textobjects") end, { desc = "comment" })

local ts_swap = require("nvim-treesitter-textobjects.swap")
-- Maybe use <leader>si, so, sI, sO
vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap Next Inner Parameter" })
vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.outer") end, { desc = "Swap Previous Outer Parameter" })

