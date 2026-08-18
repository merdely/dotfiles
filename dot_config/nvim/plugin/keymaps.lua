-- Write and quit
-- vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "Write buffer" })
-- vim.keymap.set("n", "<leader>q", ":q<cr>", { silent = true, desc = "Quit NeoVim" })

-- Redo
-- vim.keymap.set("n", "U", "<c-r>", { silent = true, desc = "Redo" })

-- Swap between split buffers
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true, desc = "Move to left split" })
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to below split" })
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true, desc = "Move to above split" })
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to right split" })

-- Open file explorer
-- vim.keymap.set("n", "-", ":Explore<CR>", { silent = true, desc = "File Manager" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete without replacing clipboard content", noremap = true, silent = true })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<A-.>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-,>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-.>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-,>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-.>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-,>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>", { desc = "Clear search highlights", noremap = true, silent = true })

for _, key in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<leader>" .. key, "@" .. key, { desc = "Run macro '" .. key .. "'" })
end

vim.keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set("i", "<c-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set({"n","x"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({"n","x"}, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- vim.keymap.set("n", "<leader>t", ":hor terminal<CR>", { desc = "Open a terminal in a split" })
-- vim.keymap.set("t", "<C-w><C-h>", "<c-\\><c-n><c-w>h", { desc = "Go to left window" })
-- vim.keymap.set("t", "<C-w><C-j>", "<c-\\><c-n><c-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("t", "<C-w><C-k>", "<c-\\><c-n><c-w>k", { desc = "Go to upper window" })
-- vim.keymap.set("t", "<C-w><C-l>", "<c-\\><c-n><c-w>l", { desc = "Go to right window" })
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Escape from terminal buffer" })

vim.keymap.set("n", "<leader>;", ":e #<CR>", { desc = "Alternate Buffer" })
vim.keymap.set("n", "<leader>bc", ":let @+=expand('%:p')<CR>", { desc = "Copy Buffer Path" })
vim.keymap.set("n", "<leader>bC", ":let @+=expand('%:p:h')<CR>", { desc = "Copy Buffer Directory Path" })
vim.keymap.set("n", "<leader>bE", ":cd %:p:h<CR>", { desc = "Copy Buffer Directory Path" })
vim.keymap.set("n", "<leader>bD", ":bdelete", { desc = "Delete Buffer and Window" })
vim.keymap.set("n", "<leader>bp", ":bprev", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bx", function()
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and vim.api.nvim_buf_is_valid(alt) and vim.api.nvim_buf_is_loaded(alt) then
    vim.cmd("bdelete " .. alt)
  else
    vim.notify("No previous buffer", vim.log.levels.WARN)
  end
end, { desc = "Delete previous buffer" })

vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

vim.keymap.set("n", "<leader>X", function()
  local file = vim.fn.expand("%:p")  -- full path, not relative
  if file == "" then
    vim.notify("No file", vim.log.levels.ERROR)
    return
  end
  vim.cmd("write")
  local result = vim.system({ "chmod", "+x", file }):wait()
  if result.code ~= 0 then
    vim.notify("chmod failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit!")
  vim.notify("Made '" .. file .. "' executable")
end, { desc = "Make file executable" })
