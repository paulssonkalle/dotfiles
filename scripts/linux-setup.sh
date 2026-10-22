#!/usr/bin/env bash
# Set up a fresh Ubuntu machine with these dotfiles. Safe to run again.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$HOME/.local/bin"
mkdir -p "$BIN"
export PATH="$BIN:$HOME/go/bin:$PATH"

step() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

step "apt packages"
sudo apt update
sudo apt install -y \
  zsh tmux stow git curl unzip \
  fd-find zoxide lazygit zsh-syntax-highlighting wl-clipboard \
  gnome-shell-extension-manager \
  build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libffi-dev liblzma-dev tk-dev

step "fd symlink"
[ -e "$BIN/fd" ] || ln -s "$(command -v fdfind)" "$BIN/fd"

step "Neovim"
if [ ! -x /opt/nvim-linux-x86_64/bin/nvim ]; then
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/nvim.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
  rm -rf "$tmp"
fi

step "Stow dotfiles"
cd "$DOTFILES"
for pkg in */; do
  pkg=${pkg%/}
  [ "$pkg" = scripts ] && continue
  stow --restow "$pkg" || echo "  stow failed for $pkg (conflicting files in \$HOME?)"
done

step "mise"
has mise || curl -fsSL https://mise.run | sh
mise install
eval "$(mise activate bash)"

step "oh-my-posh"
has oh-my-posh || curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN"

step "Go tools"
if ! has worktree; then
  src="$HOME/dev/worktree"
  [ -d "$src" ] || git clone https://github.com/paulssonkalle/worktree "$src"
  (cd "$src" && go install .)
fi

step "zsh plugins"
[ -d "$HOME/.zsh/plugins/fzf-tab" ] ||
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh/plugins/fzf-tab"

step "tmux plugins"
tpm="$HOME/.config/tmux/plugins/tpm"
[ -d "$tpm" ] || git clone https://github.com/tmux-plugins/tpm "$tpm"
tmux new-session -d -s _setup 2>/dev/null || true
"$tpm/bin/install_plugins" || echo "  run prefix + I inside tmux to install plugins"
tmux kill-session -t _setup 2>/dev/null || true

step "Zed Mono font"
fonts="$HOME/.local/share/fonts/zed-mono"
if ! fc-list | grep -qi "zed mono"; then
  url=$(curl -fsSL https://api.github.com/repos/zed-industries/zed-fonts/releases/latest |
    grep -o 'https://[^"]*zed-mono-[^"]*\.zip' | head -1)
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/zed-mono.zip" "$url"
  mkdir -p "$fonts"
  unzip -oq "$tmp/zed-mono.zip" -d "$fonts"
  rm -rf "$tmp"
  fc-cache -f
fi

step "GNOME shortcuts"
has gsettings && "$DOTFILES/scripts/gnome-setup.sh"

step "Default shell"
zsh_path=$(command -v zsh)
[ "$(getent passwd "$USER" | cut -d: -f7)" = "$zsh_path" ] || chsh -s "$zsh_path"

cat <<'EOF'

Done. Manual steps left:
  - Install Ghostty
  - Install the "Run or Raise" extension with Extension Manager
  - Log out and back in so zsh becomes your shell
EOF
