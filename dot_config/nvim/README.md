# Portable Neovim Config

## Plugins

Plugins are installed in $HOME/.config/nvim/pack.

Example: To install the plugin https://github.com/fake-plugin/fake.nvim:

1. Create an empty directory in
   $HOME/.config/nvim/pack/plugins/start/github.com%fake-plugin%fake.nvim
1. Inside Neovim, run: :UpdatePlugins
1. Configure the plugin by creating a file in
   $HOME/.config/nvim/plugin/fake-plugin.lua. Put configuration details in
   that file
1. Restart Neovim

## LSP Configuration

1. Install the language server externally
1. Create an empty file for the LSP file in as
   $HOME/.config/nvim/lsp/MODULE.lua
1. Run: :UpdateLspConfigs
1. The LSP config will be downloaded into that MODULE.lua file from github

## Video this configuration is based on

- Built live in this video: [youtu.be/otRvw9neQkg](https://youtu.be/otRvw9neQkg)
- Github link: [smnatale/nvim_native](https://github.com/smnatale/nvim_native)

