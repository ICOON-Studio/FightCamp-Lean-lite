# S353 (operator: "stop doing tubes and shit", "use a real muscular holo"; "holo looks fine"): the body figure's picture is a
# bought female ecorche (CGTrader #6489289, royalty-free, kept OUTSIDE the repo in E:/FightCamp/licensed/ecorche_aaaxis)
# rendered as a hologram by tools/holo_render_blender.py. This crops that render and writes beside it what BodyFigure needs:
#   assets/ui/body/holo_f.png       the holo (RGBA, see-through inside, lit rim)
#   assets/ui/body/holo_f.json      the six places [x, y, rx, ry] + "track" strokes, fractions of the picture (bake_body_portraits)
#   assets/ui/body/holo_f_mask.png  part index * 32 per pixel (BodyFigure.MASK_KEYS order), the bake_body_masks.gd rule
#   blender -b <ecorche.blend> --python tools/holo_render_blender.py -- E:/FightCamp/gen/s353_holo/holo_f2.png
#   python tools/bake_holo_figure.py E:/FightCamp/gen/s353_holo/holo_f2.png
import json
import sys

import numpy as np
from PIL import Image

SRC = sys.argv[1] if len(sys.argv) > 1 else "E:/FightCamp/gen/s353_holo/holo_f2.png"
OUT = "assets/ui/body/holo_f"
SCALE = 0.7          # 900x1500 render -> ~610 px wide: the panel never shows it bigger
PAD = 8
PPM = 1500 / 2.0033  # render pixels per metre (ortho 2.0033 m over 1500 px)
KEYS = ["core", "left_shoulder", "right_shoulder", "left_arm", "right_arm", "legs"]
MASK_STEP = 32
NECK_GAP = 0.012

# Landmarks read off the 900x1500 render on a 25 px grid. Front view: her RIGHT is on the viewer's LEFT (BodyFigure's rule).
HEAD = (450, 119, 64, 92)
EYE_R, EYE_L = (425, 118.5), (475, 118.5)
EYE_RAD = 14
NOSE = (450, 150, 10, 14)
RIBS_R, RIBS_L = (395, 465), (505, 465)
RIB_RX, RIB_RY = 0.055 * PPM, 0.075 * PPM
# Her right arm (viewer's left); the left one mirrors at x = 900 - x.
CLAV, SHOULDER, ELBOW, HAND = (420, 270), (318, 305), (228, 560), (65, 755)
HIP, KNEE = (395, 735), (380, 1120)
HIPS_C, CHEST_C = (450, 700), (450, 400)


def lerp(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)


def mirror(p):
    return (900 - p[0], p[1])


def main() -> None:
    im = Image.open(SRC).convert("RGBA")
    l, t, r, b = im.getbbox()
    crop = (max(0, l - PAD), max(0, t - PAD), min(im.width, r + PAD), min(im.height, b + PAD))
    cw, ch = crop[2] - crop[0], crop[3] - crop[1]

    def fr(p, rx=0.0, ry=0.0):
        return [round((p[0] - crop[0]) / cw, 4), round((p[1] - crop[1]) / ch, 4), round(rx / cw, 4), round(ry / ch, 4)]

    out = {
        "head": fr(HEAD[:2], HEAD[2], HEAD[3]),
        "left_eye": fr(EYE_L, EYE_RAD, EYE_RAD), "right_eye": fr(EYE_R, EYE_RAD, EYE_RAD),
        "nose": fr(NOSE[:2], NOSE[2], NOSE[3]),
        "left_ribs": fr(RIBS_L, RIB_RX, RIB_RY), "right_ribs": fr(RIBS_R, RIB_RX, RIB_RY),
    }

    def stroke(pts, w_m):
        return {"pts": [fr(p)[:2] for p in pts], "w": round(w_m * PPM / cw, 4)}

    track = {}
    for side, f in (("right", lambda p: p), ("left", mirror)):
        cl, up, lo, hd = f(CLAV), f(SHOULDER), f(ELBOW), f(HAND)
        track[side + "_shoulder"] = stroke([lerp(cl, up, 0.45), lerp(up, lo, 0.22)], 0.10)
        track[side + "_arm"] = stroke([lerp(up, lo, 0.38), lo, lerp(lo, hd, 0.8)], 0.07)
        th, kn = f(HIP), f(KNEE)
        track["legs_" + side] = stroke([lerp(th, kn, 0.12), lerp(th, kn, 0.92)], 0.12)
    track["core"] = stroke([lerp(HIPS_C, CHEST_C, 0.25), lerp(HIPS_C, CHEST_C, 0.95)], 0.17)
    out["track"] = track
    out["holo"] = True

    pic = im.crop(crop)
    pic = pic.resize((round(cw * SCALE), round(ch * SCALE)), Image.LANCZOS)
    pic.save(OUT + ".png", optimize=True)
    with open(OUT + ".json", "w", encoding="utf-8", newline="\n") as fh:
        json.dump(out, fh, indent=2)
    mask = mask_of(np.asarray(pic), track)
    Image.fromarray(mask, "L").save(OUT + "_mask.png", optimize=True)
    print("HOLO %s %dx%d crop=%s" % (OUT, pic.width, pic.height, crop))


def mask_of(px: np.ndarray, track: dict) -> np.ndarray:
    """bake_body_masks.gd mask_of: each opaque pixel below the neck goes to the nearest stroke, in stroke widths."""
    h, w = px.shape[:2]
    segs = []
    neck_y = float(h)
    for place, st in track.items():
        key = "legs" if place.startswith("legs") else place
        idx = KEYS.index(key) + 1
        pts = [(p[0] * w, p[1] * h) for p in st["pts"]]
        hw = max(1.0, st["w"] * w * 0.5)
        for a, b in zip(pts, pts[1:]):
            segs.append((np.array(a), np.array(b), hw, idx))
        if key.endswith("shoulder"):
            neck_y = min(neck_y, min(p[1] for p in pts))
    neck_y -= NECK_GAP * h
    ys, xs = np.mgrid[0:h, 0:w]
    p = np.stack([xs + 0.5, ys + 0.5], axis=-1).astype(np.float32)
    best = np.full((h, w), np.inf, dtype=np.float32)
    idx = np.zeros((h, w), dtype=np.uint8)
    for a, b, hw, i in segs:
        ab = (b - a).astype(np.float32)
        t = np.clip(((p - a) @ ab) / max(float(ab @ ab), 1e-6), 0.0, 1.0)
        d = np.linalg.norm(p - (a + t[..., None] * ab), axis=-1) / hw
        sel = d < best
        best[sel] = d[sel]
        idx[sel] = i
    opaque = px[..., 3] >= 0.1 * 255
    idx[~opaque] = 0
    idx[: int(max(0.0, neck_y)), :] = 0
    return (idx * MASK_STEP).astype(np.uint8)


if __name__ == "__main__":
    main()
