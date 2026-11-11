"""Cuts the real 3D figure out of ref/overview_today.png into figure.png (RGBA). Run from this folder."""
from collections import deque
from PIL import Image, ImageFilter, ImageDraw
import numpy as np

SRC = "../ref/overview_today.png"
BOX = (104, 496, 330, 958)   # the figure on today's Overview
K = 4                        # work scale
T = 22                       # brighter than this = figure

im = Image.open(SRC).convert("RGB").crop(BOX)
big = im.resize((im.size[0] * K, im.size[1] * K), Image.LANCZOS)
a = np.array(big).astype(int)
mx = a.max(2)
h, w = mx.shape
bg = np.zeros((h, w), bool)
dq = deque()
seeds = [(y, x) for x in range(w) for y in (0, h - 1)] + [(y, x) for y in range(h) for x in (0, w - 1)]
seeds += [(400, 310), (380, 300), (430, 316)]   # the gap between the glove and the shoulder
for y, x in seeds:
    if mx[y, x] < T and not bg[y, x]:
        bg[y, x] = True
        dq.append((y, x))
while dq:
    y, x = dq.popleft()
    for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        yy, xx = y + dy, x + dx
        if 0 <= yy < h and 0 <= xx < w and not bg[yy, xx] and mx[yy, xx] < T:
            bg[yy, xx] = True
            dq.append((yy, xx))
fg = Image.fromarray((~bg * 255).astype("uint8"))
d = ImageDraw.Draw(fg)
# lighter patches of the old background that are not the figure
for box in [(0, 560, 120, 720), (120, 1100, 318, 1440), (0, 0, 120, 140), (664, 1180, 760, 1430)]:
    d.rectangle(box, fill=0)
# the black boots (black on black: drawn by hand from the 3x zoom; zoom origin (100,490) -> here (104,496))
def z(pts):
    return [((100 + X / 3.0 - BOX[0]) * K, (490 + Y / 3.0 - BOX[1]) * K) for X, Y in pts]
left = [(322, 1092), (372, 1076), (428, 1050), (446, 1100), (452, 1250), (452, 1300), (440, 1322), (278, 1318), (268, 1300),
        (286, 1272), (332, 1232), (324, 1150)]
right = [(452, 1118), (545, 1102), (572, 1126), (580, 1300), (582, 1346), (410, 1352), (400, 1334), (416, 1310), (456, 1282),
         (450, 1200)]
d.polygon(z(left), fill=255)
d.polygon(z(right), fill=255)
fg = fg.filter(ImageFilter.MaxFilter(9)).filter(ImageFilter.MinFilter(9))    # close pin holes
fg = fg.filter(ImageFilter.MinFilter(5)).filter(ImageFilter.MaxFilter(5))    # drop specks
fg = fg.filter(ImageFilter.MinFilter(3))                                     # pull the edge in off the dark fringe
soft = fg.filter(ImageFilter.GaussianBlur(1.8))
out = big.convert("RGBA")
out.putalpha(soft)
out = out.resize((w // 2, h // 2), Image.LANCZOS)   # 2x the source: 452 x 924
out.save("figure.png")
print(out.size)
