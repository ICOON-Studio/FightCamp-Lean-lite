"""STEPFIX1 (S559): the step runs' picture bars, read from the frames (proto/twohands/img/anim).
For each step run: where each man stands (the middle of his shorts) and the stepping man's front toe, frame 0 and last.
Bars: the stepping man travels toward (step in) / away (back off) at least 25 px; the other man under 5 px; the last
frame within 6 px of the hold pictures of the range it ends on; the first frame within 6 px of the range it starts on.
    python tools/step_travel_check.py [dir] [--hold=<run>]      exit 1 when a bar fails
RINGCAM1 (S559): reads .webp (the page's, 480 px) or .png (a render, 768 px; the px bars scale with the width), the hold
reference is --hold (default blue_lead_high, a run at Long, _r2 and _r1). On the RING camera (frames.json "camera": ring)
the page's hold pictures are the blue man's (he stood in); after a RED step the page slides the picture by the metres
red stood in (RANGE_IN) x axis_px - so a red run is checked against the hold moved by that slide."""
import glob, json, os, sys
from PIL import Image

ARGS = [a for a in sys.argv[1:] if not a.startswith("--")]
D = ARGS[0] if ARGS else "proto/twohands/img/anim"
HOLD = next((a.split("=", 1)[1] for a in sys.argv[1:] if a.startswith("--hold=")), "blue_lead_high")
RANGE_IN = {"": 0.0, "_r2": 0.355, "_r1": 0.55}  # copy of tools/pics2d_anim.gd RANGE_M (INSIDE1 S564)
CAMF = os.path.join(D, "frames.json")
CAM = (json.load(open(CAMF)).get("camera") or {}) if os.path.exists(CAMF) else {}
NEXT = {"step_in_r2": ("", "_r2"), "step_in_r1": ("_r2", "_r1"), "back_off_r3": ("_r2", ""), "back_off_r2": ("_r1", "_r2")}


def men(path):
    im = Image.open(path).convert("RGBA"); w, h = im.size; px = im.load()
    # RINGCAM1: the bands are read off the men's own height in the picture (head top yt to boot sole yb), so a
    # raised camera (the owner's pitch) is read as well as the level one: shorts 40-72 %, boots the lowest 9 %
    bb = im.getchannel("A").point(lambda a: 255 if a >= 128 else 0).getbbox()
    yt, yb = bb[1], bb[3]
    sh0, sh1, lo = yt + 0.40 * (yb - yt), yt + 0.72 * (yb - yt), yb - 0.09 * (yb - yt)
    rs, bs, low = [], [], []
    for y in range(yt, yb):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128 or (r > 235 and g > 235 and b > 235):
                continue
            if sh0 < y < sh1:
                if r > 180 and g < 60 and b < 60: rs.append(x)
                if b > 150 and r < 70 and g < 90: bs.append(x)
            if y > lo: low.append(x)
    red, blue = sum(rs) / len(rs), sum(bs) / len(bs)
    mid = (red + blue) / 2
    return {"red": red, "blue": blue, "red_toe": max(x for x in low if x < mid), "blue_toe": min(x for x in low if x > mid)}


def frames(run):
    for ext in (".webp", ".png"):
        fs = [f for f in glob.glob(os.path.join(D, run + "_*" + ext)) if os.path.basename(f)[len(run) + 1:-len(ext)].isdigit()]
        if fs:
            return sorted(fs, key=lambda f: int(os.path.basename(f)[len(run) + 1:-len(ext)]))
    return []


fails = []
for col in ("blue", "red"):
    oth = "red" if col == "blue" else "blue"
    for key, (was, end) in NEXT.items():
        run = f"{col}_{key}"
        fs = frames(run)
        if not fs:
            print(f"{run}: no frames"); continue
        a, b = men(fs[0]), men(fs[-1])
        h0, h1 = men(frames(f"{HOLD}{was}")[0]), men(frames(f"{HOLD}{end}")[0])
        k = Image.open(fs[0]).size[0] / 480.0   # the bars are page px (480); a 768 px render counts 1.6 px each
        if CAM.get("ring") and col == "red":   # the page slides the blue man's hold by how far red stood in
            for h, rk in ((h0, was), (h1, end)):
                for m in ("red", "blue"):
                    h[m] += RANGE_IN.get(rk, 0.0) * float(CAM["axis_px"][0]) * Image.open(fs[0]).size[0] / float(CAM.get("render_px", 768))   # S564: axis_px is in render px (768); the webp is 480
        toward = (1 if col == "red" else -1) * (1 if "step_in" in key else -1)   # + = the way he should go, in px
        go = (b[col] - a[col]) * toward
        toe = (b[col + "_toe"] - a[col + "_toe"]) * toward
        still = abs(b[oth] - a[oth])
        e_end = max(abs(b[col] - h1[col]), abs(b[oth] - h1[oth]))
        e_start = max(abs(a[col] - h0[col]), abs(a[oth] - h0[oth]))
        bad = [n for n, ok in (("travel", go >= 25 * k), ("other", still < 5 * k), ("end", e_end <= 6 * k), ("start", e_start <= 6 * k)) if not ok]
        print(f"{run}: travels {go:.0f} px (toe {toe:.0f}), other {still:.0f}, last v '{end or 'Long'}' hold {e_end:.0f}, "
              f"first v '{was or 'Long'}' hold {e_start:.0f}  {'PASS' if not bad else 'FAIL ' + ','.join(bad)}")
        fails += [run] if bad else []
print(f"STEP_TRAVEL {'PASS' if not fails else 'FAIL ' + ' '.join(fails)}")
sys.exit(1 if fails else 0)
