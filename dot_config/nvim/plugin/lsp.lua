-- lsp

-- Read all of the lsp lua files and enable them if present
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local files = vim.fn.globpath(lsp_dir, "*.lua", false, true)
for _, filepath in ipairs(files) do
  local lsp_file = string.sub(vim.fn.fnamemodify(filepath, ":t"), 1, -5)
  vim.lsp.enable({ lsp_file })
end

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.config("efm", {
  filetypes = { 'sh', 'bash', 'yaml' },
  init_options = { documentFormatting = true, documentRangeFormatting = true },
  settings = {
    -- logFile = '/tmp/efm.log',
    -- logLevel = 5,
    rootMarkers = { '.git/', '.' },
    languages = {
      sh = {
        {
          lintCommand = 'shellcheck -f gcc -x -',
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintSource = 'shellcheck',
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m',
          },
        },
        { formatCommand = 'shfmt -i 2 -ci', formatStdin = true },
      },
      yaml = {
        { lintCommand = 'yamllint -f parsable -', lintStdin = true, lintIgnoreExitCode = true, lintSource = 'yamllint' },
        { formatCommand = 'yamlfmt -', formatStdin = true },
      },
    },
  },
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				preloadFileSize = 10000,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        mccabe = { enabled = false },
        pylsp_mypy = { enabled = false },
        pylsp_black = { enabled = false },
        pylsp_isort = { enabled = false },
      },
    },
  },
})

vim.cmd("set completeopt+=noselect")

