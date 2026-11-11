"""Cuts the 3D figure out of today's Overview (docs/mockups/s431/ref/overview_today.png) into figure.png.
The backdrop there is near black, so the figure is everything a flood from the picture's edge cannot reach."""
import pathlib
from collections import deque
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

HERE = pathlib.Path(__file__).resolve().parent
im = Image.open(HERE.parent / "ref" / "overview_today.png").convert("RGB")
big = im.crop((120, 498, 320, 956)).resize((400, 916), Image.LANCZOS)
mx = np.asarray(big).astype(int).max(2)
h, w = mx.shape
yy, xx = np.mgrid[0:h, 0:w]
mx[(xx < 122) & (yy > 540) & (yy < 740)] = 0          # a dim thing behind the left knee is backdrop
dark = mx < 30
out = np.zeros((h, w), bool)
dq = deque()
for s in [(0, x) for x in range(w)] + [(h - 1, x) for x in range(w)] + [(y, 0) for y in range(h)] + [(y, w - 1) for y in range(h)]:
    if dark[s] and not out[s]:
        out[s] = True
        dq.append(s)
while dq:
    y, x = dq.popleft()
    for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        y2, x2 = y + dy, x + dx
        if 0 <= y2 < h and 0 <= x2 < w and dark[y2, x2] and not out[y2, x2]:
            out[y2, x2] = True
            dq.append((y2, x2))
A = Image.fromarray(np.where(out, 0, 255).astype(np.uint8))
# the boots are black on black: their outlines are traced by hand so they stay solid on a lighter floor
d = ImageDraw.Draw(A)
d.polygon([(168, 714), (230, 702), (240, 720), (258, 745), (262, 800), (262, 832), (240, 845), (222, 856), (142, 860), (138, 850), (152, 838),
           (178, 820), (192, 790), (186, 760), (172, 738), (166, 724)], fill=255)
d.polygon([(262, 730), (310, 724), (336, 724), (340, 760), (343, 800), (347, 840), (347, 868), (320, 887), (230, 882), (226, 873), (250, 860),
           (262, 840), (262, 800), (258, 745)], fill=255)
A = A.filter(ImageFilter.GaussianBlur(1.3)).point(lambda v: max(0, min(255, int((v - 80) * 255 / 140))))
res = big.convert("RGBA")
res.putalpha(A)
res = res.crop(res.getbbox())
res.save(HERE / "figure.png")
print(res.size)
