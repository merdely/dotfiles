# My Dotfiles

## Repository Info

- Repository home: https://git.erdelynet.com/mike/dotfiles
- Github Mirror: https://github.com/merdely/dotfiles

## Issues / Pull Requests

Issues and other interactions should take place in the Github Mirror

- https://github.com/merdely/dotfiles/issues
- https://github.com/merdely/dotfiles/pulls

## Scripts

- .local/bin
    - gen-wm-help: create help images using [gen-keybinding-img](https://git.erdelynet.com/mike/gen-keybinding-img)
    - rofi-launcher, rofi-powermenu, rofi-windows: rofi-based utilities
    - play_pause_media.sh: Attempts to pause and play media (will prompt if there are more than one to play)
    - run\*: wrapper scripts to run different tools
    - wm-\*: scripts to manage the window manager
    - watch_tablet.sh: monitor input events and handle when the keyboard goes away
    - screen-rotation: watch for rotation and manage the system accordingly
- /srv/scripts/bin
    - tmux\*: Tmux helper scripts

## zsh

- .zprofile
- .config/zsh

## starship - shell prompt

- .config/starship

## shell - my shell startup scripts

- .config/shell

## kitty - my terminal

- .config/kitty

## Neovim config

- .config/nvim/init.lua

## Niri config

- .config/niri/config.kdl

## nwg-drawer - App launcher for tablet mode

- .config/nwg-drawer

## Tmux config

- .config/tmux/tmux.conf
  - My main tmux config

## Vim config

- .vimrc

## Waybar config - bar for niri

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

## wleave - power menu

- .config/wleave

## local overrides

- I put in local overrides for things like waybar and kitty in here so that what goes in the main app configs can be synced across all of my systems
