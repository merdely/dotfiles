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

from typing import List  # noqa: F401

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import EzClick, EzDrag, Group, EzKey, Match, Rule, Screen  #, Click, Drag, Key
from libqtile.lazy import lazy
#from libqtile.utils import guess_terminal

import os
import platform
import psutil  # type: ignore
import subprocess

# terminal = "kitty"
terminal = "term"  # shell script in $HOME/bin to choose a default terminal
imager = "/usr/bin/feh"  # Override firejail for feh
launcher = "rofi -combi-modi drun,run -modi combi -show combi -display-combi launch"
hostname = platform.node()
home = os.path.expanduser("~")

# Host specific settings
if hostname == "mercury":
    widget_fontsize = 12
    sshauth_interval = 5
    brightness_interval = 5
    battery_interval = 5
    df_interval = 5
    weather_interval = 1800
else:
    # Better font size on my XPS
    widget_fontsize = 16
    # Assume battery and set reasonable interval times
    sshauth_interval = 60
    brightness_interval = 60
    battery_interval = 60
    df_interval = 3600
    weather_interval = 1800

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
    # Qtile keybindings
    EzKey("M-C-r", lazy.restart(), desc="Restart Qtile"),
    EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    EzKey("M-C-v", lazy.spawn('reboot'), desc="Reboot System"),
    EzKey("M-C-z", lazy.spawn('halt -p'), desc="Halt System"),
    EzKey("M-r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    EzKey("M-p", lazy.spawn(launcher), desc="Run a program with Rofi"),
    EzKey("A-p", lazy.spawn(launcher), desc="Run a program with Rofi"),
    EzKey("M-b", lazy.hide_show_bar(), desc="Toggle visibility of Bar"),
    EzKey("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Generate or display help images for keybindings in Qtile
    EzKey("M-A-C-S-<slash>", lazy.spawn(home + '/git/qtile/scripts/gen-keybinding-img -o ' + home + '/.config/qtile/ -c ' + home + '/.config/qtile/config.py'), desc="Regenerate help images"),
    EzKey("A-C-S-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod1-control-shift.png'), desc="Show keybindings with Alt+Control+Shift"),
    EzKey("A-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod1.png'), desc="Show keybindings with Alt"),
    EzKey("A-S-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod1-shift.png'), desc="Show keybindings with Alt+Shift"),
    EzKey("M-C-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod4-control.png'), desc="Show keybindings with Super+Control"),
    EzKey("M-C-S-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod4-control-shift.png'), desc="Show keybindings with Super+Control+Shift"),
    EzKey("M-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod4.png'), desc="Show keybindings with Super"),
    EzKey("M-S-<slash>", lazy.spawn(imager + ' ' + home + '/.config/qtile/mod4-shift.png'), desc="Show keybindings with Super-Shift"),

    # Switch between groups, skipping empty groups & groups on another screen
    EzKey("M-C-<comma>", lazy.screen.prev_group(skip_empty=True, skip_managed=True), desc="Switch to the previous group"),
    EzKey("M-C-<period>", lazy.screen.next_group(skip_empty=True, skip_managed=True), desc="Switch to the next group"),

    # Switch between screens
    EzKey("M-<comma>", lazy.function(focus_prev_screen), desc="Move focus to previous screen"),
    EzKey("M-<period>", lazy.function(focus_next_screen), desc="Move focus to next screen"),

    # Move windows between screens
    EzKey("M-S-<comma>", lazy.function(window_to_prev_screen, switch_screen=True), desc="Move window to previous screen"),
    EzKey("M-S-<period>", lazy.function(window_to_next_screen, switch_screen=True), desc="Move window to next screen"),

    # Switch between windows
    EzKey("M-h", lazy.layout.left(), desc="Move focus to left"),
    EzKey("M-l", lazy.layout.right(), desc="Move focus to right"),
    EzKey("M-j", lazy.layout.down(), desc="Move focus down"),
    EzKey("M-k", lazy.layout.up(), desc="Move focus up"),
    # When full screen, try to handle background windows well
    EzKey("A-<space>", lazy.window.bring_to_front(), desc="Move window to front of screen"),
    EzKey("A-<Tab>", lazy.group.next_window(), desc="Move window focus to other window"),
    EzKey("A-S-<Tab>", lazy.group.prev_window(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    EzKey("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    EzKey("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    EzKey("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    EzKey("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    EzKey("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    EzKey("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Manage windows
    EzKey("M-f", lazy.window.toggle_floating(), desc="Toggle floating mode for window"),
    EzKey("M-S-f", lazy.window.toggle_fullscreen(), desc="Toggle full_screen mode for window"),

    # Toggle between different layouts as defined below
    EzKey("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    EzKey("M-S-c", lazy.window.kill(), desc="Kill focused window"),
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
        EzKey("M-" + shortcut, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),

        # # mod1 + shift + letter of group = switch to & move focused window to group
        EzKey("M-S-" + shortcut, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),

        # mod1 + control + letter of group = move focused window to group
        EzKey("M-C-" + shortcut, lazy.window.togroup(i.name),
            desc="move focused window to group {}".format(i.name)),
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

# Widget theming
widget_defaults = dict(
    font='DejaVu Sans Mono',
    fontsize=widget_fontsize,
    padding=3,
)
sep_size = 60
extension_defaults = widget_defaults.copy()

# I only ever really use Columns
layouts = [
    layout.Columns(**layout_theme, margin=4, border_on_single=True),
    layout.MonadTall(**layout_theme, margin=8),
    layout.Max(**layout_theme),
    layout.Stack(**layout_theme, margin=4, num_stacks=2,),
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
    qtile.cmd_spawn('amixer -q -D pulse sset Capture toggle')
def launch_keyboard():
    qtile.cmd_spawn(home + '/bin/qtile_keyboard.sh')
def launch_sshadd():
    qtile.cmd_spawn('ssh-add')
def launch_volumecontrol():
    qtile.cmd_spawn(home + '/bin/qtile_volumecontrol.sh')
def rotate_desktop():
    qtile.cmd_spawn(home + '/bin/qtile_rotate.sh')

# Use a function so that each screen gets a different instantiation of these widgets
# These widgets are different per screen
def init_widgets_list():
    return [
        widget.GroupBox(**widget_defaults),
        widget.CurrentLayoutIcon(**widget_defaults, scale=.8),
        widget.CurrentScreen(**widget_defaults, active_text="A", inactive_text="I"),
        widget.Prompt(**widget_defaults),
        widget.WindowName(**widget_defaults, mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(launcher)}),
        # widget.Chord(
        #     chords_colors={
        #         'launch': (color_scheme['color-palette-overrides'][colors['red']], color_scheme['color-palette-overrides'][colors['white-bright']]),
        #     },
        #     name_transform=lambda name: name.upper(),
        # ),
    ]

# Define an array so that each screen gets a SHARED instantiation of these widgets
shared_widgets = []

# Neptune has a rotating screen
if hostname == "neptune":
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
    shared_widgets += [ widget.TextBox(**widget_defaults, text="🖥", name="display", mouse_callbacks={'Button1': rotate_desktop}) ]

shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, name='sshauth', update_interval=sshauth_interval, func=lambda: subprocess.check_output(home + "/bin/qtile_sshauth.sh").decode(), mouse_callbacks={'Button1': launch_sshadd}) ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.Volume(**widget_defaults, emoji=True, mouse_callbacks={'Button1': launch_volumecontrol, 'Button3': mute_speaker}) ]
shared_widgets += [ widget.Volume(**widget_defaults, emoji=False, mouse_callbacks={'Button1': launch_volumecontrol, 'Button3': mute_speaker}) ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.TextBox(**widget_defaults, text="🎤", name="mic", mouse_callbacks={'Button1': mute_mic}) ]
shared_widgets += [ widget.Volume(**widget_defaults, channel="Capture") ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, name='brightness', update_interval=brightness_interval, func=lambda: subprocess.check_output(home + "/bin/qtile_brightness.sh").decode()) ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, background="ff0000", foreground="ffffff", name='battery_c', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_battery.sh", "-c"]).decode()) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, background="ffff00", foreground="000000", name='battery_w', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_battery.sh", "-w"]).decode()) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, name='battery_o', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_battery.sh", "-o"]).decode()) ]

# Mercury has a UPS and a battery powered mouse
if hostname == "mercury":
    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
    shared_widgets += [ widget.GenPollText(**widget_defaults, background="ff0000", foreground="ffffff", name='ups_c', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_ups.sh", "-c"]).decode()) ]
    shared_widgets += [ widget.GenPollText(**widget_defaults, background="ffff00", foreground="000000", name='ups_w', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_ups.sh", "-w"]).decode()) ]
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='ups', update_interval=battery_interval, func=lambda: subprocess.check_output([home + "/bin/qtile_ups.sh", "-o"]).decode()) ]

    shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='mousebatt', update_interval=battery_interval, func=lambda: subprocess.check_output(home + "/bin/qtile_mouse_battery.sh").decode()) ]

shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, name='df', update_interval=df_interval, func=lambda: subprocess.check_output(home + "/bin/qtile_df.sh").decode()) ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.GenPollText(**widget_defaults, name='weather', update_interval=weather_interval, func=lambda: subprocess.check_output(home + "/bin/qtile_weather.sh").decode()) ]
shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]

# Allow neptune to touch clock to launch on-screen keyboard (also update the clock less frequently)
if hostname == "neptune":
    shared_widgets += [ widget.GenPollText(**widget_defaults, name='clock', update_interval=30, func=lambda: subprocess.check_output(home + "/bin/qtile_clock.sh").decode(), mouse_callbacks={'Button1': launch_keyboard}) ]
else:
    shared_widgets += [ widget.Clock(**widget_defaults, format='%a %-m/%-d, %-I:%M:%S%P') ]

shared_widgets += [ widget.Sep(**widget_defaults, size_percent=sep_size) ]
shared_widgets += [ widget.QuickExit(default_text = '🔑', countdown_format = ' {} ') ]

# Define an array to make setting up widgets easier
systray_widgets = [
    widget.Sep(**widget_defaults, size_percent=sep_size),
    widget.Systray(**widget_defaults),
]

# Define the screens and bars at the top
screens = [
    Screen(top=bar.Bar(widgets=init_widgets_list() + shared_widgets + systray_widgets, size=24)),
    Screen(top=bar.Bar(widgets=init_widgets_list() + shared_widgets, size=24)),
]

dgroups_key_binder = None

# Define group rules for specific apps
dgroups_app_rules = [
    # Group 1 == kitty  # Leave terminal floating in any group
    Rule(Match(wm_class=['qutebrowser']), group="2"),
    Rule(Match(wm_class=['Youtube']), group="3"),
    Rule(Match(wm_class=['plexmediaplayer']), group="3"),
    Rule(Match(wm_class=['spotify-qt', 'spotify', 'Spotify']), group="3"), # This isn't working -- made a ~/.local/share/applications/spotify.desktop with 'qtile run-cmd -g 3 spotify'
    Rule(Match(wm_class=['joplin', 'Joplin']), group="4"),
    Rule(Match(wm_class=['bitwarden', 'Bitwarden']), group="5"),
    Rule(Match(wm_class=['Vncviewer']), group="6"),
    Rule(Match(wm_class=['Steam', 'steam', 'steam_app_1172380', 'Origin', 'origin', 'origin.exe']), group="7"),
    Rule(Match(title=['Steam setup', 'Steam', 'steam', 'Origin', 'origin', 'origin.exe']), group="7"),
    Rule(Match(wm_class=['vlc']), group="-"),
    Rule(Match(wm_class=['Falkon', 'firefox']), group="="),
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(title='dzen slave'),
    Match(wm_class='ssh-askpass'),
    Match(wm_class='SshAskpass'),
    Match(wm_class='Gimp'),
    Match(wm_class='Xmessage'),
    Match(wm_class='Galculator'),
    Match(wm_class='dzen'),
    Match(wm_class='Yad'),
    Match(wm_class='origin.exe'),
    Match(title='origin.exe'),
    Match(title='origin'),
    Match(title='Origin'),
    Match(wm_class='Steam'),
    Match(wm_class='steam'),
    Match(wm_class='steam_app_1172380'),
    Match(title='Steam setup'),
    Match(title='Steam'),
    Match(title='steam'),
    Match(wm_class='Onboard'),
    Match(wm_class='Pavucontrol'),
    Match(wm_class='feh'),
    Match(wm_class='Nm-connection-editor'),
])

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False  # This sucks for dialog boxes
auto_fullscreen = True
focus_on_window_activation = "smart"
#reconfigure_screens = True
#auto_minimize = True
wmname = "qtile"

# For window swallowing (when a program starts a program, hide calling program)
@hook.subscribe.client_new
def _swallow(window):
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
    for i in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            parent.minimized = True
            window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()

# For window swallowing (when a program starts a program, hide calling program)
@hook.subscribe.client_killed
def _unswallow(window):
    if hasattr(window, 'parent'):
        window.parent.minimized = False

