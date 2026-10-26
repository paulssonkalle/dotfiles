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

step "Spicetify + Comfy for Spotify"
if dpkg -s spotify-client >/dev/null 2>&1; then
  spice="$HOME/.spicetify"
  if [ ! -x "$spice/spicetify" ]; then
    # Download the release directly, the official install script appends to ~/.zshrc
    tag=$(curl -fsSL https://api.github.com/repos/spicetify/cli/releases/latest | grep -o '"tag_name": *"v[^"]*"' | grep -o '[0-9][^"]*')
    mkdir -p "$spice"
    curl -fsSL "https://github.com/spicetify/cli/releases/download/v$tag/spicetify-$tag-linux-amd64.tar.gz" | tar xz -C "$spice"
  fi
  ln -sfn "$spice/spicetify" "$HOME/.local/bin/spicetify"

  # The deb installs Spotify read-only for users, Spicetify needs to patch it
  sudo chmod a+wr /usr/share/spotify
  sudo chmod -R a+wr /usr/share/spotify/Apps

  # Spotify must have been started once so its prefs file exists
  spicetify config >/dev/null 2>&1 || true
  themes="$(dirname "$(spicetify -c)")/Themes"
  mkdir -p "$themes"
  if [ ! -d "$themes/Comfy" ]; then
    tmp=$(mktemp -d)
    git clone --depth 1 https://github.com/Comfy-Themes/Spicetify "$tmp"
    mv "$tmp/Comfy" "$themes/Comfy"
    rm -rf "$tmp"
  fi
  grep -q '^\[Everforest-dark-soft\]' "$themes/Comfy/color.ini" ||
    cat "$(dirname "$0")/everforest-spicetify.ini" >>"$themes/Comfy/color.ini"

  spicetify config current_theme Comfy color_scheme Everforest-dark-soft
  spicetify config inject_css 1 replace_colors 1 overwrite_assets 1 inject_theme_js 1
  spicetify backup apply || spicetify apply
else
  echo "  spotify-client (deb) is not installed, skipping"
fi

step "Apply once"
"$HOME/.local/bin/everforest-follow" --once

cat <<'EOF'

Check the theme names above. If they are not Everforest-Green-Dark-Soft and
Everforest-Green-Light, set EVERFOREST_DARK_GTK and EVERFOREST_LIGHT_GTK in
~/.config/niri/everforest.kdl (see README-everforest.md).
EOF
