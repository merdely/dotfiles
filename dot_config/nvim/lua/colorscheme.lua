vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	end,
})
-- vim.cmd.colorscheme("catppuccin")
vim.cmd.colorscheme("nightfly")
