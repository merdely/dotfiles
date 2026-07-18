vim.g.mapleader = ' ' -- define key for user mappings
vim.g.maplocalleader = ',' -- like leader but local to buffer

vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { desc = 'Change without replacing clipboard content', noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'C', '"_C', { desc = 'Change without replacing clipboard content', noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'Delete without replacing clipboard content', noremap = true, silent = true })

vim.keymap.set("n", "<A-.>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-,>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-.>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-,>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-.>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-,>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>", { desc = "Clear search highlights", noremap = true, silent = true })

vim.keymap.set('n', '-', ':Ex<cr>', { desc = 'File Manager', silent = true })

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

vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
vim.keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

vim.keymap.set("n", "<leader>bc", "<cmd>let @+=expand('%:p')<cr>", { desc = "Copy Buffer File Path" })
vim.keymap.set("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set("i", "<c-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
vim.keymap.set({"n","x"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set({"n","x"}, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })

vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

if package.loaded["bufferline"] then
  vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
  vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
  vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
  vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  vim.keymap.set("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
  vim.keymap.set("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
  vim.keymap.set("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
end

if package.loaded["conform"] then
  vim.keymap.set({'n','v'}, '<leader>cf', function() require('conform').format { async = true } end, { desc = 'Format buffer' })
  vim.keymap.set({"n","x"}, "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
  { desc = "Format Injected Langs" })
end

if package.loaded["trouble"] then
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
      vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
      vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
      vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
      vim.keymap.set("n",
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end, { desc = "Previous Trouble/Quickfix Item" })
      vim.keymap.set("n",
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
    { desc = "Next Trouble/Quickfix Item" })
end

if package.loaded["which-key"] then
  vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = false } end, { desc = 'Buffer Local Keymaps (which-key)' })
  -- vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = true } end, { desc = 'Buffer Local Keymaps (which-key)' })
  vim.keymap.set("n", "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, { desc = "Window Hydra Mode (which-key)" })
  -- if vim.wo.diff then
    -- require("which-key").add({
    --   { "]c", desc = "Next diff hunk", buffer = 0 },
    --   { "[c", desc = "Prev diff hunk", buffer = 0 },
    --   { "d", desc = "delete/diff"},
    --   { "do", desc = "Diff obtain", buffer = 0 },
    --   { "dp", desc = "Diff put", buffer = 0 },
    -- })
  -- end
end

if package.loaded["neogit"] then
  vim.keymap.set('n', '<leader>gG', ':Neogit<CR>', { desc = 'Start Neogit' })
end

if package.loaded["flash"] then
  vim.keymap.set({"n","x","o"}, "s", function() require("flash").jump() end, { desc = "Flash" })
  vim.keymap.set({"n","x","o"}, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
  vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
  vim.keymap.set({"x","o"}, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
  vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
end

if package.loaded["persistence"] then
  vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
  vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select Session" })
  vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
  vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
end

if package.loaded["snacks"] then
  vim.keymap.set("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, { desc = "Delete Buffer" })
  vim.keymap.set("n", "<leader>bo", function()
    Snacks.bufdelete.other()
  end, { desc = "Delete Other Buffers" })
  vim.keymap.set("n", "<leader>bi", function()
    Snacks.bufdelete.invisible()
  end, { desc = "Delete Invisible Buffers" })

  vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Start LazyGit' })
  vim.keymap.set('n', '<leader>ft', function() Snacks.terminal() end, { desc = 'Start a Terminal' })

  vim.keymap.set("n", "]r", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
  vim.keymap.set("n", "[r", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
  vim.keymap.set("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, { desc = "Next Reference" })
  vim.keymap.set("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Prev Reference" })

  -- Pickers
  vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
  vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
  vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notifications History" })
  vim.keymap.set("n", "<leader>D", function() Snacks.dashboard.open() end, { desc = "Show Dashboard" })
  vim.keymap.set("n", "<leader>e", function() Snacks.picker.explorer() end, { desc = "File Explorer" })
  vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, { desc = "Find Config Files" })
  vim.keymap.set("n", "<leader>fe", function() Snacks.picker.explorer() end, { desc = "File Explorer" })
  vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
  vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
  vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent Files" })
  vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
  vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
  vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
  vim.keymap.set("n", "<leader>gD", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, { desc = "Git Diff (origin)" })
  vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
  vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
  vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
  vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
  vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
  vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
  vim.keymap.set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
  vim.keymap.set({"n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })
  vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
  vim.keymap.set('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open Buffers' })
  vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Grep' })
  vim.keymap.set('n', '<leader>sG', function() Snacks.picker.grep({ dirs = { vim.api.nvim_buf_get_name(0) } }) end, { desc = "Grep Buffer's Path" })
  vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
  vim.keymap.set('x', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
  vim.keymap.set('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = 'Registers' })
  vim.keymap.set('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
  vim.keymap.set('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = 'Autocmds' })
  vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
  vim.keymap.set('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
  vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
  vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help' })
  vim.keymap.set('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = 'Highlights' })
  vim.keymap.set('n', '<leader>si', function() Snacks.picker.icons() end, { desc = 'Icons' })
  vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Jumps' })
  vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
  vim.keymap.set('n', '<leader>sl', function() Snacks.picker.loclist() end, { desc = 'Location List' })
  vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Marks' })
  vim.keymap.set('n', '<leader>sM', function() Snacks.picker.man() end, { desc = 'Man Pages' })
  vim.keymap.set('n', '<leader>snd', function() Snacks.notifier.hide() end, { desc = 'Hide Notifications' })
  vim.keymap.set('n', '<leader>sng', function() Snacks.notifier.get_history() end, { desc = 'Get Notifications History' })
  vim.keymap.set('n', '<leader>snh', function() Snacks.notifier.show_history() end, { desc = 'Notifications History' })
  vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss Notification' })
  vim.keymap.set('n', '<leader>sp', function() Snacks.picker() end, { desc = 'Pickers' })
  vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
  vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume' })
  if package.loaded["todo-comments"] then
    vim.keymap.set("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Todo" })
    vim.keymap.set("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })
  end

  vim.keymap.set('n', '<leader>sv', function() Snacks.picker.grep({ dirs = {vim.fn.stdpath('config')} }) end, { desc = 'Grep Vim Config' })
  vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = 'Undo History' })
  vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })
  vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
  vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
  vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
  vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
  vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto Type Definition' })
  vim.keymap.set('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { desc = 'Calls Incoming' })
  vim.keymap.set('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { desc = 'Calls Outgoing' })
  vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
  vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.diagnostics():map("<leader>ud")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
  -- Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
  Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
  Snacks.toggle.dim():map("<leader>uD")
  Snacks.toggle.animate():map("<leader>ua")
  Snacks.toggle.indent():map("<leader>ug")
  Snacks.toggle.scroll():map("<leader>uS")
  Snacks.toggle.profiler():map("<leader>dpp")
  Snacks.toggle.profiler_highlights():map("<leader>dph")
  Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
  Snacks.toggle.zen():map("<leader>uz")

  if vim.lsp.inlay_hint then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end

  Snacks.toggle({
    name = "Completion",
    get = function()
      return vim.b.completion
    end,
    set = function(state)
      vim.b.completion = state
    end,
  }):map("<leader>uk")

  if package.loaded["nvim-autopairs"] then
    Snacks.toggle({
      name = "Auto Pairs",
      get = function()
        return not require("nvim-autopairs").state.disabled
      end,
      set = function()
        require("nvim-autopairs").toggle()
      end,
    }):map("<leader>up")
  end

  if package.loaded["gitsigns"] then
    Snacks.toggle({
      name = "Git Signs",
      get = function()
        return require("gitsigns.config").config.signcolumn
      end,
      set = function(state)
        require("gitsigns").toggle_signs(state)
      end,
    }):map("<leader>uG")
  end

-- LazyVim.format.snacks_toggle():map("<leader>uf")
-- LazyVim.format.snacks_toggle(true):map("<leader>uF")

  if package.loaded["nvim-treesitter"] then
    Snacks.toggle.treesitter():map("<leader>uT")
  end
  vim.keymap.set({"n", "x"}, "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua" })
end

if package.loaded["noice"] then
  vim.keymap.set('n', "<leader>snL", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
  vim.keymap.set('n', "<leader>snH", function() require("noice").cmd("history") end, { desc = "Noice History" })
  vim.keymap.set('n', "<leader>sna", function() require("noice").cmd("all") end, { desc = "Noice All" })
  vim.keymap.set("n", "<leader>snD", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })
  vim.keymap.set('n', "<leader>snt", function() require("noice").cmd("pick") end, { desc = "Noice Picker (Telescope/FzfLua)" })
end

if package.loaded["nvim-treesitter"] then
  vim.keymap.set("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })
end

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
