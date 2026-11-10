## S421: the stylised portraits (assets/ui/style_b/portraits) came on a near-black backdrop, so dark skin vanished on the slate
## pages (Luke Reid on Club People). This keys the flat backdrop out from the corners and lays the S387 studio slate
## (0.50, 0.55, 0.60, a soft light from the top) behind the figure: python tools/portrait_backdrop.py <in.png> <out.png>
import sys
from PIL import Image, ImageDraw, ImageFilter
import numpy as np
src, dst = sys.argv[1], sys.argv[2]
im = Image.open(src).convert('RGB')
a = np.asarray(im).astype(int)
h, w, _ = a.shape
corners = np.concatenate([a[:20,:20].reshape(-1,3), a[:20,-20:].reshape(-1,3)])
bg = np.median(corners, axis=0)
# flood fill from the top corners and side edges on a mask of "close to the backdrop"
close = (np.abs(a - bg).max(axis=2) <= 14).astype(np.uint8) * 255
m = Image.fromarray(close)
seed = Image.new('L', (w, h), 0)
filled = m.copy()
for x, y in [(2, 2), (w - 3, 2), (2, h // 2), (w - 3, h // 2)]:
    if filled.getpixel((x, y)) == 255:
        ImageDraw.floodfill(filled, (x, y), 128)
mask = (np.asarray(filled) == 128).astype(np.uint8) * 255
mask = Image.fromarray(mask).filter(ImageFilter.GaussianBlur(1.2))
target = (np.array([0.50, 0.55, 0.60]) * 255).astype(int)
# a soft vertical light: a touch brighter at the top, like the studio set
grad = np.linspace(1.08, 0.92, h)[:, None, None]
plate = np.clip(target[None, None, :] * grad, 0, 255).astype(np.uint8) * np.ones((h, w, 3), np.uint8)
out = Image.composite(Image.fromarray(plate), im, mask)
out.save(dst)
print(dst, 'bg', bg, 'keyed %.0f%%' % (100 * (np.asarray(mask) > 128).mean()))
