"""layers_cut.py - LAYERS0 (S570): one man per picture, cut from the two-man frames we already have.

Owner S569: "sohow fighting games cope with distance ? what are we doing differently ?" -> ops/research/LAYERS_SCOPE_S569.md
(approved S570 with the Cascadeur + Animo purchase). Every frame with a part mask (MASK1: tools/pics2d_mask.gd, each pixel
the colour of the body part IN FRONT there) is split into two layers: the blue man's pixels and the red man's. Where one
man is in front of the other the mask already says whose pixel it is, so the man behind is cut exactly where the near man
covers him - no new render. The picture's anti-aliased edge (the mask has none) goes to the man whose part is 1 px away.

Each layer frame also records the man's FEET POINT: the mean x of his lowest leg pixels, in metres along the ring line
from the picture's centre (frames.json `camera` px_per_m, scaled to the web size). ring_ui.js (?layers=1) places each
layer at its man's spot and moves the spot by this track.

    python proto/twohands/tools/layers_cut.py [only=<prefix>,<prefix>...]

Writes proto/twohands/img/layers/<run>_<side>_<k>.webp and img/layers/frames.json (merged); prints LAYERS_CUT runs=<n>.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageFilter

HERE = Path(__file__).resolve().parent
ANIM = HERE.parent / "img" / "anim"
OUT = HERE.parent / "img" / "layers"
## tools/pics2d_mask.gd PART, per corner: lead, rear, legs, torso, head
PART = {"blue": [(255, 0, 0), (0, 255, 0), (0, 0, 255), (255, 255, 0), (0, 128, 255)],
        "red": [(255, 0, 255), (0, 255, 255), (255, 128, 0), (128, 0, 255), (255, 0, 128)]}
LEGS = {"blue": (0, 0, 255), "red": (255, 128, 0)}


def side_masks(mask: Image.Image) -> dict:
    """{side: L image 255 where that man's part is in front}, from the palette mask."""
    rgb = mask.convert("RGBA")
    out = {}
    for side, cols in PART.items():
        px = rgb.load()
        m = Image.new("L", rgb.size, 0)
        mp = m.load()
        for y in range(rgb.height):
            for x in range(rgb.width):
                p = px[x, y]
                if p[3] >= 128 and p[:3] in cols:
                    mp[x, y] = 255
        out[side] = m
    return out


def feet_x(mask: Image.Image, side: str) -> float | None:
    """The man's STANCE CENTRE (px): the middle of the span his feet cover on the floor. LAYERS1 (S572): it was the mean x
    of his lowest leg pixels, i.e. whichever foot stood nearer the camera (lower on the raised camera's picture) - a guard
    with the feet set differently read as the man 0.43 m further in (blue in every red cross, his body on the same spot),
    and the page drew him that far off. Now: for every column the lowest pixel of his legs; the FOOT columns are those
    whose lowest pixel is in the bottom 40% of his legs' height (the gap between the legs and the knees are not); the
    stance centre is the middle of the leftmost and rightmost foot column - both feet whatever their depth or overlap."""
    rgb = mask.convert("RGBA")
    px = rgb.load()
    col = {}
    hi = None
    for y in range(rgb.height):
        for x in range(rgb.width):
            p = px[x, y]
            if p[3] >= 128 and p[:3] == LEGS[side]:
                col[x] = y
                hi = y if hi is None else hi
    if not col:
        return None
    lo = max(col.values())
    feet = [x for x, y in col.items() if y >= lo - max(6, int((lo - hi) * 0.40))]
    return (min(feet) + max(feet)) / 2


def main() -> None:
    only = []
    for a in sys.argv[1:]:
        if a.startswith("only="):
            only = [s for s in a[5:].split(",") if s]
    doc = json.loads((ANIM / "frames.json").read_text(encoding="utf-8"))
    cam = doc.get("camera", {})
    web_k = 480 / float(cam.get("render_px", 768))
    ppm = float(cam.get("px_per_m", 243.887)) * web_k   # web px a metre along the ring line
    OUT.mkdir(parents=True, exist_ok=True)
    fj = OUT / "frames.json"
    have = json.loads(fj.read_text(encoding="utf-8")) if fj.exists() else {"runs": {}}
    have["camera"] = {"px_per_m": round(ppm, 3), "web_px": 480, "from": "img/anim/frames.json camera x 480/render_px"}
    n = 0
    for run, row in doc["runs"].items():
        if only and not any(run.startswith(p) for p in only):
            continue
        masks = row.get("masks") or []
        files = row.get("files") or []
        if not masks or len(masks) != len(files):
            continue
        rows = {"blue": {"files": [], "root": []}, "red": {"files": [], "root": []}}
        for k, (f, mf) in enumerate(zip(files, masks)):
            pic = Image.open(ANIM / f).convert("RGBA")
            mask = Image.open(ANIM / mf)
            sm = side_masks(mask)
            for side in ("blue", "red"):
                other = "red" if side == "blue" else "blue"
                keep = sm[side].filter(ImageFilter.MaxFilter(3))            # the AA edge one px out
                keep.paste(0, mask=sm[other])                               # never the other man's own pixels
                a = Image.composite(pic.getchannel("A"), Image.new("L", pic.size, 0), keep)
                lay = pic.copy()
                lay.putalpha(a)
                name = f"{run}_{side}_{k}.webp"
                lay.save(OUT / name, "WEBP", quality=88, method=4)
                fx = feet_x(mask, side)
                rows[side]["files"].append(name)
                rows[side]["root"].append(None if fx is None else round((fx - pic.width / 2) / ppm, 4))
        for side in ("blue", "red"):
            r = dict(rows[side])
            r.update({"of": run, "side": side, "offs": row.get("offs"), "contact": row.get("contact", -1), "range": row.get("range")})
            have["runs"][f"{run}_{side}"] = r
        n += 1
        print(f"LAYERS_CUT {run}: {len(files)} frames, blue feet {rows['blue']['root'][0]} m, red feet {rows['red']['root'][0]} m")
    fj.write_text(json.dumps(have, indent=1), encoding="utf-8")
    print(f"LAYERS_CUT runs={n} -> {OUT}")


if __name__ == "__main__":
    main()
