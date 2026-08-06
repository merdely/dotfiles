vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	end,
})
local ok, _ = pcall(require, 'nightfly')
if ok then
  vim.cmd("colorscheme nightfly")
else
  vim.cmd("colorscheme catppuccin")
end
