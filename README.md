# dotfiles

macOS-first configs for Neovim, terminals, and window management. Everything here is
symlinked into `~/.config`, so the repo and the live config are the same files.

| Path | What it is |
| --- | --- |
| `nvim/` | Neovim, [LazyVim](https://lazyvim.org) base + custom plugins |
| `kitty/` | Kitty terminal, theme pack, custom tab bar |
| `ghostty/` | Ghostty terminal + `kanagawa-wave` theme |
| `alacritty/` | Alacritty (secondary terminal, gruvbox) |
| `yabai/`, `skhd/`, `borders/` | macOS tiling WM, hotkeys, window borders |
| `karabiner/` | CapsLock → Esc / Ctrl remap |
| `autohotkey/` | Same CapsLock remap for Windows |
| `wallies/` | Wallpapers |

## Install

```sh
git clone https://github.com/proxysoul/PouiiT-Files ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` installs dependencies (Homebrew on macOS, apt on Debian/Ubuntu) and links
`nvim kitty ghostty alacritty yabai skhd borders karabiner` into `~/.config`. It never
overwrites a real directory — only symlinks. To link a single config by hand:

```sh
ln -sfn ~/dotfiles/nvim ~/.config/nvim
```

Requirements: Neovim 0.11+, Node 18+, a Nerd Font, and `jq` for the skhd float/center
binding. Optional but assumed by the pickers: `ripgrep`, `fd`, `fzf`, `lazygit`.

## Neovim

LazyVim with the `typescript`, `json`, `yanky`, `illuminate`, `inc-rename`,
`mini-animate`, `treesitter-context`, `dot` and `mini-hipatterns` extras.

- **Colorscheme** — kanagawa (wave), transparent background (`lua/plugins/kanagawa.lua`).
  catppuccin and NeoSolarized are installed but not active.
- **Completion** — blink.cmp with a Copilot source, blink.pairs.
- **Formatting** — conform.nvim: biome for JS/TS/JSON/CSS/YAML/GraphQL/HTML/Markdown,
  stylua for Lua.
- **TypeScript** — typescript-tools.nvim.
- **UI** — snacks, noice, lualine (with Copilot status), incline, quicker, helpview,
  render-markdown, ufo folding, sunglasses (dim inactive windows).
- **Navigation** — flash, oil.nvim as the file explorer, goto-preview, numb, hbac,
  multicursors, mini.move.
- **Other** — codesnap, ecolog (env files), toggleterm, focus, sidekick, Discord presence.
- bufferline is disabled on purpose (`lua/plugins/disabled.lua`).

### Keymaps

Only what this config adds on top of LazyVim defaults — the source of truth is
`nvim/lua/config/keymaps.lua`.

| Key | Action |
| --- | --- |
| `<C-b>` | Buffer picker (Snacks) |
| `<C-k>` | Close buffer |
| `<C-o>` | Toggle Oil file explorer |
| `<leader>sa` | All Snacks pickers |
| `<leader>sf` | Terminal selector |
| `<C-x>` | Diagnostic float |
| `<C-f>` | Code actions |
| `<C-h>` | Hover docs |
| `<C-j>` | Signature help |
| `<C-,>` / `<C-m>` | Next / previous diagnostic |
| `<C-vr>` | LSP rename |
| `<C-a>` | Select all |
| `<C-e>` / `<C-i>` (insert) | Jump to end / start of line |
| `<C-'>` `<C-ö>` `<C-ä>` `<C-å>` | Resize window (Swedish layout) |
| `<C-n>` (insert) | Next Copilot suggestion |
| `<C-y>` | Accept Copilot / NES suggestion |
| `<leader>ca` / `<leader>cA` | CodeCompanion chat / actions |

### AI gating

Copilot and CodeCompanion only load when Neovim starts inside an allowed directory.
Allowed by default: `~/.config` and `~/dotfiles`. Extend with a comma-separated list:

```sh
export NVIM_AI_ALLOWED_PATHS="$HOME/dev,$HOME/projects"
```

The check runs once at startup — `cd` into a project before launching. Logic lives at
the top of `nvim/lua/plugins/ai.lua`.

## Kitty

FiraCode Nerd Font 13, 92% opacity, block cursor, custom Python tab bar
(`kitty/tab_bar.py`) that reads its pills from whichever theme is included.

- Active theme: `include proxysoul-undertow.conf` at the bottom of `kitty/kitty.conf` —
  swap that one line for any other `kitty/*.conf` (proxysoul main/crimson/water/empryo,
  coffee, kanagawa, gruvbox, tokyonight, catppuccin, neosolarized).
- Layouts: `horizontal` (equal columns), `splits`, `stack`.
- `F6` new window in the same cwd, `F7` nested vertical split,
  `ctrl+alt+<arrow>` to move between panes.

## Ghostty

JetBrains Mono 16, `kanagawa-wave` (bundled in `ghostty/themes/`), quick terminal on
`cmd+\``. Splits: `cmd+d` right, `cmd+shift+d` down, `cmd+hjkl` to navigate,
`cmd+shift+hjkl` to resize, `cmd+shift+z` to zoom.

## Window management (macOS)

`yabai` in bsp layout with 10px gaps; System Settings, Calculator, Karabiner, Arc and
Finder are unmanaged. `borders/bordersrc` holds a gradient border config (the invocation
is commented out — uncomment it to use [JankyBorders](https://github.com/FelixKratz/JankyBorders)).

skhd bindings (`skhd/skhdrc`), alt = ⌥:

| Key | Action |
| --- | --- |
| `alt - h/j/k/l` | Focus window west/south/north/east |
| `shift + alt - h/j/k/l` | Swap window |
| `ctrl + alt - h/j/k/l` | Warp window |
| `alt - s` / `alt - g` | Focus display west / east |
| `shift + alt - s` / `shift + alt - g` | Move window to display west / east |
| `alt - r` / `shift + alt - r` | Rotate space 90° / 270° |
| `shift + alt - x` / `shift + alt - y` | Mirror space |
| `shift + alt - e` | Balance windows |
| `lalt - space` | Toggle float |
| `lalt - f` / `shift + lalt - f` | Zoom parent / fullscreen |
| `shift + cmd - 1…0` | Send window to space and follow |
| `ctrl + alt - q/s/r` | Stop / start / restart yabai |

Some yabai signals call `sketchybar`; they're harmless no-ops if sketchybar isn't installed.

## CapsLock remap

- macOS — [Karabiner Elements](https://karabiner-elements.pqrs.org/) with
  `karabiner/karabiner.json`: CapsLock alone → Esc, held → Ctrl, with Shift → CapsLock.
- Windows — `autohotkey/nvim_bindings.ahk` does the same (AutoHotkey v2).
