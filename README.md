<h1 align="center">ProxySoul dotfiles</h1>

<p align="center">
Neovim, Kitty, Ghostty, and macOS tiling. Symlinked into <code>~/.config</code>,
so the repo is the live config.
</p>

## Install

```sh
git clone https://github.com/proxysoul/PouiiT-Files ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

Installs the dependencies and links `nvim kitty ghostty alacritty yabai skhd borders
karabiner` into `~/.config`. Safe to run twice. Needs Neovim 0.11+, Node 18+, a Nerd Font,
and `jq`.

## What's here

| Path | What it is |
| --- | --- |
| `nvim/` | LazyVim, kanagawa wave, blink.cmp, biome, oil, snacks |
| `kitty/` | FiraCode Nerd Font, proxySoul theme pack, custom tab bar |
| `ghostty/` | JetBrains Mono, kanagawa-wave, cmd-based splits |
| `alacritty/` | Second terminal, gruvbox |
| `yabai/` `skhd/` `borders/` | bsp tiling, hotkeys, gradient borders |
| `karabiner/` `autohotkey/` | CapsLock as Esc when tapped, Ctrl when held |
| `wallies/` | Wallpapers |

## Notes

Kitty's theme is the last line of `kitty/kitty.conf`. Swap
`include proxysoul-undertow.conf` for any other file in `kitty/` to change it.

Copilot and CodeCompanion only load when Neovim starts in `~/.config` or `~/dotfiles`.
Add more directories with `NVIM_AI_ALLOWED_PATHS="$HOME/dev,$HOME/projects"`.

Custom keymaps live in `nvim/lua/config/keymaps.lua`, window hotkeys in `skhd/skhdrc`.
