"""Cuts the four fighters' and the old trainer's faces from the game's studio portraits into round-ready squares on the
gym pin's navy. Run from this folder."""
from PIL import Image, ImageFilter
import numpy as np

FACE = "../../../../assets/ui/face/"
# name -> (file, centre x, centre y, half side) in the 720x900 portrait
WHO = {"lucy": ("studio/mh_boxer_11.jpg", 362, 300, 205), "samira": ("studio/mh_boxer_20.jpg", 366, 305, 205),
       "tess": ("studio/mh_boxer_22.jpg", 350, 318, 205), "ana": ("studio/mh_boxer_17.jpg", 378, 300, 215)}
NAVY_IN, NAVY_OUT = (52, 68, 108), (23, 33, 61)
OUT = 360

for name, (f, cx, cy, r) in WHO.items():
    im = Image.open(FACE + f).convert("RGB").crop((cx - r, cy - r, cx + r, cy + r)).resize((OUT, OUT), Image.LANCZOS)
    a = np.array(im).astype(float)
    bg = np.median(np.concatenate([a[:6, :, :].reshape(-1, 3), a[:, :6, :].reshape(-1, 3)]), axis=0)
    dist = np.sqrt(((a - bg) ** 2).sum(2))
    alpha = np.clip((dist - 16.0) / 26.0, 0, 1)
    al = Image.fromarray((alpha * 255).astype("uint8")).filter(ImageFilter.MedianFilter(5)).filter(ImageFilter.GaussianBlur(0.8))
    alpha = np.array(al).astype(float)[..., None] / 255.0
    yy, xx = np.mgrid[0:OUT, 0:OUT]
    t = np.clip(np.sqrt((xx - OUT / 2) ** 2 + (yy - OUT * 0.42) ** 2) / (OUT * 0.62), 0, 1)[..., None]
    back = np.array(NAVY_IN) * (1 - t) + np.array(NAVY_OUT) * t
    out = a * alpha + back * (1 - alpha)
    Image.fromarray(out.astype("uint8")).save("face_%s.png" % name)
    print(name, [int(v) for v in bg])

# the old trainer (the guide): a black studio back, flooded from the edges
from collections import deque
im = Image.open(FACE + "mh_staff_trainer.jpg").convert("RGB").crop((372 - 235, 280 - 235, 372 + 235, 280 + 235)).resize((OUT, OUT), Image.LANCZOS)
a = np.array(im).astype(float)
mx = a.max(2)
bgm = np.zeros((OUT, OUT), bool)
dq = deque()
for i in range(OUT):
    for y, x in ((0, i), (i, 0), (i, OUT - 1)):
        if mx[y, x] < 20 and not bgm[y, x]:
            bgm[y, x] = True
            dq.append((y, x))
while dq:
    y, x = dq.popleft()
    for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        yy, xx2 = y + dy, x + dx
        if 0 <= yy < OUT and 0 <= xx2 < OUT and not bgm[yy, xx2] and mx[yy, xx2] < 20:
            bgm[yy, xx2] = True
            dq.append((yy, xx2))
al = Image.fromarray((~bgm * 255).astype("uint8")).filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.MinFilter(7)).filter(ImageFilter.GaussianBlur(1.0))
alpha = np.array(al).astype(float)[..., None] / 255.0
yy, xx = np.mgrid[0:OUT, 0:OUT]
t = np.clip(np.sqrt((xx - OUT / 2) ** 2 + (yy - OUT * 0.42) ** 2) / (OUT * 0.62), 0, 1)[..., None]
back = np.array(NAVY_IN) * (1 - t) + np.array(NAVY_OUT) * t
Image.fromarray((a * alpha + back * (1 - alpha)).astype("uint8")).save("face_trainer.png")
