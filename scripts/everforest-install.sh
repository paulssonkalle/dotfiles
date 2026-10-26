#!/usr/bin/env bash
# Install the Everforest GTK themes (dark soft and light hard) and icons. Safe to run again.
set -euo pipefail

step() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }

step "apt packages"
sudo apt install -y gtk2-engines-murrine gnome-themes-extra sassc qt6ct papirus-icon-theme git

step "Everforest GTK theme"
src="$HOME/dev/Everforest-GTK-Theme"
[ -d "$src" ] || git clone --depth 1 https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme "$src"
(cd "$src/themes" && ./install.sh -t green -c dark --tweaks soft)
(cd "$src/themes" && ./install.sh -t green -c light)

step "Installed themes"
ls -1 "$HOME/.themes" | grep -i everforest

step "Icons"
gsettings set org.gnome.desktop.interface icon-theme Papirus

step "Apply once"
"$HOME/.local/bin/everforest-follow" --once

cat <<'EOF'

Check the theme names above. If they are not Everforest-Green-Dark-Soft and
Everforest-Green-Light, set EVERFOREST_DARK_GTK and EVERFOREST_LIGHT_GTK in
~/.config/niri/everforest.kdl (see README-everforest.md).
EOF
