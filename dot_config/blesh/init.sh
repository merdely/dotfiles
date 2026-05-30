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

function ble/widget/my/discard-line-to-insert-mode {
  ble/widget/discard-line
  ble/widget/vi_nmap/insert-mode
}

# Configure vim mode
function my/vim-load-hook {
  # Do not show vi mode
  bleopt keymap_vi_mode_show=

  # Load surround module
  ble-import vim-surround

  # Go to start of line when going up through history 
  ble-bind -m vi_nmap -f k my/vi-command/backward-line
  # Let C-c cancel a command in normal mode
  ble-bind -m vi_imap -f C-c discard-line
  ble-bind -m vi_nmap -f C-c my/discard-line-to-insert-mode
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

# Skip unnecessary redraws
bleopt exec_elapsed_mark=      # disable elapsed time display

bleopt highlight_timeout_sync=20    # time (ms) for synchronous highlight before deferring
bleopt highlight_timeout_async=200  # time (ms) for async highlight completion

# Configure completion
function my/complete-load-hook {
  bleopt complete_auto_delay=500
  bleopt complete_limit=50
  bleopt complete_limit_auto=500
  bleopt complete_polling_cycle=50  # how often async jobs are polled (ms)
  bleopt complete_ambiguous=1       # enable async worker

  # Zsh-like completion colors
  ble-face -s auto_complete                fg=240
  ble-face -s command_builtin              fg=240
  ble-face -s filename_directory           fg=blue,bold
  ble-face -s filename_executable          fg=green,bold
  ble-face -s filename_link                fg=cyan,bold
  ble-face -s filename_warning             fg=red,bold
  ble-face -s menu_filter_input            fg=white,bold
  ble-face -s menu_complete_match          fg=white,bold
  ble-face -s menu_complete_selected       reverse
  ble-face -s menu_desc_type               fg=240
  ble-face -s menu_desc_default            fg=240
}
blehook/eval-after-load complete my/complete-load-hook

