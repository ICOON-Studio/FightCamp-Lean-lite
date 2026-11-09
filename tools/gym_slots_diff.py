# Lines the emptied room up with the owner's picture, keeps his pixels outside the main hall, finds each piece as what differs.
import sys
import numpy as np
from PIL import Image, ImageDraw
import cv2

OUT = "E:/FightCamp/tmp/s415_slots/"
main = cv2.imread("E:/FightCamp/Lean/assets/ui/art/gym_main.jpg")
empty = cv2.imread(OUT + "empty/editImage-2ad7a344-v2.png")
H, W = main.shape[:2]
print("sizes", main.shape, empty.shape)
empty = cv2.resize(empty, (W, H), interpolation=cv2.INTER_AREA)

# Register on the building's fixed parts only: the rooms at the left, the front wall, the pavement.
fixed = np.zeros((H, W), np.uint8)
fixed[20:735, 20:560] = 255
fixed[740:900, 20:W - 20] = 255
a = cv2.GaussianBlur(cv2.cvtColor(main, cv2.COLOR_BGR2GRAY), (5, 5), 0)
b = cv2.GaussianBlur(cv2.cvtColor(empty, cv2.COLOR_BGR2GRAY), (5, 5), 0)
warp = np.eye(2, 3, dtype=np.float32)
crit = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 300, 1e-6)
cc, warp = cv2.findTransformECC(a, b, warp, cv2.MOTION_AFFINE, crit, fixed, 5)
print("ECC", round(cc, 4), "warp", np.round(warp, 4).tolist())
reg = cv2.warpAffine(empty, warp, (W, H), flags=cv2.INTER_LINEAR | cv2.WARP_INVERSE_MAP, borderMode=cv2.BORDER_REPLICATE)

reg0 = reg.copy()
# The AI floor is a little brighter or darker in places: match its broad light to his, on floor pixels only.
for it in range(3):
    w = (cv2.absdiff(cv2.GaussianBlur(main, (0, 0), 2), cv2.GaussianBlur(reg, (0, 0), 2)).max(axis=2) < (46 if it == 0 else 22)).astype(np.float32)
    wb = cv2.GaussianBlur(w, (0, 0), 24) + 1e-4
    low_m = np.dstack([cv2.GaussianBlur((main[..., c].astype(np.float32)) * w, (0, 0), 24) / wb for c in range(3)])
    low_r = np.dstack([cv2.GaussianBlur((reg[..., c].astype(np.float32)) * w, (0, 0), 24) / wb for c in range(3)])
    reg = (reg.astype(np.float32) * np.clip(low_m / (low_r + 1.0), 0.6, 1.6)).clip(0, 255).astype(np.uint8)

# His pixels everywhere but the main hall (the hall's floor and its walls' lower items).
hall = np.zeros((H, W), np.float32)
cv2.fillPoly(hall, [np.array([[582, 14], [1590, 14], [1652, 746], [552, 746], [568, 190]], np.int32)], 1.0)
soft = cv2.GaussianBlur(hall, (0, 0), 3)[..., None]
base = (reg * soft + main * (1 - soft)).round().astype(np.uint8)
cv2.imwrite(OUT + "base.png", base)

# What differs is a piece.
d = cv2.absdiff(cv2.GaussianBlur(main, (0, 0), 1.2), cv2.GaussianBlur(base, (0, 0), 1.2)).max(axis=2)
m = ((d > 28) * 255).astype(np.uint8)
m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))
m = cv2.morphologyEx(m, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
m[hall < 0.5] = 0
cv2.imwrite(OUT + "diff.png", m)

# The base that is shown: one smooth light correction across the hall, so no halo stays where a piece stood.
yy, xx = np.mgrid[0:H, 0:W]
X, Y = xx / W, yy / H
A = np.stack([X ** i * Y ** j for i in range(4) for j in range(4 - i)], -1)
floor = (hall > 0.5) & (cv2.dilate(m, np.ones((31, 31), np.uint8)) == 0) & (yy > 112)
sel = np.flatnonzero(floor.ravel())[::7]
shown = reg0.astype(np.float64).copy()
for c in range(3):
    ratio = (main[..., c].astype(np.float64) + 1.0) / (reg0[..., c].astype(np.float64) + 1.0)
    coef, *_ = np.linalg.lstsq(A.reshape(-1, A.shape[-1])[sel], ratio.ravel()[sel], rcond=None)
    shown[..., c] *= np.clip((A @ coef), 0.7, 1.4)
    print("channel", c, "floor pixels", sel.size, "ratio left over (std)", round(float((ratio / (A @ coef)).ravel()[sel].std()), 3))
cv2.imwrite(OUT + "base_display.png", (shown.clip(0, 255) * soft + main * (1 - soft)).round().astype(np.uint8))
n, lab, stats, cent = cv2.connectedComponentsWithStats(m, 8)
rows = sorted([(int(stats[i][1]), int(stats[i][0]), int(stats[i][2]), int(stats[i][3]), int(stats[i][4])) for i in range(1, n) if stats[i][4] >= 180])
print("pieces", len(rows))
vis = Image.fromarray(cv2.cvtColor(main, cv2.COLOR_BGR2RGB))
dr = ImageDraw.Draw(vis)
for k, (y, x, w, h, area) in enumerate(rows):
    dr.rectangle([x, y, x + w, y + h], outline=(255, 255, 0))
    dr.text((x + 2, y + 2), str(k), fill=(0, 255, 255))
    print(k, "x", x, "y", y, "w", w, "h", h, "area", area)
vis.save(OUT + "pieces.png")
