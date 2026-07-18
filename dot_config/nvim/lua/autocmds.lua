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

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    if package.loaded["which-key"] then
      if vim.wo.diff then
        require("which-key").add({
          { "]c", desc = "Next diff hunk", buffer = 0 },
          { "[c", desc = "Prev diff hunk", buffer = 0 },
        })
      end
      vim.keymap.set("n", "<leader>co", "do", { desc = "Diff obtain" })
      vim.keymap.set("n", "<leader>cp", "dp", { desc = "Diff put" })
    end
  end,
})

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    -- if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
    --   run_build(name, { 'make' }, ev.data.path)
    --   return
    -- end

    if name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
      return
    end
  end,
})
