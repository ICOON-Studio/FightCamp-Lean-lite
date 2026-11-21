"""S534 (owner "Keep painted", Q-S294-289): fit each Ludo paintover of a full-body render back onto the render's canvas.

Ludo's image edit returns 576x800 and can grow or shift the figure, so the cards, the versus screen and FaceFrame's
"fullbody" head boxes would be off. For each painted file this scales the figure so its alpha box has the render's
height, puts its feet on the render's foot line and its centre on the render's centre, on a canvas the render's size.

  python tools/fit_painted_bodies.py <painted_dir> [--src assets/ui/art/fullbody] [--out assets/ui/style_b/fullbody]
"""
import argparse
import os
import sys

from PIL import Image


def fit(painted: Image.Image, render: Image.Image) -> Image.Image:
    rb = render.split()[-1].getbbox()
    pb = painted.split()[-1].getbbox()
    if rb is None or pb is None:
        return painted.resize(render.size)
    fig = painted.crop(pb)
    k = (rb[3] - rb[1]) / float(pb[3] - pb[1])
    fig = fig.resize((max(1, round(fig.width * k)), max(1, round(fig.height * k))), Image.LANCZOS)
    out = Image.new("RGBA", render.size, (0, 0, 0, 0))
    cx = (rb[0] + rb[2]) / 2.0
    out.alpha_composite(fig, (round(cx - fig.width / 2.0), rb[3] - fig.height))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("painted_dir")
    ap.add_argument("--src", default="assets/ui/art/fullbody")
    ap.add_argument("--out", default="assets/ui/style_b/fullbody")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    n = 0
    for f in sorted(os.listdir(a.painted_dir)):
        if not f.endswith(".png"):
            continue
        render_path = os.path.join(a.src, f)
        if not os.path.exists(render_path):
            print("SKIP %s (no render of that name)" % f)
            continue
        render = Image.open(render_path).convert("RGBA")
        painted = Image.open(os.path.join(a.painted_dir, f)).convert("RGBA")
        fit(painted, render).save(os.path.join(a.out, f), optimize=True)
        n += 1
    print("FIT_PAINTED %d files -> %s" % (n, a.out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
