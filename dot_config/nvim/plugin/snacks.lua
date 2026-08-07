---@diagnostic disable: undefined-global

local ok, plugin_config = pcall(require, "snacks")
if ok then
  plugin_config.setup({
    bufdelete = { enabled = true },
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil }, -- requires lazy.vim
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", limit = 10, indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", limit = 10, indent = 2, padding = 1 },
        -- { section = "startup" }, -- requires lazy.vim
      },
    },
    debug = { enabled = true },
    -- explorer = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },

      },
      -- win = {
      --   input = {
      --     keys = {
      --       ["<Esc>"] = { "close", mode = { "n", "i" } },
      --       ["<C-c>"] = { "cancel", mode = { "n", "i" } },
      --     },
      --   },
      -- },
    },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-w><C-h>", "<c-\\><c-n><c-w>h", desc = "Go to left window", expr = true, mode = "t" },
          nav_j = { "<C-w><C-j>", "<c-\\><c-n><c-w>j", desc = "Go to lower window", expr = true, mode = "t" },
          nav_k = { "<C-w><C-k>", "<c-\\><c-n><c-w>k", desc = "Go to upper window", expr = true, mode = "t" },
          nav_l = { "<C-w><C-l>", "<c-\\><c-n><c-w>l", desc = "Go to right window", expr = true, mode = "t" },
          term_normal = { "<esc><esc>", "<c-\\><c-n>", desc = "Escape from terminal buffer", expr = true, mode = "t" },
          hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
    toggle = { enabled = true },
    util = { enabled = true },
    win = { enabled = true },
  })

  _G.dd = function(...)
    Snacks.debug.inspect(...)
  end
  _G.bt = function()
    Snacks.debug.backtrace()
  end
  if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
      dd(...)
    end
  else
    vim.print = dd
  end

  -- keymaps
  vim.keymap.set("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, { desc = "Delete Buffer" })
  vim.keymap.set("n", "<leader>bo", function()
    Snacks.bufdelete.other()
  end, { desc = "Delete Other Buffers" })
  vim.keymap.set("n", "<leader>bi", function()
    Snacks.bufdelete.invisible()
  end, { desc = "Delete Invisible Buffers" })

  vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  vim.keymap.set("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })

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
  vim.keymap.set("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, { desc = "Find Config Files" })
  vim.keymap.set("n", "<leader>fe", function() Snacks.picker.explorer() end, { desc = "File Explorer" })
  vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
  vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  vim.keymap.set("n", "<leader>fG", function() Snacks.picker.files { cwd = vim.fn.expand("$HOME/git") } end, { desc = "Find ~/git Files" })
  vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
  vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
  vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent Files" })
  vim.keymap.set("n", "<leader>fs", function() Snacks.picker.files { cwd = vim.fn.expand("$HOME/src") } end, { desc = "Find ~/src Files" })
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
  vim.keymap.set({'n','x'}, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
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
  vim.keymap.set('n', '<leader>st', function() Snacks.picker.treesitter() end, { desc = 'Treesitter' })

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

  -- Snacks toggles
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
  Snacks.toggle.indent():map("<leader>uG")
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

  local autopairs_loaded = pcall(require, 'nvim-autopairs')
  if autopairs_loaded then
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

  local gitsigns_loaded = pcall(require, 'gitsigns')
  if gitsigns_loaded then
    Snacks.toggle({
      name = "Git Signs",
      get = function()
        return require("gitsigns.config").config.signcolumn
      end,
      set = function(state)
        require("gitsigns").toggle_signs(state)
      end,
    }):map("<leader>ugg")
  end

  -- LazyVim.format.snacks_toggle():map("<leader>uf")
  -- LazyVim.format.snacks_toggle(true):map("<leader>uF")

  local treesitter_loaded = pcall(require, 'nvim-treesitter')
  if treesitter_loaded then
    Snacks.toggle.treesitter():map("<leader>uT")
  end
  vim.keymap.set({"n", "x"}, "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua" })

  -- Turn off autocomplete in the snacks picker
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function(event)
      vim.o.autocomplete = false
      vim.api.nvim_create_autocmd("BufLeave", {
        buffer = event.buf,
        once = true,
        callback = function()
          vim.o.autocomplete = true
        end,
      })
    end,
  })
end
