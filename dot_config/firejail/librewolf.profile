# Firejail profile for librewolf
# Description: Firefox fork based on privacy
# This file is overwritten after every install/update
# Persistent local customizations
include librewolf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/librewolf
# Use Profiles from ~/.config -- noblacklist ${HOME}/.librewolf

mkdir ${HOME}/.cache/librewolf
# Use Profiles from ~/.config -- mkdir ${HOME}/.librewolf
whitelist ${HOME}/.cache/librewolf
# Use Profiles from ~/.config -- whitelist ${HOME}/.librewolf

whitelist /usr/share/librewolf
read-only /usr/share/librewolf

# Add the next line to librewolf.local to enable private-bin.
#private-bin dbus-launch,dbus-send,librewolf,sh
private-etc librewolf

dbus-user filter
dbus-user.own io.gitlab.firefox.*
dbus-user.own io.gitlab.librewolf.*
dbus-user.own org.mozilla.librewolf.*
ignore apparmor
ignore dbus-user none

# Redirect
include firefox-common.profile
