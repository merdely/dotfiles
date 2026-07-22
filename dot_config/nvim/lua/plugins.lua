-- These must be set outside of the do section
-- and before the plugin is loaded
vim.g.moonflyTransparent = true
vim.g.nightflyTransparent = true

do
    -- "https://github.com/bluz71/vim-moonfly-colors",
    -- "https://github.com/maxmx03/solarized.nvim",
    -- 'https://github.com/stevearc/oil.nvim',
    -- "https://github.com/NMAC427/guess-indent.nvim",
    -- "https://github.com/lukas-reineke/indent-blankline.nvim",
  vim.pack.add({
    "https://github.com/bluz71/vim-nightfly-colors",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",

    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/folke/flash.nvim",
    "https://github.com/folke/noice.nvim",
    "https://github.com/folke/persistence.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/folke/trouble.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/windwp/nvim-autopairs",

    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/saghen/blink.lib",
    "https://github.com/stevearc/conform.nvim",

    "https://github.com/brianhuster/live-preview.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  })

  local indentblankline_loaded = pcall(require, 'ibl')
  local guessindent_loaded = pcall(require, 'guess-indent')
  local autopairs_loaded = pcall(require, 'nvim-autopairs')
  local todocomments_loaded = pcall(require, 'todo-comments')
  local minisurround_loaded = pcall(require, 'mini.icons')
  local miniicons_loaded = pcall(require, 'mini.icons')
  local trouble_loaded = pcall(require, 'trouble')
  local nui_installed = pcall(require, 'nui.popup')
  local noice_installed = pcall(require, 'noice')
  local flash_loaded = pcall(require, 'flash')
  local persistence_loaded = pcall(require, 'persistence')
  local snacks_loaded = pcall(require, 'snacks')
  local luasnip_loaded = pcall(require, 'luasnip')
  local blink_loaded = pcall(require, 'blink.cmp')
  local conform_loaded = pcall(require, 'conform')
  local bufferline_loaded = pcall(require, 'bufferline')
  local whichkey_loaded = pcall(require, 'which-key')
  local solarized_loaded = pcall(require, 'solarized')
  local moonfly_loaded = pcall(require, 'moonfly')
  local nightfly_loaded = pcall(require, 'nightfly')

  -- indent-blankline
  if indentblankline_loaded then
    require('ibl').setup {}
  end

  if guessindent_loaded then
    require("guess-indent").setup({})
  end

  if autopairs_loaded then
    require("nvim-autopairs").setup({})
  end

  if todocomments_loaded then
    require("todo-comments").setup({ signs = false })
  end

  -- - gsaiw) - Surround Add Inner Word )
  -- - gsd'   - Surround Delete '
  -- - gsr)'  - Surround Replace ) with '
  if minisurround_loaded then
    require("mini.surround").setup({
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    })
  end

  if miniicons_loaded then
    require("mini.icons").setup({})
    MiniIcons.mock_nvim_web_devicons()
  end

  if trouble_loaded then
    require("trouble").setup({
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    })
  end

  if noice_installed and nui_installed then
    require("noice").setup({
      lsp = {
        messages = { enabled = true },
      },
      messages = { enabled = true },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
    })
  end

  if flash_loaded then
    require("flash").setup({})
  end

  if persistence_loaded then
    require("persistence").setup({})
  end

  if snacks_loaded then
    require("snacks").setup({
      bufdelete = { enabled = true },
      bigfile = { enabled = true },
      dashboard = {
        preset = {
          ---@type snacks.dashboard.Item[]
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

  if luasnip_loaded then
    require("luasnip").setup({})
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
    require("luasnip.loaders.from_vscode").lazy_load()
  end

  if blink_loaded then
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        list = {
          selection = {
            preselect = false,
          },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets" },
      },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    })
    vim.b.completion = true
  end

  if conform_loaded then
    require("conform").setup({
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- You can specify filetypes to autoformat on save here:
        local enabled_filetypes = {
          -- lua = true,
          -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        else
          return nil
        end
      end,
      default_format_opts = {
        lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
      },
      -- You can also specify external formatters in here.
      formatters_by_ft = {
        awk = { "gawk" },
        sh = { "beautysh", "shellcheck", "shellharden", "shfmt" },
        css = { "css_beautify" },
        dockerfile = { "dockerfmt" },
        go = { "gofmt" },
        html = { "html_beautify" },
        kdl = { "kdlfmt" },
        javascript = { "js_beautify" },
        jq = { "jq", "gojq" },
        json = { "fixjson" },
        lua = { "lua-format", "stylua" },
        markdown = { "markdownfmt", "markdownlint" },
        nginx = { "nginxfmt" },
        python = { "isort", "black" },
        qml = { "qmlformat" },
        rust = { "rustfmt" },
        toml = { "tombi" },
        xml = { "xmlformatter", "xmllint" },
        yaml = { "yamlfix" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    })
  end

  if bufferline_loaded then
    require("bufferline").setup({
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
      },
  })
  end

  if whichkey_loaded then
    require("which-key").setup({
      preset = "helix",
      delay = 250,
      spec = {
        {
          mode = { "n", "x" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gr", group = "lsp actions" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    })
  end

  if solarized_loaded then
    vim.cmd("colorscheme solarized")
  end

  if moonfly_loaded then
    vim.cmd "colorscheme moonfly"
  end

  if nightfly_loaded then
    vim.cmd("colorscheme nightfly")
  end
end
