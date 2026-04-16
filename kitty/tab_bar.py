"""
kitty tab bar — proxySoul Coffee theme
Rounded pill-style tabs with right-aligned status cells.
"""

import datetime
import subprocess
import time

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import to_color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
)

# ── Rounded glyphs ───────────────────────────────────────────────
LEFT_ROUND = "\ue0b6"   # 
RIGHT_ROUND = "\ue0b4"  # 
SEPARATOR = "│"

# ── Coffee palette (synced with SoulForge proxysoul-coffee) ──────
AMBER = "#de7c00"
ORANGE = "#e65f2a"
GOLD = "#c8944a"
DIM = "#2e2010"
BG_PILL = "#1a1510"
TEXT = "#e7e7ee"
TEXT_MUTED = "#5c5a6e"
TEXT_SECONDARY = "#8e8ca1"

# ── Folder icons (nerd fonts) ────────────────────────────────────
FOLDER_ICONS = {
    "dotfiles": "󰝒", "config": "󰒓", "nvim": "󱘎", "desktop": "󰪥",
    "documents": "󰈙", "downloads": "󰉍", "pictures": "󰉏", "music": "󰎵",
    "projects": "", "src": "", "dev": "󰲋", "proxy": "",
    "ac-cloud": "󰊢", "fe": "󰌝", "ac-mf": "󰊣", "ai-mgmt": "󰠅",
    "be": "󰮯", "charonai-v": "󰊢", "command-center-backend": "󰮯",
    "live-view": "󰖵", "sp-ada": "", "sp-app-host": "󰊢",
    "spa-mcp-be": "󰮯", "video": "󰎞", "frontend": "󰌝", "backend": "󰮯",
    "api": "󰛢", ".zshrc": "󰘧", ".config": "󰒓", "alacritty": "󰣇",
    "ghostty": "󰣇", "kitty": "󰣇", "starship": "󰺶", "skhd": "⌨",
    "karabiner": "⌨", "sketchybar": "", "agents": "󰊢",
    "github-copilot": "󰘦",
}

# ── Subprocess cache ─────────────────────────────────────────────
_cache: dict[str, tuple[float, object]] = {}
_CACHE_TTL = 30

_timer_id = None


def _cached(key, fn):
    now = time.monotonic()
    hit = _cache.get(key)
    if hit and (now - hit[0]) < _CACHE_TTL:
        return hit[1]
    val = fn()
    _cache[key] = (now, val)
    return val


def _rgb(hex_color: str) -> int:
    return as_rgb(int(to_color(hex_color)))


def _icon_for(name: str) -> str:
    return FOLDER_ICONS.get(name.lower(), "󰉋")


def _tab_title(tab: TabBarData, max_len: int) -> str:
    """Resolve tab title from active window cwd, fallback to tab title."""
    boss = get_boss()
    if boss:
        for tm in boss.all_tab_managers:
            for t in tm.tabs:
                if t.id == tab.tab_id:
                    aw = t.active_window
                    if aw and hasattr(aw, "cwd_of_child"):
                        cwd = aw.cwd_of_child
                        if cwd:
                            parts = cwd.rstrip("/").split("/")
                            return parts[-1] or (parts[-2] if len(parts) > 1 else cwd)
    title = tab.title or ""
    if "/" in title:
        parts = title.rstrip("/").split("/")
        title = parts[-1] or (parts[-2] if len(parts) > 1 else title)
    return title[:max_len]


# ── Main draw ────────────────────────────────────────────────────
def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global _timer_id
    if _timer_id is None:
        _timer_id = add_timer(_tick, 2.0, True)

    try:
        default_bg = as_rgb(int(draw_data.default_bg))
        title = _tab_title(tab, max_title_length)
        icon = _icon_for(title)

        if tab.is_active:
            fg = _rgb("#000000")
            bg = _rgb(AMBER)
        else:
            fg = _rgb(TEXT_MUTED)
            bg = _rgb(BG_PILL)

        # spacing between tabs
        if index > 0:
            screen.cursor.bg = default_bg
            screen.draw(" ")

        # left rounded cap ─ pill fg on transparent bg
        screen.cursor.fg = bg
        screen.cursor.bg = default_bg
        screen.draw(LEFT_ROUND)

        # tab content
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(f" {icon}  {title} ")

        # right rounded cap
        screen.cursor.fg = bg
        screen.cursor.bg = default_bg
        screen.draw(RIGHT_ROUND)

        if is_last:
            _draw_status(draw_data, screen)
    except Exception:
        pass

    return screen.cursor.x


# ── Right-aligned status (rounded pill) ──────────────────────────
def _draw_status(draw_data: DrawData, screen: Screen) -> None:
    draw_attributed_string(Formatter.reset, screen)
    default_bg = as_rgb(int(draw_data.default_bg))
    pill_bg = _rgb(BG_PILL)

    cells = [c for c in [
        _cached("battery", _battery_cell),
        _date_cell(),
        _time_cell(),
    ] if c]

    if not cells:
        return

    resolved = []
    for c in cells:
        fg = _rgb(c.get("color", TEXT_SECONDARY))
        text = f"{c.get('icon', '')}{c['text']}"
        resolved.append((text, fg))

    # total width: left_cap + content + separators + right_cap
    inner = sum(len(t) + 2 for t, _ in resolved) + (len(resolved) - 1)
    total = inner + 2  # round caps

    # drop cells that don't fit
    while resolved and (screen.columns - screen.cursor.x - total) < 1:
        resolved.pop(0)
        inner = sum(len(t) + 2 for t, _ in resolved) + max(0, len(resolved) - 1)
        total = inner + 2

    if not resolved:
        return

    # push to far right
    padding = screen.columns - screen.cursor.x - total
    if padding > 0:
        screen.cursor.bg = default_bg
        screen.draw(" " * padding)

    # left round cap
    screen.cursor.fg = pill_bg
    screen.cursor.bg = default_bg
    screen.draw(LEFT_ROUND)

    # cells inside the pill
    sep_fg = _rgb(DIM)
    for i, (text, fg) in enumerate(resolved):
        if i > 0:
            screen.cursor.fg = sep_fg
            screen.cursor.bg = pill_bg
            screen.draw(SEPARATOR)
        screen.cursor.fg = fg
        screen.cursor.bg = pill_bg
        screen.draw(f" {text} ")

    # right round cap
    screen.cursor.fg = pill_bg
    screen.cursor.bg = default_bg
    screen.draw(RIGHT_ROUND)


# ── Status cells ─────────────────────────────────────────────────
def _battery_cell():
    try:
        out = subprocess.run(
            ["pmset", "-g", "batt"], capture_output=True, text=True, timeout=1
        ).stdout
        if "%" not in out:
            return None

        pct = int(out.split("\t")[1].split(";")[0].strip().replace("%", ""))
        charging = "charging" in out.lower() and "discharging" not in out.lower()

        if charging:
            return {"icon": "󰢟 ", "color": GOLD, "text": f"{pct}%"}
        if pct >= 80:
            return {"icon": "󰢞 ", "color": GOLD, "text": f"{pct}%"}
        if pct >= 60:
            return {"icon": "󰢝 ", "color": AMBER, "text": f"{pct}%"}
        if pct >= 40:
            return {"icon": "󰢜 ", "color": AMBER, "text": f"{pct}%"}
        if pct >= 20:
            return {"icon": "󰢗 ", "color": ORANGE, "text": f"{pct}%"}
        return {"icon": "󰢘 ", "color": ORANGE, "text": f"{pct}%"}
    except Exception:
        return None


def _time_cell():
    now = datetime.datetime.now().strftime("%I:%M %p")
    return {"icon": "󰥔 ", "color": AMBER, "text": now}


def _date_cell():
    today = datetime.date.today()
    label = today.strftime("%a %b %d").upper()
    color = GOLD if today.weekday() >= 5 else TEXT_SECONDARY
    icon = "󰧓 " if today.weekday() >= 5 else "󰃵 "
    return {"icon": icon, "color": color, "text": label}


def _tick(timer_id):
    for tm in get_boss().all_tab_managers:
        tm.mark_tab_bar_dirty()
