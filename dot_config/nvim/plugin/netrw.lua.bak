vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_banner = 0 -- hide the top banner
vim.g.netrw_winsize = 25 -- fix the left split width
vim.g.netrw_browse_split = 0 -- open files in the previous window
vim.g.netrw_altfile = 1 -- keep the alternate file correct

vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })

-- Add shortcuts to netrw
local function netrw_open_if_exists(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded) == 1 or vim.fn.filereadable(expanded) == 1 then
    vim.cmd("e " .. expanded)
    vim.notify("Working directory: " .. expanded)
  else
    vim.notify(expanded .. " does not exist")
  end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(ev)
    vim.keymap.set("n", "<Escape>", "<C-^>", { buffer = ev.buf })
    local map = function(key, path)
      vim.keymap.set("n", key, function() netrw_open_if_exists(path) end, { desc = "Go to " .. path, buffer = true })
    end
    map("gC", "$HOME/.config")
    map("gE", "/etc")
    map("gH", "$HOME")
    map("gL", "$HOME/.local")
    map("gV", "$HOME/.config/nvim")
    map("gR", "/srv/scripts")
    map("gK", "/srv/docker")
    map("gS", "$HOME/src")
    map("gT", "$HOME/.local/share/Syncthing")
    map("gZ", "%:p:h")
    vim.keymap.set("n", "go", function()
      local input = vim.fn.input("cd: ", vim.fn.expand("%:p:h"), "dir")
      if input ~= "" then vim.cmd("e " .. input) end
    end, { desc = "Prompt for directory to go", buffer = true })
  end,
})

