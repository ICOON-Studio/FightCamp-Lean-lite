"""S401 the muscle holo as a real scan (operator on the flat cyan figure: "wtf is that it looks like an astraunat"): dark inside, bright
fibres and rim. Run after tools/bake_holo_figure.py: python tools/holo_scan_look.py <in.png> <preview.jpg> <out.png>."""
import sys
import numpy as np
from PIL import Image, ImageFilter

SRC = sys.argv[1]
OUT = sys.argv[2]
SAVE = sys.argv[3] if len(sys.argv) > 3 else ""


def treat(im, fibre=7.0, floor=0.16):
    a = np.asarray(im.convert("RGBA"), dtype=np.float32) / 255.0
    alpha = a[..., 3]
    lum = a[..., :3].mean(axis=2)
    li = Image.fromarray((lum * alpha * 255).astype("uint8"))
    w, h = im.size
    r = max(2, int(h * 0.006))
    blur = np.asarray(li.filter(ImageFilter.GaussianBlur(r)), dtype=np.float32) / 255.0
    bigger = np.asarray(li.filter(ImageFilter.GaussianBlur(r * 5)), dtype=np.float32) / 255.0
    local = np.clip((blur - bigger) * fibre, -1, 1)          # muscle bellies and grooves
    fine = np.clip((lum * alpha - blur) * fibre * 1.6, -1, 1)  # the fibre lines
    ai = Image.fromarray((alpha * 255).astype("uint8"))
    er = np.asarray(ai.filter(ImageFilter.MinFilter(max(3, int(h * 0.006) | 1))), dtype=np.float32) / 255.0
    rim = np.clip(alpha - er, 0, 1)
    v = np.clip(floor + 0.55 * np.clip(local, 0, 1) + 0.5 * np.clip(fine, 0, 1) + 0.9 * rim, 0, 1)
    dark, mid, hot = np.array([0.02, 0.10, 0.20]), np.array([0.10, 0.62, 0.95]), np.array([0.80, 0.97, 1.0])
    t = v[..., None]
    rgb = np.where(t < 0.5, dark + (mid - dark) * (t / 0.5), mid + (hot - mid) * ((t - 0.5) / 0.5))
    out_a = alpha * np.clip(0.55 + 0.45 * v, 0, 1)
    res = np.dstack([rgb, out_a])
    return Image.fromarray((np.clip(res, 0, 1) * 255).astype("uint8"), "RGBA")


src = Image.open(SRC).convert("RGBA")
print("size", src.size)
new = treat(src)
if SAVE:
    new.save(SAVE)
PLATE = (9, 15, 23, 255)


def small(im, h):
    w = int(im.size[0] * h / im.size[1])
    bg = Image.new("RGBA", (w, h), PLATE)
    s = im.resize((w, h), Image.LANCZOS)
    bg.alpha_composite(s)
    return bg


# the size it really shows at (268 tall), then twice that, old on the left, new on the right
a, b, c, d = small(src, 268), small(new, 268), small(src, 536), small(new, 536)
sheet = Image.new("RGBA", (a.width * 2 + c.width * 2 + 50, 546), PLATE)
x = 5
for p in (a, b, c, d):
    sheet.alpha_composite(p, (x, 5))
    x += p.width + 10
sheet.convert("RGB").save(OUT)
