-- Functions for my neovim config
-- update_lsp_configs - Installs or updates lsp configs
--   - Create an empty file in NVIM_CONFIG/lsp for the lsp config matching the name from nvim-lspconfig
--     (from https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
--   - Run: :UpdateLspConfigs
--   - Mapped to <leader>ul
-- update_plugins - Installs or updates plugins
--   - Create an empty directory for the plugin matching its REPO as:
--     server%owner%repo (e.g. "github.com%nvim-mini%mini.nvim")
--   - Run :UpdatePlugins
--   - Mapped to <leader>up

-- Update lsp files
local function update_lsp_configs()
	local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
	local base_url = "https://raw.githubusercontent.com/neovim/nvim-lspconfig/refs/heads/master/lsp/"
	local files = vim.fn.globpath(lsp_dir, "*.lua", false, true)
	if #files == 0 then
		vim.notify("No .lua files found in " .. lsp_dir, vim.log.levels.WARN)
		return
	end
	local updated, unchanged, failed = 0, 0, 0
	for _, filepath in ipairs(files) do
		local filename = vim.fn.fnamemodify(filepath, ":t")
		local url = base_url .. filename
		local tmpfile = vim.fn.tempname()
		-- -f: fail (nonzero exit) on HTTP errors, -sS: silent but still show errors,
		-- -w: print the http status code to stdout after the transfer
		local result = vim.system({ "curl", "-fsS", "-o", tmpfile, "-w", "%{http_code}", url }, { text = true }):wait()
		local http_code = result.stdout and result.stdout:match("%d+")
		if result.code ~= 0 or http_code ~= "200" then
			vim.notify(
				string.format("Failed to fetch %s (curl exit %d, http %s)", filename, result.code, http_code or "?"),
				vim.log.levels.ERROR
			)
			failed = failed + 1
			vim.fn.delete(tmpfile)
			goto continue
		end
		local stat = vim.uv.fs_stat(tmpfile)
		if not stat or stat.size == 0 then
			vim.notify("Downloaded file for " .. filename .. " is empty, skipping", vim.log.levels.ERROR)
			failed = failed + 1
			vim.fn.delete(tmpfile)
			goto continue
		end
		local new_content = table.concat(vim.fn.readfile(tmpfile), "\n")
		local old_content = table.concat(vim.fn.readfile(filepath), "\n")
		if new_content == old_content then
			unchanged = unchanged + 1
			vim.fn.delete(tmpfile)
		else
			-- rename is effectively atomic on the same filesystem
			local ok = vim.fn.rename(tmpfile, filepath) == 0
			if ok then
				updated = updated + 1
				vim.notify("Updated " .. filename, vim.log.levels.INFO)
			else
				vim.notify("Failed to overwrite " .. filename, vim.log.levels.ERROR)
				failed = failed + 1
				vim.fn.delete(tmpfile)
			end
		end
		::continue::
	end
	vim.notify(
		string.format("lspconfig update: %d updated, %d unchanged, %d failed", updated, unchanged, failed),
		vim.log.levels.INFO
	)
end
vim.api.nvim_create_user_command("UpdateLspConfigs", update_lsp_configs, {})
vim.keymap.set("n", "<leader>ul", ":UpdateLspConfigs<CR>", { desc = "Update LSP files" })

-- Update plugins
local function update_plugins()
	local pack_root = vim.fn.stdpath("config") .. "/pack/plugins"
	local containers = { "start", "opt" }

	local function scandir_dirs(path)
		local dirs = {}
		local fd = vim.uv.fs_scandir(path)
		if not fd then
			return dirs
		end
		while true do
			local name, ftype = vim.uv.fs_scandir_next(fd)
			if not name then
				break
			end
			if ftype == "directory" then
				table.insert(dirs, name)
			end
		end
		return dirs
	end

	-- find the single extracted top-level dir inside `path` (github tarballs
	-- extract as e.g. repo-<sha>/)
	local function find_extracted_root(path)
		local entries = scandir_dirs(path)
		if #entries == 1 then
			return path .. "/" .. entries[1]
		end
		return nil
	end

	local updated, failed, skipped = 0, 0, 0

	for _, container in ipairs(containers) do
		local container_path = pack_root .. "/" .. container
		if vim.fn.isdirectory(container_path) == 1 then
			for _, dirname in ipairs(scandir_dirs(container_path)) do
				local owner, repo = dirname:match("^github%.com%%([^%%]+)%%(.+)$")

				if not owner then
					goto continue
				end

				local plugin_dir = container_path .. "/" .. dirname
				local staging_dir = container_path .. "/.tmp-" .. dirname
				local tarball = vim.fn.tempname() .. ".tar.gz"
				local url = string.format("https://codeload.github.com/%s/%s/tar.gz/HEAD", owner, repo)

				-- clean up any leftover staging dir from a previous failed run
				vim.fn.delete(staging_dir, "rf")

				-- 1. download
				local result = vim.system(
					{ "curl", "-fsSL", "-o", tarball, "-w", "%{http_code}", url },
					{ text = true }
				)
					:wait()
				local http_code = result.stdout and result.stdout:match("%d+")

				if result.code ~= 0 or http_code ~= "200" then
					vim.notify(
						string.format("[%s] curl failed (exit %d, http %s)", dirname, result.code, http_code or "?"),
						vim.log.levels.ERROR
					)
					failed = failed + 1
					vim.fn.delete(tarball)
					goto continue
				end

				local stat = vim.uv.fs_stat(tarball)
				if not stat or stat.size == 0 then
					vim.notify(string.format("[%s] downloaded tarball is empty", dirname), vim.log.levels.ERROR)
					failed = failed + 1
					vim.fn.delete(tarball)
					goto continue
				end

				-- 2. extract into a fresh staging dir (same filesystem as plugin_dir,
				-- so the final rename is atomic)
				vim.fn.mkdir(staging_dir, "p")
				local tar_result = vim.system({ "tar", "-xzf", tarball, "-C", staging_dir }).wait
						and vim.system({ "tar", "-xzf", tarball, "-C", staging_dir }):wait()
					or nil
				-- (single call, kept simple below)
				tar_result = vim.system({ "tar", "-xzf", tarball, "-C", staging_dir }):wait()
				vim.fn.delete(tarball)

				if tar_result.code ~= 0 then
					vim.notify(
						string.format("[%s] tar extraction failed: %s", dirname, tar_result.stderr or ""),
						vim.log.levels.ERROR
					)
					failed = failed + 1
					vim.fn.delete(staging_dir, "rf")
					goto continue
				end

				local content_root = find_extracted_root(staging_dir)
				if not content_root then
					vim.notify(string.format("[%s] unexpected tarball layout", dirname), vim.log.levels.ERROR)
					failed = failed + 1
					vim.fn.delete(staging_dir, "rf")
					goto continue
				end

				-- 3. swap: remove old plugin dir, move new content into place
				vim.fn.delete(plugin_dir, "rf")
				local ok = vim.fn.rename(content_root, plugin_dir) == 0
				vim.fn.delete(staging_dir, "rf") -- remove now-empty staging wrapper

				if ok then
					updated = updated + 1
          local doc_dir = plugin_dir .. "/doc"
          if vim.fn.isdirectory(doc_dir) == 1 then
            local helpok, err = pcall(vim.cmd.helptags, doc_dir)
            if helpok then
              vim.notify(string.format("helptags failed for %s: %s", doc_dir, err), vim.log.levels.WARN)
            end
          end
          vim.cmd.helptags "ALL"
					vim.notify(string.format("Updated %s/%s", container, dirname), vim.log.levels.INFO)
				else
					failed = failed + 1
					vim.notify(
						string.format("[%s] failed to move new content into place", dirname),
						vim.log.levels.ERROR
					)
				end

				::continue::
			end
		end
	end

  local ok, _ = pcall(require, "nvim-treesitter")
  if ok then
    vim.cmd 'TSUpdate'
  end

	vim.notify(
		string.format("plugin update: %d updated, %d failed, %d skipped", updated, failed, skipped),
		vim.log.levels.INFO
	)
end

vim.api.nvim_create_user_command("UpdatePlugins", update_plugins, {})
vim.keymap.set("n", "<leader>up", ":UpdatePlugins<CR>", { desc = "Update Plugins" })

-- Smart terminal function

local function open_terminal(cmd, cwd)
  local has_snacks = pcall(function() return Snacks and Snacks.terminal end)

  if has_snacks then
    Snacks.terminal(cmd, { win = { position = "bottom" }, cwd = cwd })
    return
  end

  local full_cmd = cmd
  if cwd then
    full_cmd = string.format("cd %s && %s", vim.fn.shellescape(cwd), cmd or vim.o.shell)
  end
  vim.cmd('botright split | terminal ' .. (full_cmd or ''))
  vim.cmd('startinsert')
end

local function do_smart_terminal(opts)
  opts = opts or {}
  local use_cwd = opts.cwd
  if use_cwd == nil then use_cwd = true end -- default: true (normal pwd)

  local bufname = vim.api.nvim_buf_get_name(0)

  -- Try oil-ssh://
  local user, host, path = bufname:match('^oil%-ssh://([^@/]+)@([^/]+)/(.*)$')
  if not host then
    user, host, path = nil, bufname:match('^oil%-ssh://([^@/]+)/(.*)$')
  end

  -- Fall back to scp://
  if not host then
    user, host, path = bufname:match('^scp://([^@/]+)@([^/]+)/(.*)$')
    if not host then
      user, host, path = nil, bufname:match('^scp://([^@/]+)/(.*)$')
    end
  end

  -- Local file
  if not host then
    if use_cwd == false then
      -- use the buffer's directory instead of pwd
      local dir = (bufname ~= '' and vim.bo.buftype == '')
        and vim.fn.fnamemodify(bufname, ':p:h')
        or vim.fn.getcwd()
      open_terminal(nil, dir)
    else
      -- normal cwd behavior (let Snacks use its default)
      open_terminal(nil, nil)
    end
    return
  end

  -- Remote (oil-ssh / scp): cwd opt doesn't apply, we cd via ssh directly
  local remote_path = '/' .. path
  if not bufname:match('/$') then
    remote_path = remote_path:match('^(.*)/[^/]*$') or remote_path
  end

  local dest = user and (user .. '@' .. host) or host
  local cmd = string.format("ssh -t %s 'cd %s && exec $SHELL -l'", dest, vim.fn.shellescape(remote_path))

  open_terminal(cmd)
end

-- smart_terminal can be used two ways:
--   1. Passed directly as a keymap callback: vim.keymap.set('n', '<leader>fT', smart_terminal, ...)
--      -> called with no args by nvim -> defaults to cwd = true
--   2. Called with an opts table to produce a configured callback:
--      vim.keymap.set('n', '<leader>ft', smart_terminal({ cwd = false }), ...)
local function smart_terminal(opts)
  if opts ~= nil then
    return function()
      do_smart_terminal(opts)
    end
  end
  do_smart_terminal({})
end

vim.keymap.set('n', '<leader>ft', smart_terminal({ cwd = false }), { desc = 'Smart terminal (buffer dir/oil-ssh/scp aware)' })
vim.keymap.set('n', '<leader>fT', smart_terminal, { desc = 'Smart terminal (cwd/oil-ssh/scp aware)' })
