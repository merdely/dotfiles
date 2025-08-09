# My Dotfiles

## Neovim config

- .config/nvim/init.lua

## Niri config

- .config/niri/config.kdl

## Tmux config

- .config/tmux/tmux.conf
  - My main tmux config
- /srv/scripts/bin/tmux*
  - Helper scripts

## Vim config

- .vimrc

## Waybar config

- .config/waybar
  - config.jsonc - main waybar config
  - modules.jsonc - included modules
  - style.css - waybar style
- .config/local/waybar* - waybar overrides for syncing across multiple systems
  - waybar.jsonc
  - waybar.css
  - waybar\_{primary,secondary,tertiary}.jsonc - specific configs for multiple monitors
- .config/local/wb_*
  - wb\_mode.jsonc - either a copy of wb\_laptop.jsonc or wb\_tablet.jsonc
  - wb\_laptop.jsonc - waybar config overrides for laptop mode
  - wb\_tablet.jsonc - waybar config overrides for tablet mode

