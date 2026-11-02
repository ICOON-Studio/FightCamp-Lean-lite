#!/usr/bin/env python
"""U82's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U82_check.py

U81's checks on all 36 sheets (front and side), plus the one U82 exists for: in the knockdown
sheets the SOURCE man's highest point must sink down the cell between the first and the last
row - which only happens when the frame is fixed over all six rows. Per-cell framing is what
made a floating body look grounded.
"""
import os
import sys

try:
    from PIL import Image, ImageStat
except ImportError:
    print("U82_CHECK FAIL: Pillow is not installed")
    sys.exit(1)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT = os.path.join(ROOT, "previews/s4a")
CLIPS = ["H2H_JabInPlace", "H2H_HitReaction01", "H2H_StaggerMedium01", "H2H_Idle", "H2H_SlipLeft", "H2H_KnockDown01"]
FIGHTERS = ["f01_m_box_welter", "f02_m_box_heavy", "f06_m_mma_lhw"]
COLS, ROWS, MIN_CELL = 3, 6, 320
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def top_of_body(cell):
    """Fraction of the cell height at which the first clearly non-background row sits."""
    w, h = cell.size
    bg = cell.getpixel((2, h - 3))
    px = cell.load()
    for y in range(h):
        hits = 0
        for x in range(0, w, 2):
            p = px[x, y]
            if sum(abs(p[i] - bg[i]) for i in range(3)) > 90:
                hits += 1
        if hits >= 3:
            return y / h
    return 1.0


for clip in CLIPS:
    for fighter in FIGHTERS:
        for suffix in ("", "__side"):
            name = f"{clip}__{fighter}{suffix}.png"
            path = os.path.join(OUT, name)
            if not check(os.path.isfile(path), f"{name} is missing"):
                continue
            rgb = Image.open(path).convert("RGB")
            grey = rgb.convert("L")
            w, h = rgb.size
            if not check(w >= COLS * MIN_CELL and h >= ROWS * MIN_CELL, f"{name} is {w}x{h}, smaller than a 3x6 grid of {MIN_CELL} px"):
                continue
            cw, ch = w // COLS, h // ROWS
            band = int(ch * 0.12)
            for r in range(ROWS):
                for c in range(COLS):
                    cell = grey.crop((c * cw, r * ch, (c + 1) * cw, (r + 1) * ch))
                    check(ImageStat.Stat(cell).stddev[0] >= 6.0, f"{name}: blank cell at row {r + 1} column {c + 1}")
            if clip != "H2H_Idle":
                for c in range(COLS):
                    cells = [grey.crop((c * cw, r * ch + band, (c + 1) * cw, (r + 1) * ch)).tobytes() for r in range(ROWS)]
                    diff = max(sum(1 for x, y in zip(cells[0], cells[r]) if abs(x - y) > 24) / max(1, len(cells[0])) for r in range(1, ROWS))
                    check(diff >= 0.01, f"{name}: column {c + 1} barely changes across the six rows (a rest pose?)")
            src = rgb.crop((0, band, cw, h))
            red = sum(1 for (r_, g_, b_) in src.get_flattened_data() if r_ > 150 and g_ < 60 and b_ < 60) / max(1, src.width * src.height)
            check(red < 0.002, f"{name}: glove-red mesh pixels in the SOURCE column ({red:.3%})")
            if clip == "H2H_JabInPlace":
                # 2026-09-13: a re-render put the retarget one row AHEAD of the source - fully extended at
                # 0.17 s while the source still guarded. The jab's widest row (the extension) must be the
                # same row in the SOURCE and RETARGET SKELETON columns. The floor line sits in the bottom of
                # the cell, so only the upper 75% is read.
                def widest_row(col):
                    widths = []
                    for rr in range(ROWS):
                        cell = rgb.crop((col * cw, rr * ch + band, (col + 1) * cw, rr * ch + int(ch * 0.75)))
                        bgc = cell.getpixel((2, 2))
                        cpx = cell.load()
                        xs_ = [xx for yy in range(0, cell.height, 3) for xx in range(0, cell.width, 2)
                               if sum(abs(cpx[xx, yy][i] - bgc[i]) for i in range(3)) > 90]
                        widths.append((max(xs_) - min(xs_)) if xs_ else 0)
                    return widths.index(max(widths)), widths
                src_row, src_w = widest_row(0)
                tgt_row, tgt_w = widest_row(1)
                check(src_row == tgt_row, f"{name}: the jab is widest in row {src_row + 1} of SOURCE but row {tgt_row + 1} of RETARGET SKELETON - the two columns are sampled at different times")
            if clip == "H2H_KnockDown01":
                # 2026-09-13 (U82 first delivery): the MESH column's first row showed the previous clip's
                # final lying pose at t=0.00 while the skeleton beside it stood - captured before the new
                # pose was applied. At t=0 a knockdown's man is standing: his mesh must be taller than wide.
                cell = rgb.crop((2 * cw, band, 3 * cw, ch))
                bg = cell.getpixel((2, cell.height - 3))
                px = cell.load()
                xs, ys = [], []
                for yy in range(0, cell.height, 2):
                    for xx in range(0, cell.width, 2):
                        q = px[xx, yy]
                        # skin and gloves only: the grey floor ruler is unsaturated and would stretch the box
                        if sum(abs(q[i] - bg[i]) for i in range(3)) > 90 and max(q) - min(q) > 40:
                            xs.append(xx)
                            ys.append(yy)
                if check(xs, f"{name}: the mesh cell at t=0 is empty"):
                    wbox, hbox = max(xs) - min(xs), max(ys) - min(ys)
                    check(hbox > wbox, f"{name}: at t=0.00 the mesh is {wbox}x{hbox} px, wider than tall - a lying pose left over from the previous capture, not the clip's first frame")
                # Judged on the SOURCE column: the source clip really puts its man on the floor, so in a
                # frame fixed over all six rows his highest point must sink most of the way down the cell.
                # Measured on U81's per-cell framing: +0.28. A fixed frame lands near +0.7. The retarget
                # columns are NOT gated here - whether they float is the finding, not a pass condition.
                first = top_of_body(rgb.crop((0, band, cw, ch)))
                last = top_of_body(rgb.crop((0, 5 * ch + band, cw, 6 * ch)))
                check(last - first >= 0.5,
                      f"{name}: the source's highest point sinks only {last - first:+.2f} of the cell between rows 1 and 6 - the frame still follows the body")

if failures:
    print(f"U82_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("U82_CHECK PASS")
