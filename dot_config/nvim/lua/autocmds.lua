vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize splits when window is resized",
  callback = function() vim.cmd("tabdo wincmd =") end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use 4 spaces for tabs with some filetypes",
  pattern = { "python", "php", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Prevent '#' from de-indenting in YAML files",
  pattern = { "yaml", "yaml.ansible" },
  callback = function() vim.opt_local.indentkeys:remove("0#") end,
})
