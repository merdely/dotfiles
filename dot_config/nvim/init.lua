-- init.lua
if vim.fn.filereadable(vim.fn.stdpath("config") .. "/noplugins") ~= 1 then
  require("plugins")
  require("load_lspconfig")
  require("load_treesitter")
  require("load_lualine")
  require("load_gitsigns")
else
  vim.g.use_glyphs = false
  local function is_console()
    if vim.fn.has('gui_running') == 1 then return false end
    local term = vim.env.TERM or ''
    if term == 'linux' or term == 'vt100' then return true end
    local has_display = vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY
    local fancy = term:match('xterm') or term:match('tmux') or term:match('kitty')
      or term:match('alacritty') or term:match('wezterm') or term:match('foot')
      or term:match('screen')
    if not has_display and not fancy then return true end
    return false
  end
  vim.g.use_glyphs = not is_console()

  require('mystatusline')
  vim.cmd("colorscheme lunaperche")
end

require("autocmds")
require("keymaps")
require("options")

