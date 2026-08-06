-- Plugin settings
---@diagnostic disable: undefined-global

require("mini.ai").setup {}
require("mini.extra").setup {}
require("mini.bracketed").setup {}
require("mini.cmdline").setup {}
require("mini.colors").setup {}
require("mini.comment").setup {}
require("mini.completion").setup {}
require("mini.diff").setup {}
require("mini.files").setup {
  windows = {
    preview = true,
    width_preview = 50,
  },
  mappings = {
    go_in = "L",
    go_in_plus = "l",
  },
}
vim.keymap.set("n", "-", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = "Open Mini Files" })
local show_dotfiles = true
local filter_show = function(fs_entry) return true end
local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end
local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "<ESC>", function() MiniFiles.close() end, { buffer = buf_id })
    vim.keymap.set("n", "-", function() MiniFiles.go_out() end, { buffer = buf_id })
    vim.keymap.set("n", "<Return>", function() MiniFiles.go_in({close_on_file = true}) end, { buffer = buf_id })
    vim.keymap.set("n", "g.", function() toggle_dotfiles() end, { buffer = buf_id })
  end,
})
require("mini.git").setup {}
require("mini.hipatterns").setup({
  highlighters = {
    -- Highlight standalone "FIXME", "HACK", "TODO", "NOTE"
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack"  },
    todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo"  },
    note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote"  },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
  },
})
require("mini.icons").setup {}
MiniIcons.mock_nvim_web_devicons()
require("mini.indentscope").setup {}
require("mini.input").setup {}
require("mini.jump").setup {}
require("mini.jump2d").setup {}
require("mini.keymap").setup {}
MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
require("mini.notify").setup {}
vim.keymap.set("n", "<leader>sn", function() MiniNotify.show_history() end, { desc = "Show Notification History" })
vim.keymap.set("n", "<leader>un", function() MiniNotify.clear() end, { desc = "Clear notifications" })
require("mini.pairs").setup({ modes = { command = true } })
require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
    require("mini.snippets").gen_loader.from_lang(),
  },
})
MiniSnippets.start_lsp_server()

require("mini.statusline").setup {
  use_icons = true,
  content = {
    active = function()
      local function get_current_function(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
        if not ok or not parser then
          return nil
        end
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, col = cursor[1] - 1, cursor[2]
        local root = parser:parse()[1]:root()
        local node = root:named_descendant_for_range(row, col, row, col)
        local FUNCTION_NODE_TYPES = {
          "function_declaration",
          "function",
          "arrow_function",
          "method_definition",
          "function_definition",
        }
        while node do
          if vim.tbl_contains(FUNCTION_NODE_TYPES, node:type()) then
            local name_node = node:field("name")[1]
            if name_node then
              return vim.treesitter.get_node_text(name_node, bufnr)
            end
            local parent = node:parent()
            if parent then
              for child in parent:iter_children() do
                if child:type() == "identifier" or child:type() == "property_identifier" then
                  return vim.treesitter.get_node_text(child, bufnr)
                end
              end
            end
          end
          node = node:parent()
        end
        return nil
      end

      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local recording     = vim.fn.reg_recording() ~= "" and ("\u{eba7} @"..vim.fn.reg_recording()) or ""
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location      = MiniStatusline.section_location({ trunc_width = 75 })
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
      local funcname = ""
      funcname = get_current_function() and ("\u{f0295} " .. get_current_function()) or ""

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        { hl = "DiagnosticInfo", strings = { funcname } },
        "%=", -- End left alignment
        { hl = "MiniDiffOverDelete", strings = { recording } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end
  }
}

require("mini.surround").setup {
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
}

require("mini.pick").setup {}
MiniPick.registry.files = function(local_opts)
  local opts = { source = { cwd = local_opts.cwd } }
  local_opts.cwd = nil
  return MiniPick.builtin.files(local_opts, opts)
end
vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>bb", function() MiniPick.builtin.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sc", function() MiniExtra.pickers.history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() MiniExtra.pickers.colorschemes() end, { desc = "Color Schemes" })
vim.keymap.set("n", "<leader>sd", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostic" })
vim.keymap.set("n", "<leader>sf", function() MiniPick.builtin.files() end, { desc = "Files" })
vim.keymap.set("n", "<leader>sF", function() MiniExtra.pickers.explorer() end, { desc = "File Explorer" })
vim.keymap.set("n", "<leader>sg", ":Pick files cwd='" .. vim.fn.expand("$HOME/git") .. "'<CR>", { desc = "Find Files ~/git" })
vim.keymap.set("n", "<leader>sG", function() MiniExtra.pickers.git_hunks() end, { desc = "Git Hunks" })
vim.keymap.set("n", "<leader>sh", function() MiniPick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>sH", function() MiniExtra.pickers.hipatterns() end, { desc = "Highlight Patterns" })
vim.keymap.set("n", "<leader>sk", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function() MiniExtra.pickers.lsp() end, { desc = "LSP References" })
vim.keymap.set("n", "<leader>so", function() MiniExtra.pickers.oldfiles({ preserve_order = true }) end, { desc = "Old Files" })
vim.keymap.set("n", "<leader>sr", function() MiniExtra.pickers.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sR", function() MiniPick.builtin.resume() end, { desc = "Resume Last Picker" })
vim.keymap.set("n", "<leader>ss", ":Pick files cwd='" .. vim.fn.expand("$HOME/src") .. "'<CR>", { desc = "Find Files ~/src" })
vim.keymap.set("n", "<leader>st", function() MiniExtra.pickers.treesitter() end, { desc = "Tree-sitter nodes" })
vim.keymap.set("n", "<leader>sv", ":Pick files cwd='" .. vim.fn.stdpath("config") .. "'<CR>", { desc = "Find Files Vim Config" })

vim.keymap.set("n", "<leader>cd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, { desc = "LSP Definition" })
vim.keymap.set("n", "<leader>cD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, { desc = "LSP Declaration" })
vim.keymap.set("n", "<leader>ci", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, { desc = "LSP Implementation" })
vim.keymap.set("n", "<leader>cr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, { desc = "LSP References" })
vim.keymap.set("n", "<leader>ct", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, { desc = "LSP Type Definition" })
vim.keymap.set("n", "<leader>cw", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" }) end, { desc = "LSP Workspace Symbol" })

require("mini.clue").setup({
  window = {
    delay = 200,
  },
  triggers = {
    { mode = { "n", "x" }, keys = "<leader>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "i", keys = "C-x>" },
    { mode = { "n", "x" }, keys = "g" },
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
    { mode = { "n", "x" }, keys = "z" },
  },
  clues = {
    require("mini.clue").gen_clues.square_brackets(),
    require("mini.clue").gen_clues.builtin_completion(),
    require("mini.clue").gen_clues.g(),
    require("mini.clue").gen_clues.marks(),
    require("mini.clue").gen_clues.registers(),
    require("mini.clue").gen_clues.windows(),
    require("mini.clue").gen_clues.z(),
    { mode = { "n" }, keys="<leader>b", desc = "Buffer"},
    { mode = { "n" }, keys="<leader>c", desc = "Code"},
    { mode = { "n" }, keys="<leader>s", desc = "Search"},
    { mode = { "n" }, keys="<leader>u", desc = "UI/Update"},
    { mode = { "n" }, keys="gs", desc = "Surround"},
  },
})
