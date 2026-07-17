-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Git branch function with caching and Nerd Font icon
vim.g.use_glyphs = true
vim.g.cached_branch = ""
local branch_cache = {}
local last_check = {}
local left_sep = "/"
local right_sep = "\\"

local function git_branch()
  local dir = vim.fn.expand('%:p:h')
  local now = os.time()
  if not last_check[dir] or now - last_check[dir] > 5 then
    local result = vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. " branch --show-current 2>/dev/null | tr -d '\n'")
    branch_cache[dir] = result
    last_check[dir]   = now
  end
  vim.g.cached_branch = branch_cache[dir]
  if vim.g.cached_branch ~= '' then
    local icon = vim.g.use_glyphs and '\u{e725} ' or ' '
    return '/ ' .. icon .. vim.g.cached_branch
  end
  return ''
end

-- File format with Nerd Font icon
local function file_format()
  local ff = vim.bo.fileformat
  local icons = {
    dos = "\u{e70f}", -- nf-dev-windows
    mac = "\u{e711}", -- nf-dev-apple
    unix = "\u{e712}", -- nf-dev-linux
  }

  if vim.g.use_glyphs then
    return (icons[ff] or " \u{f15b} " .. ff)
  elseif ff ~= "" then
    return ff
  else
    return ""
  end
end

-- File type with Nerd Font icon
local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{e620} ", -- nf-dev-lua
    python = "\u{e73c} ", -- nf-dev-python
    javascript = "\u{e74e} ", -- nf-dev-javascript
    typescript = "\u{e628} ", -- nf-dev-typescript
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ", -- nf-dev-html5
    css = "\u{e749} ", -- nf-dev-css3
    scss = "\u{e749} ",
    json = "\u{e60b} ", -- nf-dev-json
    markdown = "\u{e73e} ", -- nf-dev-markdown
    vim = "\u{e62b} ", -- nf-dev-vim
    sh = "\u{f489} ", -- nf-oct-terminal
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ", -- nf-dev-rust
    go = "\u{e724} ", -- nf-dev-go
    c = "\u{e61e} ", -- nf-dev-c
    cpp = "\u{e61d} ", -- nf-dev-cplusplus
    java = "\u{e738} ", -- nf-dev-java
    php = "\u{e73d} ", -- nf-dev-php
    ruby = "\u{e739} ", -- nf-dev-ruby
    swift = "\u{e755} ", -- nf-dev-swift
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ", -- nf-linux-docker
    gitcommit = "\u{f418} ", -- nf-oct-git_commit
    gitconfig = "\u{f1d3} ", -- nf-fa-git
    vue = "\u{fd42} ", -- nf-md-vuejs
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }

  if vim.g.use_glyphs then
    return (icons[ft] or " \u{f15b} ") .. ft
  else
    return ft
  end
end

-- File size with Nerd Font icon
local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%"))
  if size < 0 then
    return ""
  end
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  if vim.g.use_glyphs then
    return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
  else
    return size_str .. " "
  end
end

-- Mode indicators with Nerd Font icons
local function mode()
  local mode = vim.fn.mode()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    R = "REPLACE",
    r = "REPLACE",
    ["!"] = "SHELL",
    t = "TERMINAL",
  }
  return modes[mode] or mode
end

local function get_cmd()
  if not package.loaded["noice"] then
    return ''
  end
  local command = require("noice").api.status.command.get()
  if command then
    return command .. " \\ "
  else
    return ''
  end
end

local function get_mode()
  if not package.loaded["noice"] then
    return ''
  end
  local mode = require("noice").api.status.mode.get()
  if mode then
    return mode .. "%#StatusLine# \\ "
  else
    return ''
  end
end

local function dap_status()
  if not package.loaded["dap"] then
    return ''
  end
  local status = require("dap").status()
  if vim.g.use_glyphs then
    status = "  " .. status
  end
  if status then
    return status .. " \\ "
  else
    return ''
  end
end

local function diagnostic_status()
  local ok = '  '

  local ignore = {
    ['c'] = true, -- command mode
    ['t'] = true  -- terminal mode
  }

  local mode = vim.api.nvim_get_mode().mode

  if ignore[mode] then
    return ok
  end

  local levels = vim.diagnostic.severity
  local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
  if errors > 0 then
    if vim.g.use_glyphs then
      return '/ ✘ '
    else
      return '/ x '
    end
  end

  local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
  if warnings > 0 then
    if vim.g.use_glyphs then
      return '/ ▲ '
    else
      return '/ ~ '
    end
  end

  return ok
end

_G.diagnostic_status = diagnostic_status
_G.get_mode = get_mode
_G.get_cmd = get_cmd
_G.dap_status = dap_status
_G.mode = mode
_G.git_branch = git_branch
_G.file_format = file_format
_G.file_type = file_type
_G.file_size = file_size

-- vim.cmd([[
--   highlight StatusLineBold gui=bold cterm=bold
-- ]])

-- local function set_statusline_highlights()
--   vim.api.nvim_set_hl(0, "StatusLine",     { fg = "#c0c0d0", bg = "#081e2f" })
--   vim.api.nvim_set_hl(0, "StatusLineBold", { fg = "#c0c0d0", bg = "#081e2f", bold = true })
-- end
--
-- set_statusline_highlights()
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = set_statusline_highlights,
-- })

-- local colors = {
--   fg      = "#c0c0d0",
--   bg      = "#081e2f",
--   accent  = "#7aa2f7",
--   warn    = "#e0af68",
--   error   = "#f7768e",
-- }
--
-- vim.api.nvim_set_hl(0, "StatusLine",      { fg = colors.fg, bg = colors.bg })
-- vim.api.nvim_set_hl(0, "StatusLineBold",  { fg = colors.accent, bg = colors.bg, bold = true })
-- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.error, bg = colors.bg })

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      -- vim.api.nvim_set_hl(0, "StatusLineBold", { link = "Function" })
      -- vim.api.nvim_set_hl(0, "StatusLineBold", { reverse = true })

      vim.opt_local.statusline = table.concat({
        "%#StatusLineBold#",
        " ",
        "%{v:lua.mode()}",
        " ",
        "%#StatusLine#",
        "/ ",
        "%t %h%m%r",
        "%{v:lua.git_branch()}",
        "%{v:lua.diagnostic_status()}",
        -- " /",
        -- "%{v:lua.file_size()}",

        "%=",

        "%{%v:lua.get_cmd()%}",
        "%#DiagnosticError#",
        "%{%v:lua.get_mode()%}",
        "%{%v:lua.dap_status()%}",
        "%#StatusLine#",
        "%{&fenc!=''?&fenc:&enc}",
        " \\ ",
        "%{v:lua.file_format()}",
        " \\ ",
        "%{v:lua.file_type()}",
        " \\ ",
        "%p%%",
        " \\ ",
        "%l/%L:%c",
        " ",
      })
    end,
  })
  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      vim.opt_local.statusline = " %t %h%m%r  %=  %l/%L:%c "
    end,
  })
end

setup_dynamic_statusline()
