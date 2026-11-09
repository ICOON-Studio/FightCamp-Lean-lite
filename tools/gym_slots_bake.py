"""gym_slots_bake.py - S415: the gym the player buys up, cut from the owner's own picture.

Operator S415: "Yes, start small", then "use this one it has full equipment now ?" (Downloads/Modern MMA Gym Facility Layout.png).
Run tools/gym_slots_diff.py first: it writes the emptied hall (base_display.png) and the mask of what differs (diff.png) to
E:/FightCamp/tmp/s415_full. gym.png there is his picture with the lettering retouched off the bags. This writes:
  assets/ui/art/gym_main.jpg         his picture (the bake's source, kept for reference)
  assets/ui/art/gym_empty.jpg        his picture with the hall's equipment gone, the wall kit kept, the cage under repair
  assets/ui/art/gym_slots/<id>.png   one cut-out per piece, his own pixels with a soft edge
  assets/data/gym_slots.json         each piece: name, kind, price, places, start, and where it stands on the picture
    python tools/gym_slots_bake.py      # prints how far the whole set is from his picture
Prices are retail snapshots: ops/research/GYM_SLOTS_S415.md. Places per kind are GymPlaces.PLACES_OF, cardio 1.
"""
import json
from pathlib import Path

import cv2
import numpy as np

TMP = Path("E:/FightCamp/tmp/s415_full")
ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "assets/ui/art/gym_slots"
NO_BAGS = TMP / "nobags/editImage-841eb8c6.png"
NO_DUMMY = TMP / "nodummy/editImage-3c46b2ac.png"
CAGE_REPAIR = TMP / "cage/editImage-44e0343e-v1.png"
REPAIR_RECT = (552, 140, 370, 282)
KIT_SRC = TMP / "kit_reg_v1.png"
BAG_CENTRES = (602.5, 669.5, 735, 802.5, 870, 938.75, 1004.5)
BAG_W, BAG_TOP, BAG_BOTTOM = 34, 446, 530
DUMMY_PATCH = [(1012, 505, 52, 123), (1040, 622, 46, 104), (1005, 600, 65, 32), (1035, 702, 60, 32)]
FLOOR_LESS_W = 0   # seven bags and the rail fill the width of this floor


def piece(id_, name, kind, price, places, rect, start=False, locked=False, also=None):
    return {"id": id_, "name": name, "kind": kind, "price": price, "places": places, "rect": rect, "start": start, "locked": locked, "also": also or []}


SLOTS = [
    piece("ring", "Boxing ring", "ring", 3500, 10, (938, 150, 312, 262), start=True, also=[(1040, 412, 92, 12)]),
    piece("cage", "Cage", "ring", 0, 10, (565, 150, 345, 272), locked=True),
    piece("mat_blue", "Mat area with circle", "mat", 2340, 18, (1262, 172, 312, 206)),
    piece("bag_floor", "Bag floor and rail", "mat", 2340, 3, (528, 420, 574, 330), start=True),
    piece("dummy", "Punching dummy", "bag", 420, 1, (1012, 505, 52, 124)),
    piece("reflex", "Reflex bag", "bag", 240, 1, (1035, 622, 56, 110)) | {"move": (-84, -92)},   # the smaller floor ends above where it stood
]
SLOTS += [piece("bag_f%d" % (i + 1), "Heavy bag", "bag", 570, 1, (int(c - BAG_W), BAG_TOP, BAG_W * 2 if i < 6 else 52, BAG_BOTTOM - BAG_TOP), start=True)
          for i, c in enumerate(BAG_CENTRES)]
SLOTS += [piece("bag_b%d" % (i + 1), "Heavy bag, back wall", "bag", 570, 1, r)
          for i, r in enumerate([(930, 34, 38, 104), (972, 34, 38, 104), (1015, 34, 36, 104), (1102, 34, 36, 104), (1147, 34, 38, 104), (1188, 34, 40, 104), (1340, 34, 38, 104), (1428, 34, 38, 104)])]
SLOTS += [piece("tear_%d" % (i + 1), "Teardrop bag", "bag", 155, 1, r) for i, r in enumerate([(1062, 34, 30, 72), (1388, 34, 30, 72)])]
SLOTS += [piece("tread_%d" % (i + 1), "Treadmill", "cardio", 3200, 1, r, start=i < 2)
          for i, r in enumerate([(1149, 650, 64, 102), (1213, 650, 62, 102), (1275, 650, 66, 102)])]
SLOTS += [piece("bike_%d" % (i + 1), "Exercise bike", "cardio", 2300, 1, r)
          for i, r in enumerate([(1346, 658, 42, 94), (1394, 658, 42, 94), (1447, 658, 42, 94), (1500, 658, 43, 94)])]
SLOTS += [piece("rack_%d" % (i + 1), "Power rack", "rack", 1300, 4, r)
          for i, r in enumerate([(1160, 414, 100, 126), (1267, 414, 107, 126), (1387, 414, 124, 126), (1530, 414, 100, 106)])]
SLOTS += [
    piece("db_tower", "Dumbbell tower", "rack", 1050, 4, (1096, 440, 62, 208)),
    piece("db_1", "Dumbbell rack", "rack", 1050, 4, (1172, 545, 118, 26)),
    piece("db_2", "Dumbbell rack", "rack", 1050, 4, (1172, 571, 128, 33)),
    piece("db_3", "Dumbbell rack", "rack", 1050, 4, (1174, 605, 142, 43)),
    piece("stacks", "Dumbbell stacks", "rack", 1050, 4, (1469, 545, 72, 106)),
    piece("plates", "Weight plate rack", "rack", 1050, 4, (1562, 520, 60, 92)),
    piece("wall_rack", "Kettlebell rack", "rack", 1050, 4, (1252, 166, 38, 178)),
    piece("side_rack", "Dumbbell rack, side wall", "rack", 1050, 4, (1540, 178, 62, 176)),
    piece("bench_1", "Bench", "bench", 400, 2, (1323, 543, 92, 38)),
    piece("bench_2", "Bench", "bench", 400, 2, (1325, 586, 110, 30)),
    piece("bench_3", "Bench", "bench", 400, 2, (1328, 624, 113, 30)),
    piece("bench_4", "Bench", "bench", 400, 2, (1283, 366, 76, 32)),
    piece("bench_5", "Bench", "bench", 400, 2, (1435, 366, 94, 32)),
    piece("turf", "Turf strip with ladder", "mat", 1400, 4, (1545, 615, 112, 134)),
]
## S415 the kit his picture lacked, added to a copy of it by Ludo (kit_reg_v1.png, lined up on it): price 0 and start = comes with the club.
## S415 operator: "these items are out of position at the entrance": they stand along the front wall either side of a clear aisle to the
## doors, a quarter smaller than painted (they were large beside the treadmills). "at" = left edge and foot on the picture.
KIT_SCALE = 0.75
KIT = [
    piece("scales", "Weighing scales", "kit", 0, 0, (528, 640, 44, 104), start=True) | {"at": (488, 740)},
    piece("treatment", "Treatment table", "kit", 0, 0, (698, 636, 89, 108), start=True) | {"at": (526, 740)},
    piece("mirrors", "Tall mirrors", "mirror", 800, 4, (577, 606, 120, 138)) | {"at": (598, 740)},
    piece("tape_tv", "Screen for watching tape", "kit", 0, 0, (799, 614, 65, 128), start=True) | {"at": (945, 740)},
    piece("conditioning", "Plyo boxes and medicine balls", "mat", 550, 4, (872, 658, 107, 80)) | {"at": (998, 740)},
    piece("corner_kit", "Water bucket", "kit", 0, 0, (981, 687, 35, 48), start=True) | {"at": (1082, 740)},
    piece("timer", "Round timer and stool", "kit", 0, 0, (1018, 652, 46, 88), start=True) | {"at": (1110, 740)},
]


def soften(mask):
    return (cv2.GaussianBlur(mask.astype(np.float32) / 255.0, (0, 0), 1.2))[..., None]


def filled(mask, rect, also=()):
    part = np.zeros(mask.shape, np.uint8)
    for x, y, w, h in [rect] + list(also):
        part[y:y + h, x:x + w] = mask[y:y + h, x:x + w]
    contours, _ = cv2.findContours(part, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    out = np.zeros(mask.shape, np.uint8)
    cv2.drawContours(out, [c for c in contours if cv2.contourArea(c) > 40], -1, 255, -1)
    out = cv2.dilate(out, np.ones((5, 5), np.uint8))
    clip = np.zeros(mask.shape, np.uint8)
    for x, y, w, h in [rect] + list(also):
        clip[y:y + h, x:x + w] = 255
    return cv2.bitwise_and(out, clip)


def diff_mask(a, b, threshold):
    d = cv2.absdiff(cv2.GaussianBlur(a, (0, 0), 1.2), cv2.GaussianBlur(b, (0, 0), 1.2)).max(axis=2)
    return ((d > threshold) * 255).astype(np.uint8)


def registered(path, main, patch):
    H, W = main.shape[:2]
    edit = cv2.resize(cv2.imread(str(path)), (W, H), interpolation=cv2.INTER_AREA)
    fixed = cv2.bitwise_not(cv2.dilate(patch, np.ones((25, 25), np.uint8)))
    a = cv2.GaussianBlur(cv2.cvtColor(main, cv2.COLOR_BGR2GRAY), (5, 5), 0)
    b = cv2.GaussianBlur(cv2.cvtColor(edit, cv2.COLOR_BGR2GRAY), (5, 5), 0)
    warp = np.eye(2, 3, dtype=np.float32)
    crit = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 300, 1e-6)
    cc, warp = cv2.findTransformECC(a, b, warp, cv2.MOTION_AFFINE, crit, fixed, 5)
    print(path.parent.name, "registered, ECC", round(cc, 4))
    return cv2.warpAffine(edit, warp, (W, H), flags=cv2.INTER_LINEAR | cv2.WARP_INVERSE_MAP, borderMode=cv2.BORDER_REPLICATE)


def floor_without_bags(main):
    """His picture with Ludo's patches where the bags, the dummy and the reflex bag were, so the floor can stand before they are bought."""
    H, W = main.shape[:2]
    out = main.astype(np.float32)
    for path, rects in ((NO_BAGS, [(int(c - BAG_W), BAG_TOP + 6, BAG_W * 2, BAG_BOTTOM - BAG_TOP - 6) for c in BAG_CENTRES]), (NO_DUMMY, DUMMY_PATCH)):
        patch = np.zeros((H, W), np.uint8)
        for x, y, w, h in rects:
            patch[y:y + h, x:x + w] = 255
        soft = cv2.GaussianBlur(patch.astype(np.float32) / 255.0, (0, 0), 3)[..., None]
        out = registered(path, main, patch) * soft + out * (1 - soft)
    return out.round().astype(np.uint8)


def shrink_floor(src, alpha):
    """S415 operator: "make the red marked are a bit smaller to fit more things". Takes a strip out right of the last bag and two
    tile rows out of the depth, and bends the rows below so the slanted borders run on straight."""
    H, W = src.shape[:2]
    x1, dw = 993, FLOOR_LESS_W
    src, alpha = src.copy(), alpha.copy()
    if dw > 0:
        src[:, x1:W - dw] = src[:, x1 + dw:W].copy()
        alpha[:, x1:W - dw] = alpha[:, x1 + dw:W].copy()
        alpha[:, W - dw:] = 0
    grey = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)[:, 600:900].mean(axis=1)
    b0 = 575 + int(np.argmin(grey[575:612]))
    b1 = b0 + 80 + int(np.argmin(grey[b0 + 80:b0 + 112]))
    dy = b1 - b0
    print("floor: width -%d, depth -%d (tile lines at %d and %d)" % (dw, dy, b0, b1))

    def edges(y):
        xs = np.where(alpha[y, :, 0] > 0.5)[0]
        return float(xs.min()), float(xs.max())

    (l1, r1), (l2, r2) = edges(470), edges(716)
    left = lambda y: l1 + (l2 - l1) * (y - 470) / 246.0
    right = lambda y: r1 + (r2 - r1) * (y - 470) / 246.0
    mx = np.tile(np.arange(W, dtype=np.float32), (H, 1))
    my = np.tile(np.arange(H, dtype=np.float32)[:, None], (1, W))
    for y in range(b0, H):
        ys = min(y + dy, H - 1)
        k = (right(ys) - left(ys)) / (right(y) - left(y))
        mx[y] = left(ys) + (np.arange(W, dtype=np.float32) - left(y)) * k
        my[y] = ys
    out = cv2.remap(src, mx, my, cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    a = cv2.remap(alpha[..., 0].astype(np.float32), mx, my, cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=0)
    a[H - dy:] = 0
    return out, a[..., None]


def paste(canvas, img, r):
    al = img[..., 3:].astype(np.float32) / 255.0
    y, x = r["y"], r["x"]
    canvas[y:y + r["h"], x:x + r["w"]] = canvas[y:y + r["h"], x:x + r["w"]] * (1 - al) + img[..., :3] * al


def main():
    picture = cv2.imread(str(TMP / "gym.png"))
    cv2.imwrite(str(ROOT / "assets/ui/art/gym_main.jpg"), picture, [cv2.IMWRITE_JPEG_QUALITY, 96])
    base = cv2.imread(str(TMP / "base_display.png"))
    m = cv2.imread(str(TMP / "diff.png"), 0)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for old in OUT_DIR.glob("*.png"):
        old.unlink()
    floor = floor_without_bags(picture)
    # The wall kit stays from the first day: what differs outside every slot goes back into the empty room.
    decor = m.copy()
    for s in SLOTS:
        for x, y, w, h in [s["rect"]] + s["also"]:
            decor[y:y + h, x:x + w] = 0
    a = soften(cv2.dilate(decor, np.ones((5, 5), np.uint8)))
    empty = (picture * a + base * (1 - a)).round().astype(np.uint8)
    # S415 operator: "keep the cage but make it looked like it is under repair": in the boxing demo it stands there, not for sale.
    repair = cv2.resize(cv2.imread(str(CAGE_REPAIR)), (empty.shape[1], empty.shape[0]), interpolation=cv2.INTER_AREA)
    a = soften(filled(diff_mask(repair, base, 20), REPAIR_RECT))
    empty = (repair * a + empty * (1 - a)).round().astype(np.uint8)
    cv2.imwrite(str(ROOT / "assets/ui/art/gym_empty.jpg"), empty, [cv2.IMWRITE_JPEG_QUALITY, 93])
    rows, images = [], {}
    whole, start = empty.astype(np.float32), empty.astype(np.float32)
    for s in sorted(SLOTS, key=lambda r: (r["id"] != "bag_floor", r["rect"][1] + r["rect"][3])):
        src = picture
        if s["id"] == "bag_floor":
            src, mask = floor, filled(m, s["rect"])
        elif s["id"].startswith("bag_f"):
            mask = filled(diff_mask(picture, floor, 24), s["rect"])
        elif s["id"] in ("dummy", "reflex"):
            mask = filled(diff_mask(picture, floor, 24), s["rect"])
        elif s["id"] == "mat_blue":   # by its colour: racks stand close along its edges
            x, y, w, h = s["rect"]
            blue = ((picture[..., 0].astype(int) > picture[..., 1].astype(int) + 40) * 255).astype(np.uint8)
            blue = cv2.morphologyEx(blue, cv2.MORPH_CLOSE, np.ones((9, 9), np.uint8))
            mask = filled(blue, s["rect"])
        elif s["id"].startswith("bench_"):   # dark pads on a dark floor: the coarse mask misses them
            mask = filled(diff_mask(picture, base, 15), s["rect"])
        else:
            mask = filled(m, s["rect"], s["also"])
        alpha = soften(mask)
        if s["id"] == "bag_floor":
            src, alpha = shrink_floor(src, alpha)
        ys, xs = np.where(alpha[..., 0] > 0.02)
        x0, x1, y0, y1 = int(xs.min()), int(xs.max()) + 1, int(ys.min()), int(ys.max()) + 1
        rgba = np.dstack([src[y0:y1, x0:x1], (alpha[y0:y1, x0:x1, 0] * 255).round().astype(np.uint8)])
        cv2.imwrite(str(OUT_DIR / (s["id"] + ".png")), rgba, [cv2.IMWRITE_PNG_COMPRESSION, 9])
        r = {k: v for k, v in s.items() if k not in ("rect", "also", "move")} | {"x": x0 + s.get("move", (0, 0))[0], "y": y0 + s.get("move", (0, 0))[1], "w": x1 - x0, "h": y1 - y0}
        rows.append(r)
        if not s["locked"]:
            paste(whole, rgba, r)
            if s["start"]:
                paste(start, rgba, r)
    (ROOT / "assets/data/gym_slots.json").write_text(json.dumps({"size": [picture.shape[1], picture.shape[0]], "slots": rows}, indent=1), encoding="utf8")
    d = np.abs(whole - picture.astype(np.float32)).max(axis=2)
    cx, cy, cw, ch = next(s["rect"] for s in SLOTS if s["id"] == "cage")
    d[cy:cy + ch, cx:cx + cw] = 0
    print("pieces", len(rows), "start places", sum(s["places"] for s in SLOTS if s["start"]), "all places", sum(s["places"] for s in SLOTS if not s["locked"]))
    print("everything bought vs his picture, outside the cage: pixels off by more than 40:", int((d > 40).sum()), "of", d.size)
    kit_img = cv2.imread(str(KIT_SRC))
    red = (kit_img[..., 2] > 140) & (kit_img[..., 1] < 95) & (kit_img[..., 0] < 95)
    for s in sorted(KIT, key=lambda r: r["rect"][1] + r["rect"][3]):
        d = cv2.absdiff(cv2.GaussianBlur(picture, (0, 0), 1.2), cv2.GaussianBlur(kit_img, (0, 0), 1.2)).max(axis=2)
        d[red] = 0   # the kit picture redrew the red border a little to the side: never part of a piece
        raw = ((d > 26) * 255).astype(np.uint8)
        raw = cv2.morphologyEx(raw, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
        raw = cv2.morphologyEx(raw, cv2.MORPH_CLOSE, np.ones((11, 11), np.uint8))
        alpha = soften(filled(raw, s["rect"]))
        low = (kit_img[..., 2] > 105) & (kit_img[..., 1] < 85) & (kit_img[..., 0] < 85)
        low[:722] = False   # only the old mat's bottom band goes: medicine balls and digits are red too
        if s["id"] == "scales":
            low[:, 575:] = False
            low[625:, :575] |= red[625:, :575]
        low = cv2.dilate(low.astype(np.uint8), np.ones((5, 5), np.uint8)).astype(np.float32)
        alpha = alpha * (1.0 - low)[..., None]
        ys, xs = np.where(alpha[..., 0] > 0.02)
        x0, x1, y0, y1 = int(xs.min()), int(xs.max()) + 1, int(ys.min()), int(ys.max()) + 1
        colour = kit_img[y0:y1, x0:x1].copy()
        if s["id"] == "corner_kit":   # the painted bucket picked up the red floor
            g = colour.mean(axis=2, keepdims=True)
            colour = (g * 0.8 + colour * 0.2).round().astype(np.uint8)
        rgba = np.dstack([colour, (alpha[y0:y1, x0:x1, 0] * 255).round().astype(np.uint8)])
        small = (max(1, round((x1 - x0) * KIT_SCALE)), max(1, round((y1 - y0) * KIT_SCALE)))
        rgba = cv2.resize(rgba, small, interpolation=cv2.INTER_AREA)
        cv2.imwrite(str(OUT_DIR / (s["id"] + ".png")), rgba, [cv2.IMWRITE_PNG_COMPRESSION, 9])
        r = {k: v for k, v in s.items() if k not in ("rect", "also", "at")} | {"x": s["at"][0], "y": s["at"][1] - small[1], "w": small[0], "h": small[1]}
        rows.append(r)
        paste(whole, rgba, r)
        if s["start"]:
            paste(start, rgba, r)
    rows.sort(key=lambda r: (r["id"] != "bag_floor", r["y"] + r["h"]))
    (ROOT / "assets/data/gym_slots.json").write_text(json.dumps({"size": [picture.shape[1], picture.shape[0]], "slots": rows}, indent=1), encoding="utf8")
    print("with the kit: pieces", len(rows), "start places", sum(r["places"] for r in rows if r["start"]), "all places", sum(r["places"] for r in rows if not r["locked"]))
    cv2.imwrite(str(TMP / "bake_all.jpg"), whole.round().clip(0, 255).astype(np.uint8))
    cv2.imwrite(str(TMP / "bake_start.jpg"), start.round().clip(0, 255).astype(np.uint8))


if __name__ == "__main__":
    main()
