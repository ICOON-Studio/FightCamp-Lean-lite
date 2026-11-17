"""ONELOOK1 (S496): put every loose colour in the screen scripts on the one palette (scripts/ui/Palette.gd).

Each literal colour (Color("#hex"), Color(r, g, b[, a]), Color.WHITE/BLACK/...) becomes the NEAREST Palette name by eye
(CIE Lab distance), keeping its see-through amount: Color(Palette.X, a). A white used as a modulate/tint multiplier becomes
Palette.FULL (no tint), never a drawn colour. Lines the guard exempts (3D materials) and the files it exempts are left.
The files other seats own (fight HUD bars, fight motion) are skipped.

  python tools/palette_sweep.py            # dry run: per file, how many colours move and the biggest jumps
  python tools/palette_sweep.py --write    # rewrite the files
  add --training to include the Training tab files (S512)
"""
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DIRS = [ROOT / "scripts/ui", ROOT / "scripts/fight3d"]
SKIP = {
    "Palette.gd", "IsoGym.gd",                        # the palette itself; the guard's exempt 3D gym
    "HudBars.gd", "HudRegroup.gd",                    # Qwen ONELOOK2 owns them
    "FightStage.gd", "PunchReach.gd", "ReachLimit.gd", "JoinSmoother.gd", "HitSnap.gd", "BeatClips.gd", "BeatFire.gd",
}
## Depiction, not screen chrome: the 3D ring, its lights and people, cuts and bruises on a face. The guard exempts them too.
DEPICTION = {"RingSet.gd", "MHRig.gd", "MovePlayer.gd", "MoveStudio.gd", "Referee.gd", "CornerCrew.gd", "FaceMarks.gd",
             "FaceFill.gd", "PadWork.gd"}
SKIP |= DEPICTION
## The Training tab and Training K screen files: the main session rebuilds them (S496, Training K v6c) - restyled after.
TRAINING = {"WeekCards.gd", "WeekBoard.gd", "WeekCamp.gd", "WeekDay.gd", "WeekEditors.gd", "WeekStrip.gd", "WeekTiles.gd",
            "WeekTired.gd", "WeekPops.gd", "WeekReadRows.gd", "DrillCard.gd", "DrillTray.gd"}
SKIP |= TRAINING
## S512: the Training rebuild never came; those screens are live off the palette. `--training` sweeps them too.
if "--training" in sys.argv:
    SKIP -= TRAINING
EXEMPT_TEXT = ("StandardMaterial3D", "ShaderMaterial", "ORMMaterial3D", "albedo", "emission", "Light3D", "light_color")
PRELOAD = 'const Palette := preload("res://scripts/ui/Palette.gd")'

TOKENS = {
    "PAGE": "#1a1512", "CARD": "#2e3234", "TILE": "#414342", "HOVER": "#2b241d", "WOOD": "#4c362a", "LINE": "#4c4b45",
    "TEXT": "#eee2ce", "MUTED": "#b1a084", "HEADER": "#e6bd55", "ACCENT": "#6fa0e6", "GOOD": "#2cb56f", "BAD": "#ff7a66",
    "WARN": "#cf9245", "ACTION": "#991d1c", "SECOND": "#442f24", "CHOSEN": "#c8a585", "GOOD_FILL": "#239058",
    "BAD_FILL": "#df4639", "ELITE": "#b08eea",
}
NAMED = {"WHITE": (1, 1, 1), "BLACK": (0, 0, 0), "RED": (1, 0, 0), "GREEN": (0, 1, 0), "BLUE": (0, 0, 1),
         "YELLOW": (1, 1, 0), "GRAY": (0.75, 0.75, 0.75), "GREY": (0.75, 0.75, 0.75), "ORANGE": (1, 0.65, 0),
         "PURPLE": (0.63, 0.13, 0.94)}
MULTIPLIER_HINTS = ("modulate", "tint", "self_modulate", "modulate_color", "_mul", "MUL")


def hex_rgb(h: str):
    h = h.lstrip("#")
    if len(h) in (3, 4):
        h = "".join(c * 2 for c in h)
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
    a = int(h[6:8], 16) / 255 if len(h) == 8 else 1.0
    return (r, g, b), a


def lab(rgb):
    def lin(c):
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (lin(max(0.0, min(1.0, c))) for c in rgb)
    x = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047
    y = 0.2126 * r + 0.7152 * g + 0.0722 * b
    z = (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883

    def f(t):
        return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116
    return (116 * f(y) - 16, 500 * (f(x) - f(y)), 200 * (f(y) - f(z)))


TOKEN_LAB = {k: lab(hex_rgb(v)[0]) for k, v in TOKENS.items()}


def nearest(rgb):
    l = lab(rgb)
    def d(k):   # by hue first (LCh): a strong blue stays the blue, never the purple top band; lightness and strength count less
        t = TOKEN_LAB[k]
        c1, c2 = math.hypot(l[1], l[2]), math.hypot(t[1], t[2])
        dh2 = max(0.0, (l[1] - t[1]) ** 2 + (l[2] - t[2]) ** 2 - (c1 - c2) ** 2)
        return math.sqrt(((l[0] - t[0]) * 0.35) ** 2 + ((c1 - c2) * 0.45) ** 2 + dh2)
    pool = TOKEN_LAB
    if math.hypot(l[1], l[2]) < 10:   # a grey stays a grey: only the plain tokens
        pool = {k: v for k, v in TOKEN_LAB.items() if math.hypot(v[1], v[2]) < 18}
    best = min(pool, key=d)
    return best, d(best)


def fmt_a(a: float) -> str:
    s = ("%.3f" % a).rstrip("0").rstrip(".")
    return s if "." in s else s + ".0"


PAPER = {"PAPER_INK": "#241f1a", "PAPER_MUTED": "#5d5243", "PAPER_BLUE": "#27589e"}   # light-plate inks: exact only


def token(rgb, alpha_expr, multiplier: bool):
    paper = [k for k, v in PAPER.items() if max(abs(a - b) for a, b in zip(hex_rgb(v)[0], rgb)) < 0.003]
    if paper:
        name, dist = paper[0], 0.0
    elif multiplier and min(rgb) > 0.95:
        name, dist = "FULL", 0.0
    else:
        name, dist = nearest(rgb)
    ref = "Palette." + name
    if alpha_expr is None:
        return ref, name, dist
    return "Color(%s, %s)" % (ref, alpha_expr), name, dist


NUM = r"-?\d+(?:\.\d+)?|-?\.\d+"
RE_HEX = re.compile(r'Color\(\s*"#?([0-9a-fA-F]{3,8})"\s*(?:,\s*([^()]+?))?\s*\)')
RE_NUM = re.compile(r"Color\(\s*(%s)\s*,\s*(%s)\s*,\s*(%s)\s*(?:,\s*([^()]*(?:\([^()]*\))?[^()]*?))?\s*\)" % (NUM, NUM, NUM))
RE_NAMED = re.compile(r"Color\.(WHITE|BLACK|RED|GREEN|BLUE|YELLOW|GRAY|GREY|ORANGE|PURPLE)\b")


def split_comment(line: str):
    in_str = False
    for i, ch in enumerate(line):
        if ch == '"':
            in_str = not in_str
        elif ch == "#" and not in_str:
            return line[:i], line[i:]
    return line, ""


def sweep_line(line: str, log: list):
    if line.strip().startswith("#") or any(t in line for t in EXEMPT_TEXT):
        return line
    code, comment = split_comment(line)
    mult = any(h in code for h in MULTIPLIER_HINTS)

    def on_hex(m):
        rgb, a = hex_rgb(m.group(1))
        alpha = m.group(2).strip() if m.group(2) else (fmt_a(a) if a < 1.0 else None)
        out, name, dist = token(rgb, alpha, mult)
        log.append((m.group(0), out, dist))
        return out

    def on_num(m):
        rgb = tuple(float(m.group(i)) for i in (1, 2, 3))
        if max(rgb) > 1.0 or min(rgb) < 0.0:   # an HDR glow or a sentinel (-1): not a screen colour, leave it
            return m.group(0)
        a = m.group(4).strip() if m.group(4) else None
        if a is not None and re.fullmatch(NUM, a) and float(a) == 1.0:
            a = None
        out, name, dist = token(rgb, a, mult)
        log.append((m.group(0), out, dist))
        return out

    def on_named(m):
        out, name, dist = token(NAMED[m.group(1)], None, mult)
        log.append((m.group(0), out, dist))
        return out

    new = RE_HEX.sub(on_hex, code)
    new = RE_NUM.sub(on_num, new)
    new = RE_NAMED.sub(on_named, new)
    return new + comment


def add_preload(lines: list) -> list:
    text = "".join(lines)
    if re.search(r"^const Palette\s*:?=", text, re.M):
        return lines
    i = 0
    while i < len(lines) and (lines[i].startswith(("extends", "class_name", "@tool", "##")) or not lines[i].strip()):
        if not lines[i].strip() and i > 0 and not lines[i - 1].startswith("##") and not lines[i - 1].startswith(("extends", "class_name", "@tool")):
            break
        i += 1
    return lines[:i] + [PRELOAD + "\n"] + lines[i:]


def main():
    write = "--write" in sys.argv
    total = 0
    worst = []
    for d in DIRS:
        for p in sorted(d.rglob("*.gd")):
            if p.name in SKIP:
                continue
            src = p.read_text(encoding="utf-8").replace("﻿", "").splitlines(keepends=True)   # a BOM hid `extends`
            log = []
            out = [sweep_line(l, log) for l in src]
            if not log:
                continue
            total += len(log)
            worst += [(dist, p.name, a, b) for a, b, dist in log]
            print("%-28s %3d" % (p.relative_to(ROOT).as_posix()[8:], len(log)))
            if write:
                p.write_text("".join(add_preload(out)), encoding="utf-8", newline="\n")
    print("TOTAL", total)
    worst.sort(reverse=True)
    print("BIGGEST JUMPS (Lab distance):")
    for dist, name, a, b in worst[:25]:
        print("  %5.1f %-22s %s -> %s" % (dist, name, a, b))


if __name__ == "__main__":
    main()
