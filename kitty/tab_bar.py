# kitty lualine-style tab bar — neosolarized theme

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

timer_id = None
_prev_tab_bg = None

# powerline arrows
RIGHT_ARROW = "\ue0b0"  # 
LEFT_ARROW = "\ue0b2"   # 
# thin lualine-style separators (for same-bg segments)
THIN_LEFT = "\ue0b3"    # 

# cache for expensive subprocess calls
_cache = {}
_CACHE_TTL = 15  # seconds


def _cached_call(key, fn):
    now = time.monotonic()
    entry = _cache.get(key)
    if entry and (now - entry[0]) < _CACHE_TTL:
        return entry[1]
    result = fn()
    _cache[key] = (now, result)
    return result


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
    global timer_id, _prev_tab_bg
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, 2.0, True)

    try:
        default_bg = as_rgb(int(draw_data.default_bg))

        # get cwd from the active window, fall back to tab title
        title = ""
        boss = get_boss()
        if boss:
            for tm in boss.all_tab_managers:
                for t in tm.tabs:
                    if t.id == tab.tab_id:
                        aw = t.active_window
                        if aw and hasattr(aw, 'cwd_of_child'):
                            title = aw.cwd_of_child or ""
                        break

        if not title:
            title = tab.title[:max_title_length] if tab.title else ""

        # extract just the folder name
        if "/" in title:
            parts = title.rstrip("/").split("/")
            title = parts[-1] if parts[-1] else parts[-2] if len(parts) > 1 else title
        title = title.upper()

        if tab.is_active:
            fg = as_rgb(int(draw_data.active_fg))
            bg = as_rgb(int(draw_data.active_bg))
        else:
            fg = as_rgb(int(draw_data.inactive_fg))
            bg = as_rgb(int(draw_data.inactive_bg))

        # bridging arrow between tabs
        if index > 0 and _prev_tab_bg is not None:
            screen.cursor.fg = _prev_tab_bg
            screen.cursor.bg = bg
            screen.draw(RIGHT_ARROW)

        # tab text
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(f" {title} ")

        _prev_tab_bg = bg

        # closing arrow after last tab + right status
        if is_last:
            screen.cursor.fg = bg
            screen.cursor.bg = default_bg
            screen.draw(RIGHT_ARROW)
            try:
                draw_right_status(draw_data, screen)
            except Exception:
                pass
    except Exception:
        pass

    return screen.cursor.x


def draw_right_status(draw_data: DrawData, screen: Screen) -> None:
    draw_attributed_string(Formatter.reset, screen)

    default_bg = as_rgb(int(draw_data.default_bg))

    cells = create_cells()
    if not cells:
        return

    # resolve colors for each cell
    resolved = []
    for c in cells:
        try:
            fg_rgb = as_rgb(int(to_color(c.get("color", "#586e75"))))
        except Exception:
            fg_rgb = as_rgb(int(draw_data.inactive_fg))
        try:
            bg_rgb = as_rgb(int(to_color(c.get("bg", "#002b36"))))
        except Exception:
            bg_rgb = as_rgb(int(draw_data.inactive_bg))
        text = f"{(c.get('icon') or '')}{c['text']}"
        resolved.append((text, fg_rgb, bg_rgb))

    # width calc: first segment = arrow(1) + space + text + space
    # same-bg segments use thin sep(1) instead of arrow
    # different-bg segments use arrow(1)
    total = 0
    for i, (t, _, bg) in enumerate(resolved):
        total += len(t) + 3  # sep/arrow + space + text + space

    # drop leftmost cells if not enough room
    while resolved:
        padding = screen.columns - screen.cursor.x - total
        if padding >= 0:
            break
        dropped = resolved.pop(0)
        total -= (len(dropped[0]) + 3)

    if not resolved:
        return

    # push to far right
    padding = screen.columns - screen.cursor.x - total
    if padding > 0:
        screen.draw(" " * padding)

    # draw connected right-side segments
    sep_color = as_rgb(int(to_color("#465a61")))  # muted separator color
    for i, (text, fg_rgb, bg_rgb) in enumerate(resolved):
        if i == 0:
            # first: powerline arrow from default bg
            screen.cursor.fg = bg_rgb
            screen.cursor.bg = default_bg
            screen.draw(LEFT_ARROW)
        else:
            prev_bg = resolved[i - 1][2]
            if prev_bg == bg_rgb:
                # same bg: thin separator
                screen.cursor.fg = sep_color
                screen.cursor.bg = bg_rgb
                screen.draw(THIN_LEFT)
            else:
                # different bg: powerline arrow
                screen.cursor.fg = bg_rgb
                screen.cursor.bg = prev_bg
                screen.draw(LEFT_ARROW)

        screen.cursor.fg = fg_rgb
        screen.cursor.bg = bg_rgb
        screen.draw(f" {text} ")


def create_cells():
    return [c for c in [
        _cached_call("spotify", _get_spotify),
        _cached_call("battery", _get_battery),
        get_date(),
        get_time(),
    ] if c is not None]


def _get_spotify():
    try:
        script = '''
        tell application "System Events"
            if not (exists process "Spotify") then return "NOT_RUNNING"
        end tell
        tell application "Spotify"
            if player state is not playing then return "NOT_PLAYING"
            return (artist of current track) & " - " & (name of current track)
        end tell
        '''
        result = subprocess.run(
            ["osascript", "-e", script],
            capture_output=True, text=True, timeout=2
        )
        song = result.stdout.strip()
        if song in ("NOT_RUNNING", "NOT_PLAYING") or not song:
            return None
        if len(song) > 40:
            song = song[:37] + "..."
        return {"icon": "󰎆 ", "color": "#859900", "bg": "#002b36", "text": song}
    except Exception:
        return None


def _get_battery():
    try:
        result = subprocess.run(
            ["pmset", "-g", "batt"],
            capture_output=True, text=True, timeout=1
        )
        output = result.stdout
        if "%" not in output:
            return None

        percent_str = output.split("\t")[1].split(";")[0].strip()
        percent = int(percent_str.replace("%", ""))

        charging = ("charging" in output.lower() or "charged" in output.lower()) and "discharging" not in output.lower()
        if charging:
            icon = "󰂄 "
            color = "#859900"
        elif percent >= 80:
            icon = "󰁹 "
            color = "#859900"
        elif percent >= 60:
            icon = "󰂀 "
            color = "#2aa198"
        elif percent >= 40:
            icon = "󰁾 "
            color = "#b58900"
        elif percent >= 20:
            icon = "󰁼 "
            color = "#cb4b16"
        else:
            icon = "󰁺 "
            color = "#dc322f"

        return {"icon": icon, "color": color, "bg": "#002b36", "text": f"{percent}%"}
    except Exception:
        return None


def get_time():
    now = datetime.datetime.now().strftime("%I:%M %p")
    return {"icon": " ", "color": "#268bd2", "bg": "#073642", "text": now}


def get_date():
    today = datetime.date.today()
    day_str = today.strftime("%b %e").upper()
    if today.weekday() < 5:
        return {"icon": "󰃵 ", "color": "#586e75", "bg": "#002b36", "text": day_str}
    else:
        return {"icon": "󰧓 ", "color": "#6c71c4", "bg": "#002b36", "text": day_str}


def _redraw_tab_bar(timer_id):
    for tm in get_boss().all_tab_managers:
        tm.mark_tab_bar_dirty()
