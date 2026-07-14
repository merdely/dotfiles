-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "i", "n", "x" }, "<A-j>")
vim.keymap.del({ "i", "n", "x" }, "<A-k>")
vim.keymap.set("n", "<leader>fL", function() Snacks.picker.files({ cwd = vim.fn.stdpath("data") }) end, { desc = "Find Config Files (LazyVim)" })
vim.keymap.set("n", "<leader>sL", function() Snacks.picker.grep({ dirs = { vim.fn.stdpath("data") .. "/lazy/LazyVim/lua/lazyvim" } }) end, { desc = "Grep (LazyVim)" })

