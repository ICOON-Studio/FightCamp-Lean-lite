#!/usr/bin/env python
"""U81's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U81_check.py

Checks the 18 triptych sheets exist, are a 3 x 6 grid of cells at least 320 px, and that
no cell is blank - a headless render saves a black PNG, and a camera pointed at nothing
saves a flat one. It does not judge what the pictures show; Claude looks at them.
"""
import os
import sys

try:
    from PIL import Image, ImageStat
except ImportError:
    print("U81_CHECK FAIL: Pillow is not installed (python -m pip install pillow)")
    sys.exit(1)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT = os.path.join(ROOT, "previews/s4a")
TOOL = os.path.join(ROOT, "Godot/tools/capture_retarget_triptych.gd")
MD = os.path.join(ROOT, "research/U81_TRIPTYCH.md")
CLIPS = ["H2H_JabInPlace", "H2H_HitReaction01", "H2H_StaggerMedium01", "H2H_Idle", "H2H_SlipLeft", "H2H_KnockDown01"]
FIGHTERS = ["f01_m_box_welter", "f02_m_box_heavy", "f06_m_mma_lhw"]
COLS, ROWS, MIN_CELL = 3, 6, 320
MIN_STDDEV = 6.0  # grey levels; a flat or black cell sits near 0

failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


check(os.path.isfile(TOOL), "Godot/tools/capture_retarget_triptych.gd does not exist")
if check(os.path.isfile(MD), "research/U81_TRIPTYCH.md does not exist"):
    md = open(MD, encoding="utf-8").read()
    check("--path Godot" in md and "capture_retarget_triptych.gd" in md, "the markdown does not record the exact command")
    for f in FIGHTERS:
        check(f in md, f"the markdown does not name the population ({f} missing)")

for clip in CLIPS:
    for fighter in FIGHTERS:
        name = f"{clip}__{fighter}.png"
        path = os.path.join(OUT, name)
        if not check(os.path.isfile(path), f"{name} is missing"):
            continue
        try:
            img = Image.open(path).convert("L")
        except Exception as exc:  # noqa: BLE001
            check(False, f"{name} is not a readable image: {exc}")
            continue
        w, h = img.size
        if not check(w >= COLS * MIN_CELL and h >= ROWS * MIN_CELL,
                     f"{name} is {w}x{h}; a 3x6 grid of {MIN_CELL} px cells needs at least {COLS * MIN_CELL}x{ROWS * MIN_CELL}"):
            continue
        cw, ch = w // COLS, h // ROWS
        flat = []
        for r in range(ROWS):
            for c in range(COLS):
                cell = img.crop((c * cw, r * ch, (c + 1) * cw, (r + 1) * ch))
                if ImageStat.Stat(cell).stddev[0] < MIN_STDDEV:
                    flat.append((r, c))
        check(not flat, f"{name}: {len(flat)} blank cell(s), first at row {flat[0][0] + 1} column {flat[0][1] + 1}" if flat else "")
        # A column whose six rows barely differ is a body that never moved. 2026-09-13: the first
        # delivery's MESH column stood in a T-pose in all six rows and still passed a byte-identity
        # check, because each cell prints its own time label. So the label band (top 12% of a cell)
        # is masked, and rows must differ by a real amount, not by a few glyphs.
        band = int(ch * 0.12)
        # An idle breathes; six frames of it may move less than 1% of a cell. The other five
        # clips prove the panels animate, so the idle is exempt from this one check.
        for c in (range(COLS) if clip != "H2H_Idle" else []):
            cells = [img.crop((c * cw, r * ch + band, (c + 1) * cw, (r + 1) * ch)) for r in range(ROWS)]
            diffs = []
            for r in range(1, ROWS):
                a, b = cells[0].tobytes(), cells[r].tobytes()
                diffs.append(sum(1 for x, y in zip(a, b) if abs(x - y) > 24) / max(1, len(a)))
            check(max(diffs) >= 0.01, f"{name}: column {c + 1} changes in under 1% of its pixels across six rows - the body never moved (a rest pose?)")
        # The SOURCE column draws the source SKELETON only. A skinned fighter there means the panels
        # are wired to the wrong viewports (the first delivery showed the animated mesh in column 1).
        rgb = Image.open(path).convert("RGB")
        src = rgb.crop((0, band, cw, h))
        red = sum(1 for (r_, g_, b_) in src.get_flattened_data() if r_ > 150 and g_ < 60 and b_ < 60) / max(1, src.width * src.height)
        check(red < 0.002, f"{name}: the SOURCE column contains glove-red mesh pixels ({red:.3%}) - a fighter mesh is rendering in the source panel")

if failures:
    print(f"U81_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("U81_CHECK PASS")
