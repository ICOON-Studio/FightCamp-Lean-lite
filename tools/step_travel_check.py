"""STEPFIX1 (S559): the step runs' picture bars, read from the frames (proto/twohands/img/anim).
For each step run: where each man stands (the middle of his shorts) and the stepping man's front toe, frame 0 and last.
Bars: the stepping man travels toward (step in) / away (back off) at least 25 px; the other man under 5 px; the last
frame within 6 px of the hold pictures of the range it ends on; the first frame within 6 px of the range it starts on.
    python tools/step_travel_check.py [dir]      exit 1 when a bar fails"""
import glob, os, sys
from PIL import Image

D = sys.argv[1] if len(sys.argv) > 1 else "proto/twohands/img/anim"
NEXT = {"step_in_r2": ("", "_r2"), "step_in_r1": ("_r2", "_r1"), "back_off_r3": ("_r2", ""), "back_off_r2": ("_r1", "_r2")}


def men(path):
    im = Image.open(path).convert("RGBA"); w, h = im.size; px = im.load()
    rs, bs, low = [], [], []
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128 or (r > 235 and g > 235 and b > 235):
                continue
            if 0.45 * h < y < 0.70 * h:
                if r > 180 and g < 60 and b < 60: rs.append(x)
                if b > 150 and r < 70 and g < 90: bs.append(x)
            if y > 0.74 * h: low.append(x)
    red, blue = sum(rs) / len(rs), sum(bs) / len(bs)
    mid = (red + blue) / 2
    return {"red": red, "blue": blue, "red_toe": max(x for x in low if x < mid), "blue_toe": min(x for x in low if x > mid)}


def frames(run):
    fs = [f for f in glob.glob(os.path.join(D, run + "_*.webp")) if os.path.basename(f)[len(run) + 1:-5].isdigit()]
    return sorted(fs, key=lambda f: int(f.rsplit("_", 1)[1][:-5]))


fails = []
for col in ("blue", "red"):
    oth = "red" if col == "blue" else "blue"
    for key, (was, end) in NEXT.items():
        run = f"{col}_{key}"
        fs = frames(run)
        if not fs:
            print(f"{run}: no frames"); continue
        a, b = men(fs[0]), men(fs[-1])
        h0, h1 = men(frames(f"blue_lead_high{was}")[0]), men(frames(f"blue_lead_high{end}")[0])
        toward = (1 if col == "red" else -1) * (1 if "step_in" in key else -1)   # + = the way he should go, in px
        go = (b[col] - a[col]) * toward
        toe = (b[col + "_toe"] - a[col + "_toe"]) * toward
        still = abs(b[oth] - a[oth])
        e_end = max(abs(b[col] - h1[col]), abs(b[oth] - h1[oth]))
        e_start = max(abs(a[col] - h0[col]), abs(a[oth] - h0[oth]))
        bad = [n for n, ok in (("travel", go >= 25), ("other", still < 5), ("end", e_end <= 6), ("start", e_start <= 6)) if not ok]
        print(f"{run}: travels {go:.0f} px (toe {toe:.0f}), other {still:.0f}, last v '{end or 'Long'}' hold {e_end:.0f}, "
              f"first v '{was or 'Long'}' hold {e_start:.0f}  {'PASS' if not bad else 'FAIL ' + ','.join(bad)}")
        fails += [run] if bad else []
print(f"STEP_TRAVEL {'PASS' if not fails else 'FAIL ' + ' '.join(fails)}")
sys.exit(1 if fails else 0)
