# Allow shared history between terminals
bleopt history_share=1

# Do not show error exit mark
bleopt exec_errexit_mark:=
bleopt exec_exit_mark:=

# Define my own widget to go to start of line when going up through history
function ble/widget/my/vi-command/backward-line {
  ble/widget/vi-command/backward-line
  ble/widget/beginning-of-line
}

# Load these things when vim-mode is loaded
function my/vim-load-hook {
  # Do not show vi mode
  bleopt keymap_vi_mode_show=

  # Load surround module
  ble-import vim-surround

  # Go to start of line when going up through history 
  ble-bind -m vi_nmap -f k my/vi-command/backward-line
  # Let C-c cancel a command in normal mode
  ble-bind -m vi_nmap -f C-c discard-line
  # When in normal mode, do not flash screen when pressing ESC
  ble-bind -m vi_nmap -f ESC nop
  ble-bind -m vi_nmap -f 'C-[' nop
  # Allow C-y to accept auto completion
  ble-bind -m auto_complete -f C-y auto_complete/accept-line

  # Open command line in editor with C-v C-v
  ble-bind -m vi_imap -f 'C-v C-v' 'edit-and-execute-command'
  ble-bind -m vi_nmap -f 'C-v C-v' 'vi-command/edit-and-execute-command'
}
blehook/eval-after-load keymap_vi my/vim-load-hook

# Turn on vi-mode (overrides any previous 'set -o vi/emacs'
bleopt default_keymap=vi

# Set auto complete to be gray instead of reversed
ble-face -s auto_complete fg=240
