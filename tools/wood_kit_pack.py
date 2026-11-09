"""S417: cut Ludo's blank pieces (from the approved Q-S294-159 concept) into the game's wood kit (scripts/ui/WoodKit.gd).
The pieces are `ludo image edit` results of crops of docs/mockups/s416/overview_painted_ludo.png with the words removed.
usage: python tools/wood_kit_pack.py docs/mockups/s417/wood_src assets/ui/wood
"""
import glob
import sys

import numpy as np
from PIL import Image, ImageFilter

src, out = sys.argv[1], sys.argv[2]


def solid_box(im, thr=128):
    a = np.array(im.split()[3]) > thr
    ys, xs = np.where(a)
    return xs.min(), ys.min(), xs.max() + 1, ys.max() + 1


def runs(mask):
    """[start, end) runs of True in a 1-D bool array."""
    r, s = [], None
    for i, v in enumerate(mask):
        if v and s is None:
            s = i
        elif not v and s is not None:
            r.append((s, i)); s = None
    if s is not None:
        r.append((s, len(mask)))
    return r


def buttons(path, scale, min_w):
    """The separate solid pieces of a row of buttons, left to right, each scaled to game size."""
    im = Image.open(path).convert("RGBA")
    a = np.array(im.split()[3]) > 128
    # the button band: rows that are solid across at least a fifth of the width (drops a lamp glow above the row)
    rows = runs(a.sum(axis=1) > im.width * 0.2)
    y0, y1 = max(rows, key=lambda r: r[1] - r[0])
    cols = [r for r in runs(a[y0:y1].sum(axis=0) > (y1 - y0) * 0.5) if r[1] - r[0] >= min_w]
    res = []
    for x0, x1 in cols:
        piece = im.crop((x0, y0, x1, y1))
        bx = solid_box(piece)
        piece = piece.crop(bx)
        w, h = round(piece.width * scale), round(piece.height * scale)
        res.append(piece.resize((w, h), Image.LANCZOS))
    return res


# ---- the framed slate: a composite so the board is not blown up from a small picture
P = Image.open(glob.glob(src + "/out_panel/*v1.png")[0]).convert("RGBA")
_a = np.array(P.split()[3]) > 128   # the frame's own edges: lines that are mostly solid (drops stray specks and shadow)
_cols = np.where(_a.sum(axis=0) > P.height * 0.5)[0]
_rows = np.where(_a.sum(axis=1) > P.width * 0.5)[0]
P = P.crop((_cols.min(), _rows.min(), _cols.max() + 1, _rows.max() + 1))
S = P.resize((P.width // 2, P.height // 2), Image.LANCZOS)
M = 52                       # corner piece kept unscaled (the brass plate is about 47 px)
W, H = 960, 600
panel = Image.new("RGBA", (W, H), (0, 0, 0, 0))
# the board, from the full-size picture, turned on its side (the source is upright, cards are wide)
inner = P.crop((2 * M + 30, 2 * M + 30, P.width - 2 * M - 30, P.height - 2 * M - 30)).rotate(90, expand=True)
board = inner.resize((W - 2 * M + 40, H - 2 * M + 40), Image.LANCZOS)
sw, sh = S.size
top = S.crop((M, 0, sw - M, M)).resize((W - 2 * M, M), Image.LANCZOS)
bot = S.crop((M, sh - M, sw - M, sh)).resize((W - 2 * M, M), Image.LANCZOS)
lef = S.crop((0, M, M, sh - M)).resize((M, H - 2 * M), Image.LANCZOS)
rig = S.crop((sw - M, M, sw, sh - M)).resize((M, H - 2 * M), Image.LANCZOS)
panel.paste(top, (M, 0)); panel.paste(bot, (M, H - M)); panel.paste(lef, (0, M)); panel.paste(rig, (W - M, M))
panel.paste(S.crop((0, 0, M, M)), (0, 0)); panel.paste(S.crop((sw - M, 0, sw, M)), (W - M, 0))
panel.paste(S.crop((0, sh - M, M, sh)), (0, H - M)); panel.paste(S.crop((sw - M, sh - M, sw, sh)), (W - M, H - M))
# the frame's own strip of slate (its inner shadow) fades out toward the middle, over the full-size board: no seam
yy, xx = np.mgrid[0:H, 0:W]
d = np.minimum(np.minimum(xx, W - 1 - xx), np.minimum(yy, H - 1 - yy)).astype(np.float32)
ramp = np.clip((M - d) / 22.0, 0.0, 1.0)
fa = np.array(panel)
fa[..., 3] = (fa[..., 3].astype(np.float32) * ramp).astype(np.uint8)
frame = Image.fromarray(fa, "RGBA")
under = Image.new("RGBA", (W, H), (0, 0, 0, 0))
under.paste(board.convert("RGBA"), (M - 20, M - 20))
panel = Image.alpha_composite(under, frame)
panel.save(out + "/panel.png", optimize=True)
print("panel", panel.size, "border", M)

# ---- buttons
tabs = buttons(glob.glob(src + "/out_tabs/*v1.png")[0], 0.25, 200)
tabs[0].save(out + "/tab_on.png"); tabs[1].save(out + "/tab.png")
print("tab_on", tabs[0].size, "tab", tabs[1].size)
tops = buttons(glob.glob(src + "/out_topbtns/*.png")[0], 1 / 3.0, 200)
tops[0].save(out + "/plank.png"); tops[1].save(out + "/plank_on.png")
print("plank", tops[0].size, "plank_on", tops[1].size)
red = max(buttons(glob.glob(src + "/out_redbtn/*.png")[0], 0.25, 100), key=lambda p: p.width)
red.save(out + "/red.png")
print("red", red.size)
bar = Image.open(glob.glob(src + "/out_topbar/*.png")[0]).convert("RGBA")
bar = bar.crop(solid_box(bar))
bar.convert("RGB").save(out + "/bar.png", optimize=True)
print("bar", bar.size)
