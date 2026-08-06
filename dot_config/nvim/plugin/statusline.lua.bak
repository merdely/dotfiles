vim.g.use_glyphs = false
local function is_console()
	if vim.fn.has("gui_running") == 1 then
		return false
	end
	local term = vim.env.TERM or ""
	if term == "linux" or term == "vt100" then
		return true
	end
	local has_display = vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY
	local fancy = term:match("xterm")
		or term:match("alacritty")
		or term:match("foot")
		or term:match("ghostty")
		or term:match("kitty")
		or term:match("screen")
		or term:match("tmux")
		or term:match("wezterm")
	if not has_display and not fancy then
		return true
	end
	return false
end
vim.g.use_glyphs = not is_console()
if vim.env.NVIM_DISABLE_GLYPHS then
	vim.g.use_glyphs = false
end

local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

local function_types = {
	lua = { "function_declaration", "function_definition" },
	javascript = { "function_declaration", "function", "arrow_function", "method_definition" },
	typescript = { "function_declaration", "function", "arrow_function", "method_definition" },
	typescriptreact = { "function_declaration", "function", "arrow_function", "method_definition" },
	python = { "function_definition" },
	sh = { "function_definition" },
}

local function get_current_function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local types = function_types[ft]
	if not types then
		return nil
	end
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return nil
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local root = parser:parse()[1]:root()
	local node = root:named_descendant_for_range(row, col, row, col)
	while node do
		if vim.tbl_contains(types, node:type()) then
      local name_node = node:field("name")[1]
      if name_node then
        return vim.treesitter.get_node_text(name_node, bufnr)
      end
      local parent = node:parent()
      if parent then
        for child in parent:iter_children() do
          if child:type() == "identifier" or child:type() == "property_identifier" then
            return vim.treesitter.get_node_text(child, bufnr)
          end
        end
      end
		end
		node = node:parent()
	end
	return nil
end

local function file_format()
  local ff = vim.bo.fileformat
  local icons = {
    dos = "\u{e70f}", -- nf-dev-windows
    mac = "\u{e711}", -- nf-dev-apple
    unix = "\u{e712}", -- nf-dev-linux
  }

  if vim.g.use_glyphs then
    return icons[ff] or (" \u{f15b} " .. ff)
  elseif ff ~= "" then
    return ff
  else
    return ""
  end
end

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

function _G._statusline()
	local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
  local git_icon = vim.g.use_glyphs and "\u{e725} " or " "
  local func_icon = vim.g.use_glyphs and "\u{f0295} " or " "
	local branch = vim.b.git_branch and "%#StlGit# " .. git_icon .. vim.b.git_branch .. " %* " or " "
	local path = "%t%( %m%h%r%)"
  local fformat = file_format() and file_format() .. " | " or ""
  local ftype = file_type()

  local funcname = ""
	funcname = get_current_function() and (" | " .. func_icon .. get_current_function()) or ""

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local labels = { " ", " ", " ", " " }
	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end
  diag = diag ~= "" and " | " .. diag or ""

	return "%#StlMode# " .. mode .. " %*" .. branch .. path .. diag .. funcname .. "%=" .. "%{&fenc!=''?&fenc:&enc} | " .. fformat .. ftype .. " | %P | %l:%c"
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
    local gdir = vim.fn.expand("%:p:h")
		local root = vim.fn.system("git -C " .. vim.fn.shellescape(gdir) .. " rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
		if root ~= "" then
			vim.b.git_branch = vim.fn.system("git -C " .. vim.fn.shellescape(gdir) .. " branch --show-current 2>/dev/null"):gsub("%s+$", "")
			vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2)
		else
			vim.b.git_branch = nil
			vim.b.rel_path = vim.fn.expand("%:p:~")
		end
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"
