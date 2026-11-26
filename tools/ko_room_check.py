"""KDPIC1 (S566): the pixel test of the knockdown runs. For each <run>_<k> of a render dir's frames.json that has a "room"
row (tools/pics2d_anim_more.gd _punch_ko_run), the fallen man's pixels on ko_masks/<run>_<k>_mask.png (tools/pics2d_mask.gd
PART colours of his corner) are tested against the ring inside the ropes as the picture sees it (room.ring_px: the four
corners on the canvas and at the top rope, their hull) AND against the page's stage window (order.html .stage at
1920x1080: room.win_half_px either side of the picture's middle, and the middle 1/1.26 of its height - the picture is drawn
126% of the stage high, 17% above it). Twice: where he is drawn, and slid back room.back_m (the page's
furthest-back spot, ring_ui.js: two steps behind Long) for the ropes; the stage window from his own spot only (from the ropes
spot the page draws even the standing man at the stage's edge: tools/pics2d_ko_room.gd WIN_BACK_M).
    python tools/ko_room_check.py <render_dir> [run ...] [--back=<m>]   (--back: the control - slide him further back than
                                                                         the page can; the test must then count pixels out)
Prints one line per run: OUT px at his spot / at the back spot, and the frame with the most; exit 1 if any pixel is out."""
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw

PART = {"blue": [(255, 0, 0), (0, 255, 0), (0, 0, 255), (255, 255, 0), (0, 128, 255)],
        "red": [(255, 0, 255), (0, 255, 255), (255, 128, 0), (128, 0, 255), (255, 0, 128)]}


def hull(pts):
    pts = sorted(set(map(tuple, pts)))
    def cross(o, a, b):
        return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
    lo, hi = [], []
    for p in pts:
        while len(lo) >= 2 and cross(lo[-2], lo[-1], p) <= 0:
            lo.pop()
        lo.append(p)
    for p in reversed(pts):
        while len(hi) >= 2 and cross(hi[-2], hi[-1], p) <= 0:
            hi.pop()
        hi.append(p)
    return lo[:-1] + hi[:-1]


def reach_px(mask, cols, side):
    """how far out (px, on the fall's side: side = +1 right, -1 left) his pixels reach on a mask"""
    xs = [i % mask.size[0] for i, p in enumerate(mask.get_flattened_data() if hasattr(mask, "get_flattened_data") else mask.getdata()) if p[3] >= 128 and p[:3] in cols]
    return (max(xs) if side > 0 else -min(xs)) if xs else -1e9


def out_count(mask, cols, poly, dx, dy, win=None, side=1, own=-1e9):
    w, h = mask.size
    inside = Image.new("L", (w, h), 0)
    ImageDraw.Draw(inside).polygon([(x - dx, y - dy) for x, y in poly], fill=255)   # the man slid by (dx, dy) = the ring the other way
    if win:   # the stage window is fixed on the page too: slid the other way, and only what is inside both counts as in
        box = Image.new("L", (w, h), 0)
        lo, hi = w / 2 - win - dx, w / 2 + win - dx
        if side > 0:   # where his standing body already reaches on the contact picture is not the fall's doing
            hi = max(hi, own + 0.5)
        else:
            lo = min(lo, -own - 0.5)
        ImageDraw.Draw(box).rectangle([lo, h * 0.17 / 1.26, hi, h * 1.17 / 1.26], fill=255)
        inside = Image.fromarray(__import__("numpy").minimum(__import__("numpy").array(inside), __import__("numpy").array(box)))
    m, ins = mask.load(), inside.load()
    n = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = m[x, y]
            if a >= 128 and (r, g, b) in cols and ins[x, y] == 0:
                n += 1
    return n


def main():
    d = Path(sys.argv[1])
    runs = json.load(open(d / "frames.json"))["runs"]
    back_m = next((float(a.split("=")[1]) for a in sys.argv[2:] if a.startswith("--back=")), None)
    want = [a for a in sys.argv[2:] if not a.startswith("--")] or [k for k, v in runs.items() if "room" in v]
    bad = 0
    for run in want:
        row = runs[run]
        room = row["room"]
        cols = set(PART[room["fallen"]])
        poly = hull(room["ring_px"])
        bm = room["back_m"] if back_m is None else back_m
        bx, by = room["metre_px"][0] * bm, room["metre_px"][1] * bm
        side = 1 if room["metre_px"][0] > 0 else -1
        own = reach_px(Image.open(d / "ko_masks" / row["files"][0].replace(".png", "_mask.png")).convert("RGBA"), cols, side)
        at, back = [], []
        for f in row["files"]:
            mk = Image.open(d / "ko_masks" / f.replace(".png", "_mask.png")).convert("RGBA")
            win = room.get("win_half_px")
            at.append(out_count(mk, cols, poly, 0, 0, win, side, own))
            back.append(out_count(mk, cols, poly, bx, by))
        bad += (max(at) > 0) + (max(back) > 0)
        print("KO_ROOM %s: turned %s deg, cut %.0f%%, out px at his spot (ropes + stage) %d (frame %d), at %.2f m back (ropes) %d (frame %d) %s" % (
            run, room.get("turn_deg", "-"), 100 * room.get("cut", 0), max(at), at.index(max(at)), bm, max(back), back.index(max(back)),
            "PASS" if max(at) + max(back) == 0 else "FAIL"))
    sys.exit(1 if bad else 0)


main()
