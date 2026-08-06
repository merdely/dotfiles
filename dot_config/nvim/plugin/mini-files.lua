---@diagnostic disable: undefined-global

local ok, plugin_config = pcall(require, "mini.files")
if ok then
  plugin_config.setup {
    windows = {
      preview = true,
      width_preview = 50,
    },
    mappings = {
      go_in = "",
      go_in_plus = "<Return>",
      go_out = "-",
      go_out_plus = ""
    },
  }
  vim.keymap.set("n", "-", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = "Open Mini Files" })
  local show_dotfiles = true
  ---@diagnostic disable-next-line: unused-local
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
      -- vim.keymap.set("n", "-", function() MiniFiles.go_out() end, { buffer = buf_id })
      -- vim.keymap.set("n", "<Return>", function() MiniFiles.go_in({close_on_file = true}) end, { buffer = buf_id })
      vim.keymap.set("n", "g.", function() toggle_dotfiles() end, { buffer = buf_id })
    end,
  })
end
