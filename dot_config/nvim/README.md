# Portable Neovim Config

## Prerequisites

Install tree-sitter-cli

## Plugins

Plugins are installed in $HOME/.config/nvim/pack/plugins.

- Plugins in $HOME/.config/nvim/pack/plugins/start are loaded automatically
- Plugins in $HOME/.config/nvim/pack/plugins/opt are loaded with
  `:packadd PLUGIN`

Example: To install the plugin https://github.com/fake-plugin/fake.nvim:

1. Create an empty directory in
   $HOME/.config/nvim/pack/plugins/start/github.com%fake-plugin%fake.nvim
1. Inside Neovim, run: `:UpdatePlugins`
1. Configure the plugin by creating a file in
   $HOME/.config/nvim/plugin/fake-plugin.lua. Put configuration details in
   that file
1. Restart Neovim

## LSP Configuration

1. Install the language server externally
1. Create an empty file for the LSP file in as
   $HOME/.config/nvim/lsp/MODULE.lua
1. Run: `:UpdateLspConfigs`
1. The LSP config will be downloaded into that MODULE.lua file from github

## Specific LSP Configs

|LSP        | LSP_FILE | PACKAGE1 [..PACKAGEn]           |
|-----------|----------|---------------------------------|
|Bash       | bashls   | bash-language-server shellcheck |
|Dockerfile | dockerls | dockerfile-language-server |
|LUA        | lua_ls   | lua-language-server |
|Python     | pyright  | python-pynvim pyright |
|Python     | pylsp    | python-pynvim python-lsp-server/python3-pylsp |
|Typescript | ls_ls    | typescript-language-server |
|YAML       | yamlls   | yaml-language-server |

### Installing bash-language-server, yaml-language-server on Debian

```
corepack config set prefix ~/.local
corepack npm install -g bash-language-server
corepack npm install -g yaml-language-server
```

### Installing lua-language-server on Debian

```
s=$(uname -s | tr '[:upper:]' '[:lower:]')
a=$(dpkg --print-architecture)
[ "$a" != "arm64" ] && a=x64
u=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | \
  awk -F '"' -v s=$s -v a=$a '$2=="browser_download_url"&&$4~"[0-9]-" s "-" a {print $4}')
curl -LO "$u"
mkdir -p ~/.local/lib/lua-language-server
tar -C ~/.local/lib/lua-language-server -xf ./lua-language-server*"$s"-"$a".tar.gz
printf '%s\n\n%s\n' '#!/bin/sh' 'exec "$HOME"/.local/lib/lua-language-server/bin/lua-language-server "$@"' > ~/.local/bin/lua-language-server
chmod 755 ~/.local/bin/lua-language-server
unset s a u
```

## Video this configuration is based on

- Built live in this video: [youtu.be/otRvw9neQkg](https://youtu.be/otRvw9neQkg)
- Github link: [smnatale/nvim_native](https://github.com/smnatale/nvim_native)

