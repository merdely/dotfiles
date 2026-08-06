---@diagnostic disable: undefined-global

local ok, plugin_config = pcall(require, "mini.pick")
if ok then
  plugin_config.setup {}
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
end
