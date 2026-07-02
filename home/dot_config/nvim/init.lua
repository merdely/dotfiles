vim.opt.number = true -- Line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 8 -- Number of lines to keep above/below cursor
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.cmd.colorscheme('torte') -- Colorscheme
vim.opt.colorcolumn = "80" -- Column number where to show color column
vim.opt.signcolumn = "yes" -- Avoid text shifting when signs appear
vim.opt.list = true -- Show list characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Specify list chars
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.breakindent = true -- Show wrapped lines indented
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
vim.opt.updatetime = 250 -- Faster CursorHold / diagnostics
vim.opt.path:append("**") -- Include subdirectories in search
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
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.selection = "inclusive" -- Include last char in selection
if vim.fn.has('clipboard') > 0 then
  vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
end
vim.opt.splitbelow = true -- Horizontal split creation position
vim.opt.splitright = true -- Vertical split creation position

vim.g.mapleader      = " " -- Set leader key
vim.g.maplocalleader = "," -- Set local leader key

vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete without replacing clipboard content", noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left window" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to bottom window" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to top window" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right window" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set('n', '<leader>;', "<Cmd>e #<CR>", { desc = 'Switch to previous buffer' })
vim.keymap.set('n', '<leader>eh', ':Sexplore<CR>', { desc = "Open netrw in horizontal split" })
vim.keymap.set('n', '<leader>ev', ':Vexplore<CR>', { desc = "Open netrw in vertical split" })
vim.keymap.set("n", "<leader>ss", ":syntax sync fromstart<CR>", { desc = "Syntax sync from start" })
vim.keymap.set("n", "<leader>rc", ":edit $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":source $MYVIMRC<CR>", { desc = "Reload config" })

vim.keymap.set('n', '<leader>cp', function()
  vim.cmd("set cursorline! list! number! breakindent!")
  if vim.o.colorcolumn == '' then
    vim.opt.colorcolumn = "80"
  else
    vim.opt.colorcolumn = ""
  end
  if vim.o.signcolumn == 'no' then
    vim.opt.signcolumn = 'yes'
  else
    vim.opt.signcolumn = 'no'
  end
end, { silent = true, desc = "Toggle copy-friendly mode" })

vim.keymap.set("n", "<leader>x", function()
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

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last edit position when opening files",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})


vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize splits when window is resized",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
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
  callback = function()
    vim.opt_local.indentkeys:remove("0#")
  end,
})

-- LSP Configuration
vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  -- root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    }
  }
}
vim.lsp.enable 'lua_ls'

vim.lsp.config.dockerfilels = {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' }
}
vim.lsp.enable 'dockerfilels'

vim.lsp.config.yamlls = {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' }
}
vim.lsp.enable 'yamlls'

vim.lsp.config.bashls = {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' }
}
vim.lsp.enable 'bashls'

vim.lsp.config.systemdls = {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd' }
}
vim.lsp.enable 'systemdls'

vim.lsp.config.pylsp = {
  cmd = { 'pylsp' },
  filetypes = { 'python' }
}
vim.lsp.enable 'pylsp'

vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.cmd('set completeopt+=noselect')

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
    " | " ..
    "%l:%c" ..
    " "
