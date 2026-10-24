#!/usr/bin/env bash
# GNOME keyboard shortcuts matching the macOS setup (Rectangle + Ghostty).
set -euo pipefail

wm=org.gnome.desktop.wm.keybindings
mutter=org.gnome.mutter.keybindings
shell=org.gnome.shell.keybindings
media=org.gnome.settings-daemon.plugins.media-keys

# Free Super+1-9 so Ghostty can use them for tmux windows
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
gsettings set $shell switch-to-application-1 "[]"
gsettings set $shell switch-to-application-2 "[]"
gsettings set $shell switch-to-application-3 "[]"
gsettings set $shell switch-to-application-4 "[]"
gsettings set $shell switch-to-application-5 "[]"
gsettings set $shell switch-to-application-6 "[]"
gsettings set $shell switch-to-application-7 "[]"
gsettings set $shell switch-to-application-8 "[]"
gsettings set $shell switch-to-application-9 "[]"

# Window tiling
gsettings set $mutter toggle-tiled-left "['<Alt><Control>h']"
gsettings set $mutter toggle-tiled-right "['<Alt><Control>l']"
gsettings set $wm toggle-maximized "['<Alt><Control>m']"

# Move window between monitors
gsettings set $wm move-to-monitor-left "['<Alt><Control><Shift>h']"
gsettings set $wm move-to-monitor-right "['<Alt><Control><Shift>l']"

# Close window (Ubuntu Dock grabs Super+Q for its number overlay by default)
gsettings set org.gnome.shell.extensions.dash-to-dock shortcut "[]"
gsettings set $wm close "['<Alt>q', '<Alt>F4']"

# Lock screen
gsettings set $media screensaver "['<Alt><Control>q']"
