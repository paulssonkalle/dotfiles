#!/usr/bin/env bash
# Update zsh and tmux plugins.
set -uo pipefail

for dir in "$HOME"/.zsh/plugins/*/; do
  [ -d "$dir/.git" ] || continue
  echo "Updating $(basename "$dir")"
  git -C "$dir" pull --ff-only --quiet || echo "  failed: $dir"
done

tpm="$HOME/.config/tmux/plugins/tpm/bin/update_plugins"
if [ -x "$tpm" ] && tmux info >/dev/null 2>&1; then
  echo "Updating tmux plugins"
  "$tpm" all
fi
