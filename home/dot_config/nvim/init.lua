vim.opt.number = true                       -- Line numbers
vim.opt.cursorline = true                   -- Highlight current line
vim.opt.termguicolors = true                -- Enable 24-bit colors
vim.cmd.colorscheme('torte')                -- Colorscheme
vim.opt.colorcolumn = "80"                  -- Column number where to show color column
vim.opt.signcolumn = "yes"                  -- avoid text shifting when signs appear
vim.opt.list = true                         -- Show list characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }  -- Specify list chars
vim.opt.showmatch = true                    -- Highlight matching brackets
vim.opt.showmode = false                    -- Don't show mode in command line
vim.opt.tabstop = 2                         -- Tab width
vim.opt.shiftwidth = 2                      -- Indent width
vim.opt.softtabstop = 2                     -- Soft tab stop
vim.opt.expandtab = true                    -- Use spaces instead of tabs
vim.opt.breakindent = true                  -- Show wrapped lines indented
vim.opt.ignorecase = true                   -- Case insensitive search
vim.opt.smartcase = true                    -- Case sensitive if uppercase in search
vim.opt.writebackup = false                 -- Don't create backup before writing
vim.opt.swapfile = false                    -- Don't create swap files
vim.opt.undofile = true                     -- Persistent undo
vim.opt.updatetime = 250                    -- Faster CursorHold / diagnostics
vim.opt.path:append("**")                   -- Include subdirectories in search
vim.opt.wildignore:append({
  "*.o",
  "*.obj",
  "*.pyc",
  "*.class",
  "*.jar",
  "*/node_modules/*",
  "*/.git/*",
  "*/dist/*",
  "*/build/*",
  "*/.venv/*",
  "*/__pycache__/*",
})
vim.opt.mouse = "a"                         -- Enable mouse support
vim.opt.selection = "inclusive"             -- Include last char in selection
if vim.fn.has('clipboard') > 0 then
  vim.opt.clipboard:append("unnamedplus")   -- Use system clipboard
end
vim.opt.splitbelow = true                   -- Horizontal split creation position
vim.opt.splitright = true                   -- Vertical split creation position

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set('n', '-', ":Ex<CR>", { desc = 'Open netrw Explorer' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function(ev)
    -- Can't use gb gd gf gF gg gh gn gp
    vim.keymap.set('n', '<Escape>', ':bd<CR>', { buffer = ev.buf })
    vim.keymap.set('n', 'go', ':e ', { buffer = ev.buf })
    vim.keymap.set('n', 'g/', ':e /<CR>', { buffer = ev.buf })
    vim.keymap.set('n', 'gC', ':e ' .. vim.fn.expand('$HOME') .. '/.config<CR>', { buffer = ev.buf })
    vim.keymap.set('n', 'gE', ':e /etc<CR>', { buffer = ev.buf })
    vim.keymap.set('n', 'gH', ':e ' .. vim.fn.expand('$HOME') .. '<CR>', { buffer = ev.buf })
    vim.keymap.set('n', 'gN', ':e ' .. vim.fn.expand('$HOME') .. '/.config/nvim<CR>', { buffer = ev.buf })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Status Line
_G.mode_icon = function()
  local mode = vim.fn.mode()
  local modes = {
    n       = "NORMAL",
    i       = "INSERT",
    v       = "VISUAL",
    V       = "V-LINE",
    ["\22"] = "V-BLOCK",
    c       = "COMMAND",
    s       = "SELECT",
    S       = "S-LINE",
    ["\19"] = "S-BLOCK",
    R       = "REPLACE",
    r       = "REPLACE",
    ["!"]   = "SHELL",
    t       = "TERMINAL",
  }
  return modes[mode] or mode
end

_G.statusline_percent = function()
  local current = vim.fn.line('.')
  local total   = vim.fn.line('$')
  if current == 1 then
    return 'Top'
  elseif current == total then
    return 'Bot'
  else
    return math.floor(current * 100 / total) .. '%'
  end
end

vim.opt.statusline =
        " " ..
        "%{v:lua.mode_icon()}" ..
        " | " ..
        "%f %h%m%r" ..
        "%=" ..
        "%{&fenc!=''?&fenc:&enc}" ..
        " | " ..
        "%{&fileformat}" ..
        " | " ..
        "%{&filetype}" ..
        " | " ..
        "%{v:lua.statusline_percent()}" ..
        "|" ..
        "%l:%c" ..
        " "
