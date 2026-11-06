"""Studio portraits on a dark gym-toned backdrop: keys out the flat grey-blue, keeps the soft natural light on the fighter."""
import glob
import os
import numpy as np
from PIL import Image, ImageFilter

SRC = 'E:/FightCamp/Lean/assets/ui/face/studio/'
OUT = 'E:/FightCamp/tmp/s393/menu/dark/'
os.makedirs(OUT, exist_ok=True)
for p in glob.glob(SRC + '*.jpg'):
    im = Image.open(p).convert('RGB')
    a = np.asarray(im).astype(np.float32)
    h, w, _ = a.shape
    bg = np.median(np.concatenate([a[:60, :60].reshape(-1, 3), a[:60, -60:].reshape(-1, 3)]), axis=0)
    d = np.sqrt(((a - bg) ** 2).sum(axis=2))
    m = np.clip((d - 16.0) / 26.0, 0.0, 1.0)
    mask = Image.fromarray((m * 255).astype(np.uint8)).filter(ImageFilter.MedianFilter(5)).filter(ImageFilter.GaussianBlur(1.2))
    m = np.asarray(mask).astype(np.float32)[..., None] / 255.0
    yy, xx = np.mgrid[0:h, 0:w]
    r = np.sqrt(((xx - w * .5) / (w * .62)) ** 2 + ((yy - h * .3) / (h * .62)) ** 2)
    g = np.clip(1.0 - r, 0.0, 1.0)[..., None]
    back = np.array([14, 18, 26], np.float32) + g * np.array([34, 40, 50], np.float32)
    # a little contrast on the fighter, darker toward the edges of the frame
    fig = np.clip((a - 128.0) * 1.08 + 122.0, 0, 255)
    out = fig * m + back * (1 - m)
    Image.fromarray(out.astype(np.uint8)).save(OUT + os.path.basename(p), quality=93)
print(len(glob.glob(OUT + '*.jpg')))
