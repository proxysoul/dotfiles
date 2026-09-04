#!/usr/bin/env bash
# Symlink this repo's configs into ~/.config (plus install deps on macOS/Debian).
# Safe to re-run: existing symlinks are replaced, real directories are left alone.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Directories linked into ~/.config. Everything else in the repo is reference material.
LINKS=(nvim kitty ghostty alacritty yabai skhd borders karabiner)

section() { printf '\n\033[1;34m== %s ==\033[0m\n' "$1"; }

section "Installing dependencies"
case "$OSTYPE" in
darwin*)
  if ! command -v brew >/dev/null; then
    echo "Homebrew is required: https://brew.sh" >&2
    exit 1
  fi
  brew install neovim node ripgrep fd fzf lazygit jq
  brew install --cask kitty ghostty font-fira-code-nerd-font font-jetbrains-mono-nerd-font
  brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
  ;;
linux-gnu*)
  sudo apt update
  sudo apt install -y neovim nodejs npm ripgrep fd-find fzf jq git curl
  echo "Install a Nerd Font manually: https://www.nerdfonts.com/font-downloads"
  echo "yabai/skhd/karabiner are macOS-only and will be skipped."
  ;;
*)
  echo "Unsupported OS — install dependencies manually." >&2
  ;;
esac

section "Linking configs into $CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
for name in "${LINKS[@]}"; do
  src="$REPO_ROOT/$name"
  dest="$CONFIG_DIR/$name"
  [ -d "$src" ] || continue
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip $name — $dest exists and is not a symlink"
    continue
  fi
  ln -sfn "$src" "$dest"
  echo "link $name -> $dest"
done

section "Done"
cat <<'MSG'
Neovim plugins install on first launch; run :Mason for LSPs and formatters.
Kitty expects FiraCode Nerd Font, Ghostty/Alacritty expect JetBrains Mono.
Optional: export NVIM_AI_ALLOWED_PATHS="$HOME/dev,$HOME/projects" to widen where
Copilot/CodeCompanion load (see nvim/lua/plugins/ai.lua).
MSG
