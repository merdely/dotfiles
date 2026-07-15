-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del({ "i", "n", "x" }, "<A-j>")
vim.keymap.del({ "i", "n", "x" }, "<A-k>")

vim.keymap.set("n", "<leader>fL", function() Snacks.picker.files({ cwd = vim.fn.stdpath("data") }) end, { desc = "Find Config Files (LazyVim)" })
vim.keymap.set("n", "<leader>sL", function() Snacks.picker.grep({ dirs = { vim.fn.stdpath("data") .. "/lazy/LazyVim/lua/lazyvim" } }) end, { desc = "Grep (LazyVim)" })

vim.keymap.set("n", "<A-->", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-=>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-->", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-=>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-->", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-=>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

