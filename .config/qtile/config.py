# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 2021 Michael Erdely
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Derived from /usr/share/doc/qtile/default_config.py

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import EzClick, EzDrag, EzKey, Group, Match, Rule, Screen, DropDown, ScratchPad  #, Key, KeyChord
from libqtile.lazy import lazy

import os
import platform
import psutil  # type: ignore
import subprocess

terminal = "x-terminal-emulator"  # shell script in $HOME/bin to choose a default terminal
imager = "feh"  # Override firejail for feh
launcher = "rofi -combi-modi drun,run -modi combi -show combi -display-combi launch"
sysmon = "bpytop"
#sysmon = "btop"
hostname = platform.node()
home = os.path.expanduser("~")

# ScratchPad Settings
bitwarden_opacity=0.90
pavucontrol_opacity = 1.00
pcmanfm_opacity = 1.00
hexchat_opacity = 1.00
signal_opacity = 1.00

scratch_opacity=1.00
scratch_height=0.80
scratch_width=0.80
scratch_x=0.10
scratch_y=0.10
full_opacity=1.00
full_height=0.98
full_width=0.99
full_x=0.005
full_y=0.010
term_opacity = 0.90
help_opacity = 0.90
help_height=0.76
help_width=0.665
help_x=0.165
help_y=0.10
vnc_opacity=1.00
vnc_height=0.86
vnc_width=0.84
vnc_x=0.10
vnc_y=0.05

# Widget Settings
widget_fontsize = 12
exit_widget=1               # Set to 0 to disable
computer_temp_widget=0      # Set to 1 to enable
nvidia_widget=0             # Set to 1 to enable
onscreen_keyboard = 0       # Set to 0 to disable
rotate_widget=0             # Set to 0 to disable
systray_widget=1            # Set to 0 to disable
volume_widget = 1           # Set to 0 to disable
volume_mic_widget = 1       # Set to 0 to disable
audio_output_interval = -1  # Set to -1 to disable
battery_interval = 60       # Set to -1 to disable
brightness_interval = 60    # Set to -1 to disable
clock_interval = 30         # Set to -1 to disable, -2 to use built-in Widget
df_interval = 3600          # Set to -1 to disable
keyboardbatt_interval = -1  # Set to -1 to disable
mousebatt_interval = -1     # Set to -1 to disable
sshauth_interval = 60       # Set to -1 to disable
updates_interval = -1       # Set to -1 to disable
ups_interval = -1           # Set to -1 to disable
weather_interval = 1800     # Set to -1 to disable
xscreensaver_interval = 60  # Set to -1 to disable

# Host specific settings
if hostname == "mercury":
    computer_temp_widget=1
    nvidia_widget=1
    audio_output_interval = 5
    battery_interval = 5
    brightness_interval = 5
    clock_interval = -2
    df_interval = 5
    #keyboardbatt_interval = 5
    #mousebatt_interval = 5
    pcmanfm_opacity = 0.90
    sshauth_interval = 5
    updates_interval = 60
    ups_interval = 5
elif hostname == 'neptune':
    widget_fontsize = 16
    onscreen_keyboard = 1
    rotate_widget=1
    updates_interval = 3600
    help_height=0.68
    help_width=0.665
    help_x=0.165
    help_y=0.15
    vnc_height=0.775
    vnc_width=0.84
    vnc_x=0.10
    vnc_y=0.07
elif hostname == 'ersa':
    updates_interval = 3600
    help_opacity=1.00
    help_height=0.99
    help_width=0.935
    help_x=0.035
    help_y=0.000
    vnc_height=0.99
    vnc_width=0.99
    vnc_x=0.000
    vnc_y=0.000

# Move a window to the previous screen
def window_to_prev_screen(qtile, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen) - 1
    if i < 0:
        i = len(qtile.screens) - 1
    group = qtile.screens[i].group.name
    qtile.current_window.togroup(group)
    if switch_screen:
      qtile.focus_screen(i)

# Move a window to the next screen
def window_to_next_screen(qtile, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen) + 1
    if i >= len(qtile.screens):
        i = 0
    group = qtile.screens[i].group.name
    qtile.current_window.togroup(group)
    if switch_screen:
      qtile.focus_screen(i)

# Better cursor warp when changing screen focus than cursor_warp
def focus_prev_screen(qtile):
    # Determine previous window index
    i = qtile.screens.index(qtile.current_screen) + 1
    if i >= len(qtile.screens):
        i = 0

    # Change to next screen
    qtile.focus_screen(i)

    # Move mouse pointer to screen
    qtile.warp_to_screen()

    # Focus on current window
    qtile.current_group.focus(qtile.current_window)

# Better cursor warp when changing screen focus than cursor_warp
def focus_next_screen(qtile):
    # Determine next window index
    i = qtile.screens.index(qtile.current_screen) - 1
    if i < 0:
        i = len(qtile.screens) - 1

    # Change to next screen
    qtile.focus_screen(i)

    # Move mouse pointer to screen
    qtile.warp_to_screen()

    # Focus on current window
    qtile.current_group.focus(qtile.current_window)

# I try to make the keybindings reasonably close to Qtile defaults
# Some of these keybindings are overridden (but probably the same) as xbindkeys
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Key codes: https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py

    # Other bindings (defined in xbindkeys, but also here so they show up in the help slides)
    # xbindkeys takes precedence over what's defined here
    EzKey("A-S-l", lazy.spawn("xscreensaver-command -lock"), desc="Lock screen"),
    EzKey("A-S-s", lazy.spawn("xscreensaver-command -lock"), desc="Lock screen"),
    EzKey("C-<space>", lazy.spawn("dunstctl close-all"), desc="Close notifications"),
    EzKey("A-S-w", lazy.spawn("feh -Z. " + home + "/.config/wallpaper/qutebrowser/cheatsheet.png"), desc="Qutebrowser cheetsheet"),
    EzKey("A-S-d", lazy.spawn(home + "/bin/cheatsheet_dwm.sh"), desc="DWM Cheatsheet"),
    EzKey("A-S-g", lazy.spawn(home + "/bin/cheatsheet_gmail.sh"), desc="Gmail Cheatsheet"),
    EzKey("A-S-a", lazy.spawn(home + "/bin/cheatsheet_alpha.sh"), desc="Phonetic Alphabet Cheatsheet"),
    EzKey("A-S-x", lazy.spawn(home + "/bin/cheatsheet_xbindkeys.sh"), desc="XBindKeys Cheatsheet"),
    EzKey("A-S-y", lazy.spawn(home + "/bin/cheatsheet_youtube.sh"), desc="Youtube Cheatsheet"),
    EzKey("A-S-k", lazy.spawn("rofi -show linkding -modi linkding:rofi-linkding"), desc="Linkding Bookmarks"),
    EzKey("A-S-c", lazy.spawn("rofi -show calc -modi calc -no-show-match -no-sort"), desc="Rofi Calculator"),
    EzKey("A-S-p", lazy.spawn("rofi -show p -modi p:" + home + "/bin/rofi-power-menu"), desc="Power Menu"),
    EzKey("C-A-<Delete>", lazy.spawn("rofi -show p -modi p:" + home + "/bin/rofi-power-menu"), desc="Power Menu"),
    EzKey("A-S-e", lazy.spawn("rofi -modi 'emoji:/usr/bin/rofimoji' -show emoji"), desc="Emoji Picker"),
    EzKey("A-S-b", lazy.spawn(home + "/bin/bwmenu --auto-lock 7200"), desc="Rofi Bitwarden"),
    EzKey("M-<Up>", lazy.spawn(home + "/bin/adjust_brightness up"), desc="Increase Brightness"),
    EzKey("M-<Down>", lazy.spawn(home + "/bin/adjust_brightness down"), desc="Decrease Brightness"),
    EzKey("M-C-<space>", lazy.spawn(home + "/bin/audio_output_toggle.sh -u"), desc="Toggle Headphones/Speakers"),
    EzKey("M-m", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Mute Speakers"),
    EzKey("M-<Left>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"), desc="Decrease Speaker Volume"),
    EzKey("M-<Right>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"), desc="Increase Speaker Volume"),
    EzKey("M-S-m", lazy.spawn(home + "/bin/pactl_toggle_mic_mute.sh"), desc="Mute Mic"),
    EzKey("M-S-<Left>", lazy.spawn("pactl set-source-volume @DEFAULT_SINK@ -2%"), desc="Decrease Mic Volume"),
    EzKey("M-S-<Right>", lazy.spawn("pactl set-source-volume @DEFAULT_SINK@ +2%"), desc="Increase Mic Volume"),

    # Qtile keybindings
    EzKey("M-C-r", lazy.reload_config(), desc="Reload Qtile config"),
    EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    EzKey("M-r", lazy.spawncmd(), desc="Qtile command prompt"),
    EzKey("M-p", lazy.spawn(launcher), desc="Program launcher"),
    EzKey("M-w", lazy.window.kill(), desc="Kill window"),
    EzKey("M-n", lazy.layout.normalize(), desc="Reset window sizes"),
    EzKey("M-b", lazy.hide_show_bar(), desc="Toggle bar Visibility"),
    EzKey("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Generate or display help images for keybindings in Qtile
    EzKey("M-A-C-S-<slash>", lazy.spawn(home + '/bin/gen_qtile_help.sh'), desc="Generate help images"),

    # Switch between groups, skipping empty groups & groups on another screen
    EzKey("M-S-<Tab>", lazy.screen.prev_group(skip_empty=True, skip_managed=True), desc="Switch to prev group"),
    EzKey("M-<Tab>", lazy.screen.next_group(skip_empty=True, skip_managed=True), desc="Switch to next group"),
    EzKey("M-C-<comma>", lazy.screen.prev_group(skip_empty=True, skip_managed=True), desc="Switch to prev group"),
    EzKey("M-C-<period>", lazy.screen.next_group(skip_empty=True, skip_managed=True), desc="Switch to next group"),
    EzKey("M-<grave>", lazy.screen.next_group(skip_empty=True, skip_managed=True), desc="Switch to next group"),
    EzKey("M-S-<grave>", lazy.screen.prev_group(skip_empty=True, skip_managed=True), desc="Switch to prev group"),

    # Toggle between current group and previous group
    EzKey("A-<Tab>", lazy.screen.toggle_group(), desc="Switch to prev group"),
    EzKey("A-S-<Tab>", lazy.screen.toggle_group(), desc="Switch to prev group"),

    # When full screen or floating, cycle through windows in current group
    EzKey("A-<grave>", lazy.group.next_window(), lazy.window.bring_to_front(), desc="Move window focus to other window"),
    EzKey("A-S-<Tab>", lazy.group.prev_window(), lazy.window.bring_to_front(), desc="Move window focus to other window"),

    # Switch between screens
    EzKey("M-<comma>", lazy.function(focus_prev_screen), desc="Move focus to prev screen"),
    EzKey("M-<period>", lazy.function(focus_next_screen), desc="Move focus to next screen"),

    # Move windows between screens
    EzKey("M-S-<comma>", lazy.function(window_to_prev_screen, switch_screen=True), desc="Move window to prev screen"),
    EzKey("M-S-<period>", lazy.function(window_to_next_screen, switch_screen=True), desc="Move window to next screen"),

    # Switch between windows
    EzKey("M-h", lazy.layout.left(), desc="Move focus left"),
    EzKey("M-l", lazy.layout.right(), desc="Move focus right"),
    EzKey("M-j", lazy.layout.down(), desc="Move focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Move focus up"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move window left"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move window right"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    EzKey("M-C-h", lazy.layout.grow_left(), desc="Grow window left"),
    EzKey("M-C-l", lazy.layout.grow_right(), desc="Grow window right"),
    EzKey("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    EzKey("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    EzKey("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split/unsplit sides of stack"),

    # Manage windows
    EzKey("M-f", lazy.window.toggle_floating(), desc="Toggle floating for window"),
    EzKey("M-S-f", lazy.window.toggle_fullscreen(), desc="Toggle full screen for window"),

    # Toggle between different layouts as defined below
    EzKey("M-<space>", lazy.next_layout(), desc="Toggle between layouts"),
]

# Mouse bindings
mouse = [
    EzDrag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    EzDrag("M-3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    EzClick("M-2", lazy.window.bring_to_front())
]

# Define groups for the number row (12 groups: 1 through =)
groups = [Group(i) for i in "1234567890-="]

for i in groups:
    shortcut = i.name
    # Fix shortcut keys for - and =
    if shortcut == "-":
        shortcut = "<minus>"
    elif shortcut == "=":
        shortcut = "<equal>"

    keys.extend([
        # mod1 + letter of group = switch to group
        EzKey("M-" + shortcut, lazy.group[i.name].toscreen(toggle=True), desc="Switch to group {}".format(i.name)),

        # # mod1 + shift + letter of group = switch to & move focused window to group
        EzKey("M-S-" + shortcut, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),

        # mod1 + control + letter of group = move focused window to group
        EzKey("M-C-" + shortcut, lazy.window.togroup(i.name),
            desc="move focused window to group {}".format(i.name)),
    ])

# ScratchPad
groups.append(
        ScratchPad("scratchpad", [
            # When GUI apps don't go away on their own, they need the "match=Match(wm_class='Class')" code
            DropDown("ranger", "x-terminal-emulator --class Ranger -e ranger", on_focus_lost_hide=False, warp_pointer=False, opacity=term_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("pcmanfm", "pcmanfm", on_focus_lost_hide=False, warp_pointer=False, opacity=pcmanfm_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),

            DropDown("youtube", "youtube", match=Match(wm_class="Youtube"), on_focus_lost_hide=False, warp_pointer=False, opacity=full_opacity, height=full_height, width=full_width, x=full_x, y=full_y),
            DropDown("spotify", "qtile run-cmd -g scratchpad spotify", match=Match(wm_class="Spotify"), on_focus_lost_hide=False, warp_pointer=False, opacity=scratch_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("plex", "plexmediaplayer", match=Match(wm_class="plexmediaplayer"), on_focus_lost_hide=False, warp_pointer=False, opacity=full_opacity, height=full_height, width=full_width, x=full_x, y=full_y),
            DropDown("netflix", "netflix-nativefier", match=Match(wm_class="netflix-nativefier-b2d713"), on_focus_lost_hide=False, warp_pointer=False, opacity=full_opacity, height=full_height, width=full_width, x=full_x, y=full_y),
            DropDown("jellyfin", "jellyfin-nativefier", match=Match(wm_class="jellyfin-nativefier-da2a40"), on_focus_lost_hide=False, warp_pointer=False, opacity=full_opacity, height=full_height, width=full_width, x=full_x, y=full_y),

            DropDown("signal", "signal-desktop --use-tray-icon", match=Match(wm_class='Signal'), on_focus_lost_hide=False, warp_pointer=False, opacity=signal_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("term", "x-terminal-emulator", on_focus_lost_hide=False, warp_pointer=False, opacity=term_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),

            DropDown("vncviewer", "vncviewer -passwd "+home+"/.vnc/earth_passwd earth.erdely.in:5955", match=Match(wm_class="Vncviewer"), on_focus_lost_hide=False, warp_pointer=False, opacity=vnc_opacity, height=vnc_height, width=vnc_width, x=vnc_x, y=vnc_y),
            DropDown("vncviewer_local", "vncviewer -passwd "+home+"/.vnc/earth_passwd localhost:5955", match=Match(wm_class="Vncviewer"), on_focus_lost_hide=False, warp_pointer=False, opacity=vnc_opacity, height=vnc_height, width=vnc_width, x=vnc_x, y=vnc_y),
            DropDown("virtmanager", "virt-manager", match=Match(wm_class="Virt-manager"), on_focus_lost_hide=False, warp_pointer=False, opacity=vnc_opacity, height=vnc_height, width=vnc_width, x=vnc_x, y=vnc_y),
            DropDown("hexchat", "hexchat --existing --command='gui show'", match=Match(wm_class='Hexchat'), on_focus_lost_hide=False, warp_pointer=False, opacity=hexchat_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("mixer", "pavucontrol", match=Match(wm_class="Pavucontrol"), on_focus_lost_hide=False, warp_pointer=False, opacity=pavucontrol_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("sysmon", "x-terminal-emulator --class sysmon -e " + sysmon, match=Match(wm_class='sysmon'), on_focus_lost_hide=False, warp_pointer=False, opacity=term_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("btop", "x-terminal-emulator --class sysmon -e btop", match=Match(wm_class='sysmon'), on_focus_lost_hide=False, warp_pointer=False, opacity=term_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            DropDown("htop", "x-terminal-emulator --class sysmon -e htop", match=Match(wm_class='sysmon'), on_focus_lost_hide=False, warp_pointer=False, opacity=term_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),
            # DropDown("joplin", "joplin-desktop", match=Match(wm_class='Joplin'), on_focus_lost_hide=False, warp_pointer=False, opacity=full_opacity, height=full_height, width=full_width, x=full_x, y=full_y),
            DropDown("bitwarden", "bitwarden-desktop", match=Match(wm_class='Bitwarden'), on_focus_lost_hide=False, warp_pointer=False, opacity=bitwarden_opacity, height=scratch_height, width=scratch_width, x=scratch_x, y=scratch_y),

            DropDown("help-a-c-s-slash", imager + ' --class help-a-c-s-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod1-control-shift.png_negate.png', match=Match(wm_class='help-a-c-s-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-a-slash", imager + ' --class help-a-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod1.png_negate.png', match=Match(wm_class='help-a-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-a-s-slash", imager + ' --class help-a-s-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod1-shift.png_negate.png', match=Match(wm_class='help-a-s-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-m-c-slash", imager + ' --class help-m-c-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod4-control.png_negate.png', match=Match(wm_class='help-m-c-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-m-c-s-slash", imager + ' --class help-m-c-s-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod4-control-shift.png_negate.png', match=Match(wm_class='help-m-c-s-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-m-slash", imager + ' --class help-m-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod4.png_negate.png', match=Match(wm_class='help-m-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            DropDown("help-m-s-slash", imager + ' --class help-m-s-slash --auto-reload ' + home + '/.config/wallpaper/qtile/mod4-shift.png_negate.png', match=Match(wm_class='help-m-s-slash'), on_focus_lost_hide=False, warp_pointer=False, opacity=help_opacity, height=help_height, width=help_width, x=help_x, y=help_y),
            ]),
        )

keys.extend([
    EzKey("M-C-o", lazy.group["scratchpad"].dropdown_toggle('ranger'), desc="Show/hide Ranger"),
    EzKey("M-C-p", lazy.group["scratchpad"].dropdown_toggle('pcmanfm'), desc="Show/hide File Manager"),

    EzKey("M-C-a", lazy.group["scratchpad"].dropdown_toggle('jellyfin'), desc="Show/hide Jellyfin"),
    EzKey("M-C-s", lazy.group["scratchpad"].dropdown_toggle('netflix'), desc="Show/hide Netflix"),
    EzKey("M-C-d", lazy.group["scratchpad"].dropdown_toggle('plex'), desc="Show/hide Plex"),
    EzKey("M-C-f", lazy.group["scratchpad"].dropdown_toggle('spotify'), desc="Show/hide Spotify"),
    EzKey("M-C-g", lazy.group["scratchpad"].dropdown_toggle('youtube'), desc="Show/hide Youtube"),

    EzKey("M-C-<semicolon>", lazy.group["scratchpad"].dropdown_toggle('signal'), desc="Show/hide Signal"),
    EzKey("M-C-<Return>", lazy.group["scratchpad"].dropdown_toggle('term'), desc="Show/hide terminal"),

    EzKey("M-C-z", lazy.group["scratchpad"].dropdown_toggle('vncviewer'), desc="Show/hide Vncviewer"),
    EzKey("M-C-i", lazy.group["scratchpad"].dropdown_toggle('vncviewer_local'), desc="Show/hide Vncviewer (local)"),
    EzKey("M-C-x", lazy.group["scratchpad"].dropdown_toggle('virtmanager'), desc="Show/hide Virt Manager"),
    EzKey("M-C-c", lazy.group["scratchpad"].dropdown_toggle('hexchat'), desc="Show/hide Hexchat"),
    EzKey("M-C-v", lazy.group["scratchpad"].dropdown_toggle('mixer'), desc="Show/hide Mixer"),
    EzKey("M-C-b", lazy.group["scratchpad"].dropdown_toggle('sysmon'), desc="Show/hide System Monitor"),
    EzKey("M-C-n", lazy.group["scratchpad"].dropdown_toggle('btop'), desc="Show/hide System Monitor (btop)"),
    EzKey("M-C-h", lazy.group["scratchpad"].dropdown_toggle('htop'), desc="Show/hide System Monitor (htop)"),
    # EzKey("M-C-n", lazy.group["scratchpad"].dropdown_toggle('joplin'), desc="Show/hide Joplin"),
    EzKey("M-C-m", lazy.group["scratchpad"].dropdown_toggle('bitwarden'), desc="Show/hide Bitwarden"),
    EzKey("A-C-S-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-a-c-s-slash'), desc="Show keybindings with Alt+Control+Shift"),
    EzKey("A-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-a-slash'), desc="Show keybindings with Alt"),
    EzKey("A-S-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-a-s-slash'), desc="Show keybindings with Alt+Shift"),
    EzKey("M-C-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-m-c-slash'), desc="Show keybindings with Super+Control"),
    EzKey("M-C-S-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-m-c-s-slash'), desc="Show keybindings with Super+Control+Shift"),
    EzKey("M-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-m-slash'), desc="Show keybindings with Super"),
    EzKey("M-S-<slash>", lazy.group["scratchpad"].dropdown_toggle('help-m-s-slash'), desc="Show keybindings with Super+Shift"),
    ])

# Theming: I tried to define my color scheme to make copying/pasting from http://terminal.sexy easy.
# Uses "Chrome Secure Shell" Export format from http://terminal.sexy/
# color-palette-overrides: black, red, green, yellow, blue, magenta, cyan, white, then the same colors for "bright"
colors = {
        'black': 0, 'red': 1, 'green': 2, 'yellow': 3, 'blue': 4, 'magenta': 5, 'cyan': 6, 'white': 7,
        'black-bright': 8, 'red-bright': 9, 'green-bright': 10, 'yellow-bright': 11, 'blue-bright': 12, 'magenta-bright': 13, 'cyan-bright': 14, 'white-bright': 15,
}
color_scheme = {
"background-color": "#1d1f21",
"foreground-color": "#c5c8c6",
"cursor-color":     "#215578",
"color-palette-overrides": ["#1d1f21","#cc342b","#198844","#fba922","#3971ed","#a36ac7","#3971ed","#c5c8c6","#969896","#cc342b","#198844","#fba922","#3971ed","#a36ac7","#3971ed","#ffffff"]
}

# Layout theming
layout_theme = {
    "border_width": 1,
    "border_focus": color_scheme['cursor-color'],
    "border_normal": color_scheme['color-palette-overrides'][colors['black-bright']],
}
floating_theme = layout_theme.copy()

# Widget theming
widget_defaults = dict(
    font='sans',
    fontsize=widget_fontsize,
    padding=3,
)
sep_size = 60
extension_defaults = widget_defaults.copy()

# I only ever really use Columns
layouts = [
    layout.Columns(**layout_theme, margin=4, border_on_single=True),  # type: ignore
    layout.MonadTall(**layout_theme, margin=8),  # type: ignore
    layout.Max(**layout_theme),  # type: ignore
    layout.Stack(**layout_theme, margin=4, num_stacks=2,),  # type: ignore
    # layout.Bsp(margin=8),
    # layout.Matrix(margin=8),
    # layout.MonadWide(margin=8),
    # layout.RatioTile(margin=8),
    # layout.Tile(margin=8),
    # layout.TreeTab(margin=8),
    # layout.VerticalTile(margin=8),
    # layout.Zoomy(margin=8),
    ]

# Define some functions for widgets
def mute_speaker():
    qtile.cmd_spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle')
def mute_mic():
    qtile.cmd_spawn(home + '/bin/pactl_toggle_mic_mute.sh')
def launch_keyboard():
    qtile.cmd_spawn(home + '/bin/qtile_keyboard.sh')
def launch_sshadd():
    qtile.cmd_spawn('ssh-add')
def launch_volumecontrol():
    qtile.cmd_spawn(home + '/bin/qtile_volumecontrol.sh')
def rotate_desktop():
    qtile.cmd_spawn(home + '/bin/qtile_rotate.sh')
def update_widget(s):
    subprocess.run([home + '/bin/qtile_widget.sh', s])

# Use a function so that each screen gets a different instantiation of these widgets
# These widgets are different per screen
def init_widgets_list():
    return [
        widget.GroupBox(**widget_defaults),  # type: ignore
        widget.CurrentLayoutIcon(**widget_defaults, scale=.8),  # type: ignore
        widget.CurrentScreen(**widget_defaults, active_text="A", inactive_text="I"),  # type: ignore
        widget.Prompt(**widget_defaults),  # type: ignore
        widget.WindowName(**widget_defaults, mouse_callbacks={'Button1': lazy.spawn(launcher)}),  # type: ignore
    ]

# Define an array so that each screen gets a SHARED instantiation of these widgets
shared_widgets = []

# Neptune has a rotating screen
if rotate_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.TextBox(**widget_defaults, text="🖥", name="display", mouse_callbacks={'Button1': rotate_desktop}) ]  # type: ignore

if xscreensaver_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='xscreensaver', update_interval=xscreensaver_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "xscreensaver"]).decode(), mouse_callbacks={'Button1': launch_sshadd, 'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q xscreensaver')}) ]  # type: ignore

if sshauth_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='sshauth', update_interval=sshauth_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "sshauth"]).decode(), mouse_callbacks={'Button1': launch_sshadd, 'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q sshauth')}) ]  # type: ignore

if volume_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.Volume(**widget_defaults, emoji=True, mouse_callbacks={'Button1': launch_volumecontrol, 'Button3': mute_speaker}) ]  # type: ignore
    shared_widgets += [ widget.Volume(**widget_defaults, emoji=False, mouse_callbacks={'Button1': launch_volumecontrol, 'Button3': mute_speaker}) ]  # type: ignore
if volume_mic_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.TextBox(**widget_defaults, text="🎤", name="mic", mouse_callbacks={'Button1': mute_mic}) ]  # type: ignore
    shared_widgets += [ widget.Volume(**widget_defaults, channel="Capture") ]  # type: ignore

if brightness_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='brightness', update_interval=brightness_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "brightness"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q brightness')}) ]  # type: ignore

if battery_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='battery', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "battery"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q battery')}) ]  # type: ignore

# Mercury has a UPS and a battery powered mouse
if ups_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='ups', update_interval=ups_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "ups"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q ups')}) ]  # type: ignore

if mousebatt_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='mousebatt', update_interval=mousebatt_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "mousebatt"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q mousebatt')}) ]  # type: ignore

if keyboardbatt_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='keyboardbatt', update_interval=keyboardbatt_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "keyboardbatt"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q keyboardbatt')}) ]  # type: ignore

if df_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='df', update_interval=df_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "df"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q df')}) ]  # type: ignore

if weather_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='weather', update_interval=weather_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "weather"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q weather')}) ]  # type: ignore

if computer_temp_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.TextBox(**widget_defaults, text="💻", name="thermal") ]  # type: ignore
    shared_widgets += [ widget.ThermalSensor(**widget_defaults) ]  # type: ignore

if nvidia_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.TextBox(**widget_defaults, text="🖥", name="nvidia") ]  # type: ignore
    shared_widgets += [ widget.NvidiaSensors(**widget_defaults) ]  # type: ignore

if audio_output_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='audio_output', update_interval=audio_output_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "audio_output"]).decode(), mouse_callbacks={'Button1': lazy.spawn(home + '/bin/audio_output_toggle.sh -u'), 'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q audio_output')}) ]  # type: ignore

shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
if clock_interval == -2:
    shared_widgets += [ widget.Clock(**widget_defaults, format='%a %-m/%-d, %-I:%M:%S%P') ]  # type: ignore
if clock_interval > -1 and onscreen_keyboard == 1:
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='clock', update_interval=clock_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "clock"]).decode(), mouse_callbacks={'Button1': launch_keyboard}) ]  # type: ignore
if clock_interval > -1 and onscreen_keyboard != 1:
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='clock', update_interval=clock_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "clock"]).decode()) ]  # type: ignore

if updates_interval != -1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='updates', update_interval=updates_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_bar.sh", "updates"]).decode(), mouse_callbacks={'Button3': lazy.spawn(home + '/bin/qtile_bar.sh -q updates force')}) ]  # type: ignore

if exit_widget == 1:
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    shared_widgets += [ widget.QuickExit(default_text = '🔚', countdown_format = ' {} ') ]  # type: ignore

# Define an array to make setting up widgets easier
systray_widgets = []
if systray_widget == 1:
    systray_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]  # type: ignore
    systray_widgets += [ widget.Systray(**widget_defaults) ]  # type: ignore

# Define the screens and bars at the top
screens = [
    Screen(top=bar.Bar(widgets=init_widgets_list() + shared_widgets + systray_widgets, size=24)),
    Screen(top=bar.Bar(widgets=init_widgets_list() + shared_widgets, size=24)),
]

dgroups_key_binder = None

# Define group rules for specific apps
dgroups_app_rules = [
    # Group 1 == terminal  # Leave terminal floating in any group
    Rule(Match(wm_class=['qutebrowser']), group="2"),
    Rule(Match(wm_class=['Steam', 'steam', 'steam_app_1172380', 'Origin', 'origin', 'origin.exe']), group="5"),
    Rule(Match(title=['Steam setup', 'Steam', 'steam', 'Origin', 'origin', 'origin.exe']), group="5"),
    Rule(Match(wm_class=['mpvcam']), group="-"),
    #Rule(Match(wm_class=['Falkon', 'firefox']), group="="),
    ]  # type: list

floating_layout = layout.Floating(float_rules=[  # type: ignore
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,  # type: ignore
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(title='dzen slave'),
    Match(wm_class='Pinentry-gtk-2'),  # GPG key password entry
    Match(wm_class='ssh-askpass'),
    Match(wm_class='SshAskpass'),
    Match(wm_class='Gimp'),
    Match(title='origin'),
    Match(title='Origin'),
    Match(title='origin.exe'),
    Match(title='steam'),
    Match(title='Steam'),
    Match(title='Steam setup'),
    #Match(wm_class='Bitwarden'),
    Match(wm_class='Blueman-manager'),
    Match(wm_class='dzen'),
    Match(wm_class='feh'),
    Match(wm_class='Galculator'),
    Match(wm_class='Gifview'),
    Match(wm_class='Hexchat'),
    #Match(wm_class='Joplin'),
    Match(wm_class='org.remmina.Remmina'),
    Match(wm_class='MagicPoint'),
    Match(wm_class='Mixer'),
    Match(wm_class='Nm-connection-editor'),
    Match(wm_class='Nsxiv'),
    Match(wm_class='Nvim'),
    Match(wm_class='Onboard'),
    Match(wm_class='origin.exe'),
    Match(wm_class='Pavucontrol'),
    Match(wm_class='Peek'),
    Match(wm_class='Piper'),
    Match(wm_class='Ranger'),
    Match(wm_class='Signal'),
    Match(wm_class='Solaar'),
    Match(wm_class='Spotify'),
    Match(wm_class='steam'),
    Match(wm_class='Steam'),
    Match(wm_class='steam_app_1172380'),
    Match(wm_class='Sxiv'),
    #Match(wm_class='Virt-manager'),
    Match(wm_class='vlc'),
    Match(wm_class='Vncviewer'),
    Match(wm_class='XEyes'),
    Match(wm_class='Xmessage'),
    Match(wm_class='XTermFloat'),
    Match(wm_class='Yad'),
    ],
**floating_theme,
)

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False  # This sucks for dialog boxes
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "qtile"

# For window swallowing (when a program starts a program, hide calling program)
#@hook.subscribe.client_new
#def _swallow(window):
#    pid = window.window.get_net_wm_pid()
#    ppid = psutil.Process(pid).ppid()
#    cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
#    for i in range(5):
#        if not ppid:
#            return
#        if ppid in cpids:
#            parent = window.qtile.windows_map.get(cpids[ppid])
#            parent.minimized = True
#            window.parent = parent
#            return
#        ppid = psutil.Process(ppid).ppid()
#
## For window swallowing (when a program starts a program, hide calling program)
#@hook.subscribe.client_killed
#def _unswallow(window):
#    if hasattr(window, 'parent'):
#        window.parent.minimized = False

# Run autostart.sh when Qtile starts
@hook.subscribe.startup_once
def autostart():
    if os.path.exists(home + '/.config/qtile/autostart.sh'):
        subprocess.Popen(home + '/.config/qtile/autostart.sh')
