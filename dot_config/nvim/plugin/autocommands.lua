-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight selection on Yank",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
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

-- Add completion to command line (not needed if using mini.completions)
-- vim.api.nvim_create_autocmd("CmdlineChanged", {
--   pattern = ":",
--   callback = function ()
--     vim.fn.wildtrigger()
--   end
-- })
